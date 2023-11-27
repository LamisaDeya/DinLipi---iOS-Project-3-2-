//
//  Notes.swift
//  DinLipi
//
//  Created by IQBAL MAHAMUD on 11/11/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Notes: UIViewController {
    
    
    @IBOutlet var titleBox: UITextField!
    
    @IBOutlet var label: UILabel!
    @IBOutlet var descriptionBox: UITextView!
    //private let database = Database.database().reference()
    var currentUserID: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
      /*  if let user = Auth.auth().currentUser {
                    currentUserID = user.uid
                } else {
                    // Handle the case where the user is not logged in
                    print("User not logged in.")
                }

                // Check if currentUserID is not nil before proceeding
                guard let userID = currentUserID else {
                    print("User ID is nil.")
                    return
                }

                let data = [
                    "title": titleBox.text,
                    "description": descriptionBox.text
                ]
                database.child("notes").child(userID).setValue(data)
        label.text="Note Saved" */
        
        
        
    }
    
    @IBAction func deleteNote(_ sender: Any) {
        
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
