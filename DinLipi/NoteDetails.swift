//
//  NoteDetails.swift
//  DinLipi
//
//  Created by IQBAL MAHAMUD on 13/11/23.
//

import UIKit
import FirebaseDatabase

class NoteDetails: UIViewController {

    @IBOutlet var descD: UITextView!
    @IBOutlet var dateD: UITextField!
    
    @IBOutlet var saveD: UIButton!
    @IBOutlet var titleD: UITextField!
    var note: NoteC?
    var noteID: String?
    var onDelete: (() -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Do any additional setup after loading the view.
    }
    func updateUI() {
        titleD.text = note?.title
        descD.text = note?.description
        if let date = note?.date {
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust the date format according to your needs
            let dateString = dateFormatter.string(from: date)
            dateD.text = dateString
        } else {
            dateD.text = nil
        }
    }

    
    @IBAction func editD(_ sender: Any) {
        titleD.isEnabled = true
                descD.isEditable = true

                // Show a save button
                let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges))
                navigationItem.rightBarButtonItem = saveButton
    }
    
    
    
    @IBAction func saveDf(_ sender: Any) {
        saveChanges()
        
    }
    @objc func saveChanges() {
        // Disable editing of title and description fields
        titleD.isEnabled = false
        descD.isEditable = false

        // Remove the save button
        navigationItem.rightBarButtonItem = nil
        let sanitizedTimestamp = note?.timestamp.replacingOccurrences(of: ".", with: "_")

        // Save changes to your data source (e.g., update the note object)
        if let noteID = sanitizedTimestamp,
           let updatedTitle = titleD.text,
           let updatedDescription = descD.text {

            let updatedData: [String: Any] = [
                "title": updatedTitle,
                "description": updatedDescription,
                // You might need to update other fields as needed
            ]

            let database = Database.database().reference().child("notes").child(UserDataManager.shared.currentUserID ?? "").child(noteID)

            // Update the data in Firebase
            database.updateChildValues(updatedData) { error, _ in
                if let error = error {
                    print("Error updating note: \(error.localizedDescription)")
                } else {
                    print("Note updated successfully.")
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoteTable") as! NoteTable
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }

        // Update the UI with the changes
        updateUI()
    }

    @IBAction func deleteD(_ sender: Any) {
        let sanitizedTimestamp = note?.timestamp.replacingOccurrences(of: ".", with: "_")
        guard let noteID = sanitizedTimestamp else {
                    print("Note ID is nil.")
                    return
                }

                let database = Database.database().reference().child("notes").child(UserDataManager.shared.currentUserID ?? "").child(noteID)

                // Show an alert to confirm deletion
                let alertController = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this note?", preferredStyle: .alert)

                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
                    // Delete the note from Firebase
                    database.removeValue { error, _ in
                        if let error = error {
                            print("Error deleting note: \(error.localizedDescription)")
                        } else {
                            print("Note deleted successfully.")
                            self.onDelete?()
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoteTable") as! NoteTable
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                            // Navigate back to the previous screen
                            //self.navigationController?.popViewController(animated: true)
                        }
                    }
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                alertController.addAction(deleteAction)
                alertController.addAction(cancelAction)

                present(alertController, animated: true, completion: nil)
        
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
