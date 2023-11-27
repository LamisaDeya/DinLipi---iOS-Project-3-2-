//
//  Note.swift
//  DinLipi
//
//  Created by IQBAL MAHAMUD on 11/11/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Note: UIViewController {
   
    @IBOutlet var titlee: UITextField!
    
    @IBOutlet var descriptionn: UITextView!
    
    
    @IBOutlet weak var noteLabel: UILabel!
    private let database = Database.database().reference()
    //var currentUserID: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        if let userID = UserDataManager.shared.currentUserID {
                    // Use userID as needed
                    print("User ID in AnotherViewController: \(userID)")
            let timestamp = String(Date().timeIntervalSince1970)
            let sanitizedTimestamp = timestamp.replacingOccurrences(of: ".", with: "_")

                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let currentDate = dateFormatter.string(from: Date())

                // Explicitly specify the type of the data dictionary
                let data: [String: Any] = [
                    "title": titlee.text ?? "",
                    "description": descriptionn.text ?? "",
                    "timestamp": timestamp,
                    "date": currentDate
                ]

            database.child("notes").child(userID).child(sanitizedTimestamp).setValue(data)
            print("Saved")
            noteLabel.text = "Note added successfully!"
            titlee.text=""
            descriptionn.text=""
                } else {
                    print("User ID not available.")
                }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoteTable") as! NoteTable
        self.navigationController?.pushViewController(vc, animated: true)
        

            
        //print("saved")
          
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
