//
//  NoteTable.swift
//  DinLipi
//
//  Created by IQBAL MAHAMUD on 11/11/23.
//

import UIKit
import FirebaseDatabase

/*class NoteTable: UIViewController{
    
    
    
    @IBOutlet var tableView: UITableView!
    var notes: [Note] = []
    
        // Add other properties as needed
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchDataFromFirebase()
       
        
        // Do any additional setup after loading the view.
    }
    


}
extension NoteTable:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped me")
    }
}
extension NoteTable:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let note = notes[indexPath.row]
                cell.textLabel?.text = note.title
        return cell
    }
}
extension NoteTable {
    
    func fetchDataFromFirebase() {
        guard let userID = UserDataManager.shared.currentUserID else {
            print("User ID is nil.")
            return
        }

        let database = Database.database().reference().child("notes").child(userID)

        database.observeSingleEvent(of: .value) { snapshot in
            // Check if the snapshot contains any data
            guard let notesData = snapshot.value as? [String: [String: Any]] else {
                print("No data found.")
                return
            }

            self.notes.removeAll()

            for (_, noteData) in notesData {
                if let title = noteData["title"] as? String,
                   let description = noteData["description"] as? String {
                    let note = Note(title: title, description: description)
                    self.notes.append(note)
                }
            }

            // Reload the table view after fetching data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}*/
class NoteTable: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var addnote: UIButton!
    /* struct Note {
        var title: String
        var description: String
        //var date: Date
    }*/
    var noteT: [NoteC] = [] 
    
    //var notes: [Note] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddButton()
        setupNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
        fetchDataFromFirebase()
    }
    func setupAddButton() {
            // Create a UIBarButtonItem with the "Add" title
            let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))

            // Set the button on the right side of the navigation bar
            navigationItem.rightBarButtonItem = addButton
        }

        @objc func addButtonTapped() {
            // Handle the "Add" button tap
            // You can navigate to another view or perform any action here
            print("Add button tapped!")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Note") as! Note
            self.navigationController?.pushViewController(vc, animated: true)
        }
    func setupNavigationBar() {
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        navigationItem.leftBarButtonItem = homeButton

        let addButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func homeButtonTapped() {
        print("Home button tapped!")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
        self.navigationController?.pushViewController(vc, animated: true)
        // Add your code to navigate to the home screen
    }
    
    
    
    
    func fetchDataFromFirebase() {
        guard let userID = UserDataManager.shared.currentUserID else {
            print("User ID is nil.")
            return
        }

        let database = Database.database().reference().child("notes").child(userID)

        database.queryOrdered(byChild: "timestamp")
            .queryLimited(toLast: 10)
            .observeSingleEvent(of: .value) { snapshot in
                guard let notesData = snapshot.children.allObjects as? [DataSnapshot] else {
                    print("No data found.")
                    return
                }

                self.noteT.removeAll()

                for noteSnapshot in notesData {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    if let noteData = noteSnapshot.value as? [String: Any],
                       let title = noteData["title"] as? String,
                       let description = noteData["description"] as? String,
                       let dateString = noteData["date"] as? String,
                       let date = dateFormatter.date(from: dateString),
                       let timestamp = noteData["timestamp"] as? String { // Replace yourDateFormatter with the actual date formatter you're using
                        let note = NoteC(title: title, description: description, date: date, timestamp: timestamp)
                        self.noteT.insert(note, at: 0)
                    }
                }


                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
        }
    }
}

extension NoteTable: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteT.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        let note = noteT[indexPath.row]
        cell.textLabel?.text = note.title
        // Configure other cell properties using note data

        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Check if the index is
        guard indexPath.row < noteT.count else {
            // Handle the case where the index is out of range
            print("Index out of range. IndexPath.row: \(indexPath.row), noteT count: \(noteT.count)")
            return
        }

        // Access the selected note
        let selectedNote = noteT[indexPath.row]

        // Instantiate the NoteDetailsViewController from the storyboard
        if let noteDetailsVC = storyboard?.instantiateViewController(withIdentifier: "NoteDetails") as? NoteDetails {
            // Pass the selected note to NoteDetailsViewController
            noteDetailsVC.note = selectedNote

            // Push NoteDetailsViewController onto the navigation stack
            navigationController?.pushViewController(noteDetailsVC, animated: true)
        } else {
            // Handle the case where instantiation fails
            print("Failed to instantiate NoteDetailsViewController.")
        }
    }

}




