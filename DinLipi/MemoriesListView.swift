// MemoriesListView.swift

import SwiftUI

struct MemoriesListView: View {
    @ObservedObject var viewModel: MemoriesViewModel

    var body: some View {
            NavigationView {
                VStack {
                    Button("On This Day") {
                        viewModel.fetchMemoriesInThisDay()
                    }
                    .buttonStyle(DecoratedButtonStyle())
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .cornerRadius(8)

                    ScrollView {
                        LazyVStack(alignment: .center, spacing: 20) { // Center-align the content
                            ForEach(viewModel.memories) { memory in
                                NavigationLink(destination: InThisDayView(memory: memory)) {
                                    MemoryView(memory: memory)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding([.leading, .trailing], 10)
                    }
                    .padding()

                    // Set the navigationTitle with a smaller font and teal color
                    .navigationTitle("Memories")
                    .navigationBarTitleDisplayMode(.inline)
                    .font(.system(size: 18, weight: .semibold)) // Adjust font size and weight
                    .foregroundColor(Color.teal) // Set the color to Teal
                }
            }
        }
}

// Create a button style for decoration
struct DecoratedButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(10) // Adjust padding as needed
            .background(Color.teal) // Set background color
            .foregroundColor(Color.black) // Set foreground color
            .cornerRadius(8) // Adjust corner radius as needed
            //.scaleEffect(configuration.isPressed ? 0.9 : 1.0) // Add a scaling effect on press
    }
}
