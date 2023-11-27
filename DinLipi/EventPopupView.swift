import SwiftUI
import FirebaseDatabase

struct EventPopupView: View {
    var event: EventC
    var onDismiss: () -> Void
    @State private var isEditing = false

    var body: some View {
        VStack {
            Text("Event Details")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.blue) // System blue color
                .padding()
                .multilineTextAlignment(.center) // Center alignment

            Text("Event: \(event.event)")
                .foregroundColor(Color.black) // Teal color
                .padding()
                .background(Color.white) // System gray 6 background

            Text("Date: \(formattedDate)")
                .foregroundColor(Color.black)
                .padding()
                .background(Color.white)

            Text("Priority: \(priorityText)")
                .foregroundColor(priorityColor) // Color based on priority
                .padding()
                .background(Color.white)

            Button("OK") {
                onDismiss()
            }
            .padding()
            .buttonStyle(CustomButtonStyle())
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }

    private var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: event.date)
    }

    private var priorityText: String {
        switch event.priority {
        case 0:
            return "Low"
        case 1:
            return "Medium"
        case 2:
            return "High"
        default:
            return "Unknown"
        }
    }

    private var priorityColor: Color {
        switch event.priority {
        case 0:
            return Color.green // Green for Low priority
        case 1:
            return Color.orange // Orange for Medium priority
        case 2:
            return Color.red // Red for High priority
        default:
            return Color.black
        }
    }
}
// Custom button style for tinting and background color
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.black) // Set foreground color to black
            .padding(10)
            .background(Color.teal) // Set background color to teal
            .cornerRadius(8)
    }
}
