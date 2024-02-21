import SwiftUI
import SwiftData

@Model
class Medication: Hashable {
    @Attribute(.unique) var identifier: String
    var medicine: String
    var dosage: String
    var medicalRecord: MedicalRecord
    
    init(identifier: String, medicine: String, dosage: String, medicalRecord: MedicalRecord) {
        self.identifier = identifier
        self.medicine = medicine
        self.dosage = dosage
        self.medicalRecord = medicalRecord
    }
}
