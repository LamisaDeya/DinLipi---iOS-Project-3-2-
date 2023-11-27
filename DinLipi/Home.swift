//
//  Home.swift
//  DinLipi
//
//  Created by IQBAL MAHAMUD on 11/11/23.
//

import UIKit

class Home: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func aboutfinal(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutUs") as! AboutUs
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func EventFinal(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EventTable") as! EventTable
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func logout(_ sender: Any) {
        clearLocalUserData()
        
        // Navigate to the login screen or any other appropriate screen
        navigateToLoginScreen()
    }
    @IBAction func scrap_book(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoriesViewController") as! MemoriesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func noteSave(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ToDoListAll") as! ToDoListAll
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func weather(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Weather") as! Weather
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func calendar(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Calendar") as! Calendar
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func notes(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NoteTable") as! NoteTable
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func todolist(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ToDoList") as! ToDoList
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func memories(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Memories") as! Memories
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func clearLocalUserData() {
        // Clear any local session data or cached user data
        // For example, you might clear UserDefaults or other local storage
        UserDefaults.standard.removeObject(forKey: "userToken")
        // You might want to clear more data depending on your app's requirements
    }
    
    func navigateToLoginScreen() {
        // Navigate to the login screen (replace 'LoginViewController' with your actual login view controller)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! Login
        self.navigationController?.pushViewController(vc, animated: true)
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
}
