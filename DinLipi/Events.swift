//
//  Events.swift
//  DinLipi
//
//  Created by IQBAL MAHAMUD on 25/11/23.
//

import UIKit
import SwiftUI

class Events: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showPopUp()
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func home(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func showPopUp() {
            let popUpView = PopUpView { [weak self] in
                // Handle the dismissal action (e.g., save the event, update UI, etc.)
                self?.dismiss(animated: true, completion: nil)
            }

            let hostingController = UIHostingController(rootView: popUpView)
            hostingController.modalPresentationStyle = .overCurrentContext
            hostingController.modalTransitionStyle = .crossDissolve

            present(hostingController, animated: true, completion: nil)
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
