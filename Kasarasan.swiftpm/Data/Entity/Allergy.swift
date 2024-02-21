import SwiftUI
import SwiftData

@Model
class Allergy {
    @Attribute(.unique) var identifier: String
    var allergy: String = ""
    var patient: User
    
    init(identifier: String, allergy: String, patient: User) {
        self.identifier = identifier
        self.allergy = allergy
        self.patient = patient
    }
}
