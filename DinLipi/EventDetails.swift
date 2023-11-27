import SwiftUI

class EventDetails: UIViewController {
    var event: EventC?

    override func viewDidLoad() {
        super.viewDidLoad()
        showPopUp()
    }

    func showPopUp() {
        if let event = event {
            let popUpView = EventPopupView(event: event, onDismiss: {
                // Handle the dismissal action (e.g., save the event, update UI, etc.)
                self.dismiss(animated: true, completion: nil)
            })

            let hostingController = UIHostingController(rootView: popUpView)
            hostingController.modalPresentationStyle = .overCurrentContext
            hostingController.modalTransitionStyle = .crossDissolve

            present(hostingController, animated: true, completion: nil)
        }
    }

}


