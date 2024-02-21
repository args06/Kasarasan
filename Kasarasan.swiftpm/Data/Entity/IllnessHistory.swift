import SwiftUI
import SwiftData

@Model
class IllnessHistory {
    @Attribute(.unique) var identifier: String
    var disease: String = ""
    var patient: User
    
    init(identifier: String, disease: String, patient: User) {
        self.identifier = identifier
        self.disease = disease
        self.patient = patient
    }
}
