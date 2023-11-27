//
//  Signup.swift
//  DinLipi
//
//  Created by IQBAL MAHAMUD on 11/11/23.
//

import UIKit
import FirebaseDatabase

class Signup: UIViewController {
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var pass: UITextField!
    private let database = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signup(_ sender: Any) {
       /* let data = [
            "email": email.text,
            "password": pass.text
        ]
        database.child("user").childByAutoId().setValue(data) */
        let emailText = email.text
        let passwordText = pass.text
        let usernameText = username.text
        

        // Check if email and password meet the criteria
        if let emailText = emailText, let passwordText = passwordText, let usernameText = usernameText {
            
            if emailText.isEmpty || passwordText.isEmpty || usernameText.isEmpty {
                // Update the label for empty email or password
                statusLabel.text = "Every field is mandatory!"
            } else if passwordText.count < 6 {
                // Update the label for password less than 6 characters
                statusLabel.text = "Password must be at least 6 characters."
            } else if !emailText.hasSuffix("@gmail.com") {
                // Update the label for email without "@gmail.com" suffix
                statusLabel.text = "Email must end with '@gmail.com'."
            } else {
                // If all validation checks pass, proceed with signing up
                let data = [
                    "email": emailText,
                    "password": passwordText,
                    "username": usernameText
                ]
                database.child("user").childByAutoId().setValue(data)
                // Update the label for successful signup
                statusLabel.text = "Account creation successful!"
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
                self.navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            // Handle the case where either emailText or passwordText is nil
            statusLabel.text = "Error: required field is nil."
        }

        

        
    }
    @IBAction func login(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
        self.navigationController?.pushViewController(vc, animated: true)
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
