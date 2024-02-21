import SwiftUI

struct Chip: View {
    let text: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 12))
        }
        .padding(6)
        .background(RoundedRectangle(cornerRadius: 8)
            .foregroundColor(.gray.opacity(0.5)))
    }
}

#Preview {
    Chip(text: "Test Chip")
}
