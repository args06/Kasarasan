import SwiftUI

struct NavigationRow: View {
    var menu: NavigationMenu
    
    var body: some View {
        HStack {
            menu.usedImage
                .resizable()
                .frame(
                    width: 50,
                    height: 75
                )
            Text(menu.name)
                .padding(.leading, 10)
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
}

#Preview("Menu Dashboard") {
    NavigationRow(menu: NavigationMenu(name: "Patient", image: "patient"))
}
