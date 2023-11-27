//
//  Login.swift
//  DinLipi
//
//  Created by IQBAL MAHAMUD on 11/11/23.
//

import UIKit
import FirebaseDatabase


class Login: UIViewController {

    @IBOutlet weak var logunStatusLabel: UILabel!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var email: UITextField!
        override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signup(_ sender: Any) {
        
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Signup") as! Signup
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        let loginEmailText = email.text
            let loginPasswordText = pass.text
        //let loginStatus = logunStatusLabel.text
        
            
            // Check if email and password meet the criteria
            if let loginEmailText = loginEmailText, let loginPasswordText = loginPasswordText {
                if loginEmailText.isEmpty || loginPasswordText.isEmpty {
                    // Update the label for empty email or password
                logunStatusLabel.text = "Email and password cannot be empty."
                } else {
                    // Perform login logic by checking the data in Firebase
                    let database = Database.database().reference().child("user")
                    
                    database.observeSingleEvent(of: .value) { snapshot in
                        if let users = snapshot.children.allObjects as? [DataSnapshot] {
                            for user in users {
                                if let userData = user.value as? [String: Any],
                                   let storedEmail = userData["email"] as? String,
                                   let storedPassword = userData["password"] as? String {
                                   
                                    if storedEmail == loginEmailText && storedPassword == loginPasswordText {
                                        // Login successful
                                        print("Login successful!")
                                        self.logunStatusLabel.text = "Login successful!"
                                        let userID = user.key  // Retrieve the user ID
                                                            //print("Login successful! User ID: \(userID)")
                                                            
                                                            // Store the user ID in the singleton
                                         UserDataManager.shared.currentUserID = userID
                                        
                                        // Optionally, navigate to another screen after successful login
                                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
                                        self.navigationController?.pushViewController(vc, animated: true)
                                        return
                                    }
                                }
                            }
                            
                            // No matching user found
                            self.logunStatusLabel.text = "Login failed. Please check your credentials."
                        }
                    }
                }
            } else {
                // Handle the case where either loginEmailText or loginPasswordText is nil
                logunStatusLabel.text = "Error: Email or password is nil."
            }
       /* let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
        self.navigationController?.pushViewController(vc, animated: true) */
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
