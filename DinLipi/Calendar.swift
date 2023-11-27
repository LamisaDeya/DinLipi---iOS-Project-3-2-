import UIKit

class Calendar: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createCalendar()
        setupAddButton()
    }
    
    func createCalendar(){
        view.backgroundColor = .systemGray6   // calender page color
        
        let calendarView = UICalendarView()
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        calendarView.calendar = .current
        calendarView.locale = .current
        calendarView.fontDesign = .rounded
        calendarView.delegate = self
        calendarView.layer.cornerRadius = 12
        calendarView.backgroundColor = .systemGray4
        
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10), // Adjust top anchor
            calendarView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    func setupAddButton() {
        // Create a UIButton with the "Add" title
        let addButton = UIButton(type: .system)
        addButton.setTitle("Add Event", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        let tintedColor = UIColor.systemTeal.withAlphaComponent(1.0) // Adjust alpha as needed
        addButton.backgroundColor = tintedColor
        addButton.setTitleColor(UIColor.black, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold) //Adjust the size and weight according to your preference
        addButton.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // Adjust the padding values as needed
        addButton.layer.cornerRadius = 10 // Adjust the corner radius to your preference
        
        // Add the button to the view
        view.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 500), // Adjust top anchor to position below the calendar
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func addButtonTapped() {
        // Handle the "Add" button tap
        // You can navigate to another view or perform any action here
        print("Add button tapped!")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Events") as! Events
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Calendar: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return nil
    }
}
