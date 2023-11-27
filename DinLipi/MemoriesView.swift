import SwiftUI

struct MemoryView: View {
    var memory: Memory

    var body: some View {
        VStack {
            Text(memory.title)
                .font(.title)
                .foregroundColor(.blue)
            Text(memory.date)
                .font(.subheadline)
                .foregroundColor(Color(UIColor.systemTeal)) // Set date color to light blue
            // Display other memory details (image, description, etc.)
            // For example, you can use an AsyncImage to load the image from the URL
            AsyncImage(url: URL(string: memory.imageUrl)) { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                // Placeholder or loading view
                ProgressView()
            }
            .frame(maxHeight: 200) // Set a max height for the image
            Text(memory.description)
                .font(.body)
        }
        .padding()
    }
}
