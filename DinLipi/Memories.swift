//
//  Memories.swift
//  DinLipi
//
//  Created by IQBAL MAHAMUD on 24/11/23.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class Memories: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var memTitle: UITextField!
    
    @IBOutlet var memDescription: UITextView!
    
    @IBOutlet var memImg: UIImageView!
    
    @IBOutlet weak var memLabel: UILabel!
    
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func addImg(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // Handle the selected image
            memImg.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func memSave(_ sender: Any) {
        if let userID = UserDataManager.shared.currentUserID {
            print("User ID in AnotherViewController: \(userID)")
            let timestamp = String(Date().timeIntervalSince1970)
            let sanitizedTimestamp = timestamp.replacingOccurrences(of: ".", with: "_")
            
            // Check if an image is selected
            guard let selectedImage = memImg.image else {
                print("Please select an image.")
                return
            }
            
            // Convert the image to data
            guard let imageData = selectedImage.jpegData(compressionQuality: 0.5) else {
                print("Failed to convert image to data.")
                return
            }
            
            // Create a unique name for the image using timestamp
            let imageName = "\(sanitizedTimestamp)_image.jpg"
            
            // Reference to Firebase Storage
            let storageRef = Storage.storage().reference().child("images").child(userID).child(imageName)
            
            // Upload the image data to Firebase Storage
            storageRef.putData(imageData, metadata: nil) { [self] (_, error) in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                } else {
                    print("Image uploaded successfully!")
                    
                    // Once the image is uploaded, get the download URL
                    storageRef.downloadURL { (url, error) in
                        if let imageUrl = url {
                            // Save the image URL and other data to the database
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let currentDate = dateFormatter.string(from: Date())
                            
                            let data: [String: Any] = [
                                "title": self.memTitle.text ?? "",
                                "description": self.memDescription.text ?? "",
                                "timestamp": timestamp,
                                "date": currentDate,
                                "imageUrl": imageUrl.absoluteString  // Store the image URL in the database
                            ]
                            
                            self.database.child("memories").child(userID).child(sanitizedTimestamp).setValue(data)
                            print("Memory Added")
                            memLabel.text = "New memory added!"
                            
                            // Reset UI elements
                            self.memTitle.text = ""
                            self.memDescription.text = ""
                            self.memImg.image = nil
                        } else {
                            print("Error getting image URL: \(error?.localizedDescription ?? "Unknown error")")
                        }
                    }
                }
            }
        } else {
            print("User ID not available.")
        }
    }
}
