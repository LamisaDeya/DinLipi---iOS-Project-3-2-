import Foundation
import Firebase



class MemoriesViewModel: ObservableObject {
    @Published var memories: [Memory] = []

    init() {
        fetchMemories()
    }

    func fetchMemories() {
        if let userID = UserDataManager.shared.currentUserID {
            let databaseRef = Database.database().reference()
            let memoriesRef = databaseRef.child("memories").child(userID)

            // Order memories by timestamp in descending order
            memoriesRef.queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value) { snapshot in
                var fetchedMemories: [Memory] = []

                // Loop through the children in reverse order to get most current first
                for child in snapshot.children.reversed() {
                    if let childSnapshot = child as? DataSnapshot,
                       let memoryData = childSnapshot.value as? [String: Any] {
                        let id = childSnapshot.key
                        let title = memoryData["title"] as? String ?? ""
                        let description = memoryData["description"] as? String ?? ""
                        let date = memoryData["date"] as? String ?? ""
                        let imageURL = memoryData["imageURL"] as? String ?? ""

                        let memory = Memory(id: id, date: date, title: title, description: description, imageUrl: imageURL)
                        fetchedMemories.append(memory)
                    }
                }

                self.memories = fetchedMemories
            }
        }
    }
    func fetchMemoriesInThisDay() {
        if let userID = UserDataManager.shared.currentUserID {
            let databaseRef = Database.database().reference()
            let memoriesRef = databaseRef.child("memories").child(userID)

            memoriesRef.observe(.value) { snapshot in
                var fetchedMemories: [Memory] = []
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let todayDateString = dateFormatter.string(from: Date())
                print(todayDateString)

                //let todayDateString = DateFormatter.memoryDateFormat.string(from: Date())

                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                       let memoryData = childSnapshot.value as? [String: Any] {
                        let id = childSnapshot.key
                        let title = memoryData["title"] as? String ?? ""
                        let description = memoryData["description"] as? String ?? ""
                        let dateString = memoryData["date"] as? String ?? ""
                        let imageURL = memoryData["imageUrl"] as? String ?? ""

                        // Extract month and day components from the date string
                        let todayMonthDay = todayDateString.dropFirst(5) // Assuming date is in "yyyy-MM-dd" format
                        let memoryMonthDay = dateString.dropFirst(5)
                        let todayYear = todayDateString.prefix(4)
                        let memoryYear = dateString.prefix(4)

                        print(todayMonthDay)
                        print(memoryMonthDay)

                        // Compare month and day components
                        if (todayMonthDay == memoryMonthDay && todayYear != memoryYear)  {
                            let memory = Memory(id: id, date: dateString, title: title, description: description, imageUrl: imageURL)
                            fetchedMemories.append(memory)
                        }
                    }
                }

                self.memories = fetchedMemories
            }
        }
    }

}


