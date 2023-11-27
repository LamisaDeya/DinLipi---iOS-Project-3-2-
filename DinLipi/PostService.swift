//
//  PostService.swift
//  DinLipi
//
//  Created by IQBAL MAHAMUD on 25/11/23.

import UIKit
import Firebase

struct ToDoItem {
    var title: String
    var isComplete: Bool
    var id: String
    var date: Date
    
    init(keyID: String, dictionary: [String: Any]) {
        self.title = dictionary["title"] as? String ?? ""
        self.isComplete = dictionary["isComplete"] as? Bool ?? false
        self.id = dictionary["id"] as? String ?? ""
        
        if let dateString = dictionary["date"] as? String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd" // Adjust the format based on your data
            if let convertedDate = dateFormatter.date(from: dateString) {
                self.date = convertedDate
            } else {
                self.date = Date() // Default value if date parsing fails
            }
        } else {
            self.date = Date() // Default value if date is not a string
        }
    }
}



struct PostService {
    static let shared = PostService()
    let DB_REF = Database.database().reference()
    
    func fetchAllItems(completion: @escaping([ToDoItem]) -> Void) {
        if let userID = UserDataManager.shared.currentUserID {
            DB_REF.child("items").child(userID).observe(.value) { (snapshot) in
                var allItems = [ToDoItem]()

                for dateSnapshot in snapshot.children {
                    if let dateChildSnapshot = dateSnapshot as? DataSnapshot {
                        for taskSnapshot in dateChildSnapshot.childSnapshot(forPath: "tasks").children {
                            if let taskChildSnapshot = taskSnapshot as? DataSnapshot,
                               let dictionary = taskChildSnapshot.value as? [String: Any] {
                                let todoItem = ToDoItem(keyID: taskChildSnapshot.key, dictionary: dictionary)
                                allItems.append(todoItem)
                            }
                        }
                    }
                }

                // Manually sort the items based on the isComplete flag (incomplete tasks first)
                allItems.sort { !$0.isComplete && $1.isComplete }

                completion(allItems)
            }
        }
    }

    func fetchSingleItem(userID: String, date: String, taskID: String, completion: @escaping(ToDoItem) -> Void) {
        DB_REF.child("items").child(userID).child(date).child("tasks").child(taskID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let todoItem = ToDoItem(keyID: taskID, dictionary: dictionary)
            completion(todoItem)
        }
    }
    
    

    
    func uploadTodoItem(text: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let userID = UserDataManager.shared.currentUserID else {
            print("User ID not available.")
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())

        let values = ["title": text, "isComplete": false, "date": currentDate] as [String: Any]

        let userRef = DB_REF.child("items").child(userID)
        let dateRef = userRef.child(currentDate)

        // Check if a node with the current date already exists
        dateRef.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                // If the node exists, add the task to the existing node
                let taskRef = dateRef.child("tasks").childByAutoId()
                taskRef.updateChildValues(values) { (err, ref) in
                    if let error = err {
                        completion(error, ref)
                    } else {
                        // Once the initial values are set, update the 'id' field
                        let idValue = ["id": taskRef.key!]
                        taskRef.updateChildValues(idValue) { (idUpdateError, idUpdateRef) in
                            // Call the completion block after the second update
                            completion(idUpdateError, idUpdateRef)

                            // Update the "progress" node
                            self.updateProgressNode(userRef: userRef, currentDate: currentDate, isComplete: false)
                        }
                    }
                }
            } else {
                // If the node does not exist, create a new node with the task
                let newTaskRef = dateRef.child("tasks").childByAutoId()
                newTaskRef.updateChildValues(values) { (err, ref) in
                    if let error = err {
                        completion(error, ref)
                    } else {
                        // Once the initial values are set, update the 'id' field
                        let idValue = ["id": newTaskRef.key!]
                        newTaskRef.updateChildValues(idValue) { (idUpdateError, idUpdateRef) in
                            // Call the completion block after the second update
                            completion(idUpdateError, idUpdateRef)

                            // Update the "progress" node
                            self.updateProgressNode(userRef: userRef, currentDate: currentDate, isComplete: false)
                        }
                    }
                }
            }
        }
    }

    // Helper function to update the "progress" node
    // Helper function to update the "progress" node
    // Helper function to update the "progress" node
    private func updateProgressNode(userRef: DatabaseReference, currentDate: String, isComplete: Bool) {
        let dateRef = userRef.child(currentDate)
        let progressRef = dateRef.child("progress")

        progressRef.runTransactionBlock({ (currentData: MutableData) -> TransactionResult in
            var completedCount = currentData.childData(byAppendingPath: "completed").value as? Int ?? 0
            var incompletedCount = currentData.childData(byAppendingPath: "incompleted").value as? Int ?? 0

            print("Before Update - Completed Count: \(completedCount), Incompleted Count: \(incompletedCount)")

            completedCount = 0
            incompletedCount = incompletedCount + 1

            print("After Update - Completed Count: \(completedCount), Incompleted Count: \(incompletedCount)")

            let progressValues = ["completed": completedCount, "incompleted": incompletedCount, "date": currentDate]

            currentData.value = progressValues

            return TransactionResult.success(withValue: currentData)
        })
    }

    
    func updateItemStatus(userID: String, date: String, taskID: String, isComplete: Bool, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let value = ["isComplete": isComplete]

        // Construct the correct reference
        let taskRef = DB_REF.child("items").child(userID).child(date).child("tasks").child(taskID)

        taskRef.updateChildValues(value) { (error, reference) in
            if let error = error {
                completion(error, reference)
            } else {
                // Update the "progress" node
                self.updateProgressNode(userID: userID, date: date) { (progressError, progressReference) in
                    // Call the completion block after updating both task and progress nodes
                    completion(progressError, progressReference)
                }
            }
        }
    }

    // Helper function to update the "progress" node
    private func updateProgressNode(userID: String, date: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let dateRef = DB_REF.child("items").child(userID).child(date)
        let progressRef = dateRef.child("progress")

        progressRef.observeSingleEvent(of: .value) { (snapshot) in
            var completedCount = snapshot.childSnapshot(forPath: "completed").value as? Int ?? 0
            var incompletedCount = snapshot.childSnapshot(forPath: "incompleted").value as? Int ?? 0

            completedCount += 1
            incompletedCount -= 1
            

            let progressValues = ["completed": completedCount, "incompleted": incompletedCount, "date":date]
            progressRef.setValue(progressValues) { (progressError, progressReference) in
                completion(progressError, progressReference)
            }
        }
    }



    // Function to observe changes in the sorted list
    func observeSortedItems(completion: @escaping ([ToDoItem]) -> Void) {
        DB_REF.child("items").queryOrdered(byChild: "isComplete").observe(.value) { (snapshot) in
            var allItems = [ToDoItem]()

            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                   let dictionary = childSnapshot.value as? [String: Any] {
                    let todoItem = ToDoItem(keyID: childSnapshot.key, dictionary: dictionary)
                    allItems.append(todoItem)
                }
            }

            // Manually sort the items based on the isComplete flag (incomplete tasks first)
            allItems.sort { !$0.isComplete && $1.isComplete }

            completion(allItems)
        }
    }
    
}
