import Foundation
import SwiftData

@Model
class MedicalRecord {
    @Attribute(.unique) var identifier: String
    var date: Date = Date()
    var desc: String = ""
    var diagnose: String = ""
    var symptoms: [String] = []
    var doctor: User
    var patient: User
    
    @Relationship(deleteRule: .cascade, inverse: \Medication.medicalRecord) var medications: [Medication]?
    
    init(identifier: String, date: Date, desc: String, diagnose: String,
         symptoms: [String], doctor: User, patient: User) {
        self.identifier = identifier
        self.date = date
        self.desc = desc
        self.diagnose = diagnose
        self.symptoms = symptoms
        self.doctor = doctor
        self.patient = patient
    }
    
    init() {
        self.identifier = ""
        self.date = Date()
        self.desc = ""
        self.diagnose = ""
        self.symptoms = []
        self.doctor = User()
        self.patient = User()
    }
}
