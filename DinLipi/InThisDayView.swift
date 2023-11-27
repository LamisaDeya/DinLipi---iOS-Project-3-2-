// InThisDayMemoryView.swift

import SwiftUI

struct InThisDayView: View {
    var memory: Memory

    var body: some View {
        // Design your view to display a single memory
        VStack {
            Text(memory.title)
                .font(.title)
                .foregroundColor(.blue)
            Text(memory.description)
                .font(.body)
            Text(memory.date)
                .font(.caption)
                .foregroundColor(Color(UIColor.systemTeal)) // Set date color to light blue
        }
        .padding()
        .navigationTitle("Memory Detail")
    }
}
