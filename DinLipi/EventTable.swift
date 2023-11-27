//
//  EventTable.swift
//  DinLipi
//
//  Created by kuet on 27/11/23.
//

import UIKit
import FirebaseDatabase

class EventTable: UIViewController {

    @IBOutlet var eventTable: UITableView!
    @IBOutlet var addnote: UIButton!
    @IBOutlet var homebutton: UIButton!
       var eventT: [EventC] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupAddButton()
        setupNavigationBar() 
                eventTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                eventTable.delegate = self
                eventTable.dataSource = self
                fetchDataFromFirebase()

        // Do any additional setup after loading the view.
    }
    func setupNavigationBar() {
           // Create a UIBarButtonItem for the "Home" button
           let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))

           // Set the left bar button items
           navigationItem.leftBarButtonItems = [homeButton]

           // Create a UIBarButtonItem with the "Add" title
           let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))

           // Set the button on the right side of the navigation bar
           navigationItem.rightBarButtonItem = addButton
       }

       @objc func homeButtonTapped() {
           print("Home button tapped!")
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
           self.navigationController?.pushViewController(vc, animated: true)
           // Add your code to navigate to the home screen
       }

       @objc func addButtonTapped() {
           print("Add button tapped!")
           let vc = self.storyboard?.instantiateViewController(withIdentifier: "Events") as! Events
           self.navigationController?.pushViewController(vc, animated: true)
           // Add your code to handle the "Add" button action
       }

       func fetchDataFromFirebase() {
           guard let userID = UserDataManager.shared.currentUserID else {
               print("User ID is nil.")
               return
           }

           let database = Database.database().reference().child("events").child(userID)

           database.queryOrdered(byChild: "timestamp")
               .queryLimited(toLast: 10)
               .observeSingleEvent(of: .value) { snapshot in
                   guard let eventData = snapshot.children.allObjects as? [DataSnapshot] else {
                       print("No data found.")
                       return
                   }

                   self.eventT.removeAll()

                   for eventSnapshot in eventData {
                       let dateFormatter = DateFormatter()
                       dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                       if let eventData = eventSnapshot.value as? [String: Any],
                          let event = eventData["eventText"] as? String,
                          let priority = eventData["priority"] as? Int,
                          let dateString = eventData["date"] as? String,
                          let date = dateFormatter.date(from: dateString),
                          let timestamp = eventData["timestamp"] as? String {
                           let event = EventC(event: event, priority: priority, date: date, timestamp: timestamp)
                           self.eventT.insert(event, at: 0)
                       }
                   }

                   DispatchQueue.main.async {
                       self.eventTable.reloadData()
                   }
               }
       }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension EventTable: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventT.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let fontSize: CGFloat = 17
        let numberOfLines = 3
        let additionalPadding: CGFloat = 10
        let estimatedHeight = fontSize * CGFloat(numberOfLines) + additionalPadding

        return estimatedHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let event = eventT[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = dateFormatter.string(from: event.date)

        let infoText = "\(formattedDate)  \(event.event)"
        cell.textLabel?.text = infoText

        // Set text color based on priority
        switch event.priority {
        case 0:
            cell.textLabel?.textColor = UIColor.systemGreen
        case 1:
            cell.textLabel?.textColor = UIColor.systemOrange
        case 2:
            cell.textLabel?.textColor = UIColor.systemRed
        default:
            cell.textLabel?.textColor = UIColor.black
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < eventT.count else {
            print("Index out of range. IndexPath.row: \(indexPath.row), noteT count: \(eventT.count)")
            return
        }

        let selectedNote = eventT[indexPath.row]

        if let noteDetailsVC = storyboard?.instantiateViewController(withIdentifier: "EventDetails") as? EventDetails {
            noteDetailsVC.event = selectedNote
            navigationController?.pushViewController(noteDetailsVC, animated: true)
        } else {
            print("Failed to instantiate EventDetailsViewController.")
        }
    }
}


