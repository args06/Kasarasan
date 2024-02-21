import SwiftUI

struct NavigationMenu: Codable, Identifiable  {
    var id = UUID()
    var name: String
    var image: String
    
    var usedImage: Image {
        Image(image)
    }
}
