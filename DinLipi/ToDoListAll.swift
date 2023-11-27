import UIKit
import FirebaseDatabase

class ToDoListAll: UITableViewController {
    
    
    @IBOutlet var toDoListTable: UITableView!
    var listT: [ListC] = []

    override func viewDidLoad() {
        super.viewDidLoad()
            toDoListTable.delegate = self
            toDoListTable.dataSource = self
            toDoListTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell") // Register the cell identifier
            fetchDataFromFirebase()
    }
    
    func fetchDataFromFirebase() {
        guard let userID = UserDataManager.shared.currentUserID else {
            print("User ID is nil.")
            return
        }

        let database = Database.database().reference().child("items").child(userID)

        database.observeSingleEvent(of: .value) { snapshot in
            guard let dateNodes = snapshot.children.allObjects as? [DataSnapshot] else {
                print("No data found.")
                return
            }

            self.listT.removeAll()

            for dateNode in dateNodes {
                let date = dateNode.key
                if let progressNode = dateNode.childSnapshot(forPath: "progress").value as? [String: Any],
                   let completed = progressNode["completed"] as? Int,
                   let incompleted = progressNode["incompleted"] as? Int {
                    let list = ListC(completed: completed, incompleted: incompleted, date: date)
                    self.listT.append(list)
                    print(date)
                    print(completed)
                    print(incompleted)
                }
            }

            DispatchQueue.main.async {
                self.toDoListTable.reloadData()
            }
        }
    }
    }

extension ToDoListAll {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listT.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let list = listT[indexPath.row]
        let totalTasks = list.completed + list.incompleted
        let progressPercentage = totalTasks > 0 ? (Double(list.completed) / Double(totalTasks)) * 100 : 0
 
        let infoText = "\(list.date)        progress:\(progressPercentage)%"

        // Set the text and text color
        cell.textLabel?.text = infoText
        
        if progressPercentage < 40 {
            cell.textLabel?.textColor = .systemRed
          } else if progressPercentage >= 40 && progressPercentage < 80 {
              cell.textLabel?.textColor = .systemOrange
          } else {
              cell.textLabel?.textColor = .systemGreen
          }


          
        
        
        // Configure other cell properties using list data

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check if the index is within the listT array bounds
        guard indexPath.row < listT.count else {
            // Handle the case where the index is out of range
            print("Index out of range. IndexPath.row: \(indexPath.row), listT count: \(listT.count)")
            return
        }

        // Access the selected list
        let selectedList = listT[indexPath.row]

        // Instantiate the ToDoListDetailsViewController from the storyboard
        if let listDetailsVC = storyboard?.instantiateViewController(withIdentifier: "ToDoList") as? ToDoList {
            // Pass the selected list to ToDoListDetailsViewController
            

            // Push ToDoListDetailsViewController onto the navigation stack
            navigationController?.pushViewController(listDetailsVC, animated: true)
        } else {
            // Handle the case where instantiation fails
            print("Failed to instantiate ToDoListDetailsViewController.")
        }
    }
}
