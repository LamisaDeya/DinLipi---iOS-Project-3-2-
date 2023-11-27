import SwiftUI
import FirebaseDatabase

enum Priority: String, CaseIterable {
    case low
    case medium
    case high

    var numericValue: Int {
        switch self {
        case .low:
            return 0
        case .medium:
            return 1
        case .high:
            return 2
        }
    }
}

struct PopUpView: View {
    @State private var selectedDate = Date()
    @State private var eventText = ""
    @State private var selectedPriority: Priority = .medium // Default to Medium priority
    var onDismiss: (() -> Void)?
    
    var body: some View {
        VStack {
            Text("Add event")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.blue) // System blue color
                .padding()
                .multilineTextAlignment(.center) // Center alignment
            
            DatePicker("Select Date and Time", selection: $selectedDate, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                .frame(width: 300) // Set the desired width
                .padding()
            
            TextField("Enter Event", text: $eventText)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.teal) // System blue color
                .padding()
            
            Text("Select Priority:")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.teal) // System blue color
                .padding()
                //.padding(.top, 8)
            
            Picker("Priority", selection: $selectedPriority) {
                ForEach(Priority.allCases, id: \.self) { priority in
                    Text(priority.rawValue.capitalized)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Add Event") {
                // Handle button tap
                addEventToFirebase()
                onDismiss?() // Call the closure to dismiss the pop-up
            }
            .padding()
            .buttonStyle(CButtonStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
    
    func addEventToFirebase(updatedEvent: EventC? = nil) {
        // Initialize Firebase (make sure you have configured Firebase in your app)
        if let userID = UserDataManager.shared.currentUserID {
            let timestamp = String(Date().timeIntervalSince1970)
            let sanitizedTimestamp = timestamp.replacingOccurrences(of: ".", with: "_")
            // Reference to the "events" node in your Firebase database
            let eventsRef = Database.database().reference().child("events").child(userID)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            var formattedDate = ""
            var eventText = ""
            var priority = 0
            
            if let updatedEvent = updatedEvent {
                formattedDate = dateFormatter.string(from: updatedEvent.date)
                eventText = updatedEvent.event
                priority = updatedEvent.priority
            } else {
                formattedDate = dateFormatter.string(from: selectedDate)
                eventText = self.eventText
                priority = selectedPriority.numericValue
            }
            
            // Create a dictionary with the event data
            let eventData: [String: Any] = [
                "date": formattedDate,
                "eventText": eventText,
                "timestamp": timestamp,
                "priority": priority
            ]
            
            // Add the event data to the "events" node
            eventsRef.childByAutoId().setValue(eventData) { (error, _) in
                if let error = error {
                    print("Error adding/updating event to Firebase: \(error.localizedDescription)")
                } else {
                    print("Event added/updated to Firebase successfully!")
                }
            }
        }
    }
    
}
// Custom button style for tinting and background color
struct CButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.black) // Set foreground color to black
            .padding(10)
            .background(Color.teal) // Set background color to teal
            .cornerRadius(8)
    }
}

