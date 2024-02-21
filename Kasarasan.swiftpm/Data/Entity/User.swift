import SwiftUI
import SwiftData

@Model
class User {
    @Attribute(.unique) var identifier: String = UUID().uuidString
    var nickname: String = ""
    var fullName: String = ""
    var picture: Data? = nil
    var gender: String = UserGender.male.rawValue
    var birthDate: Date = Date()
    var bloodType: String = BloodType.o.rawValue
    var height: Double = 0.0
    var weight: Double = 0.0
    var roleType: String = ""
    var expertise: [String] = []
    var position: String = ""
    var userRole: String = UserRole.patient.rawValue
    var since: Date = Date()
    var patientStatus: String = PatientStatus.inpatient.rawValue
    
    @Relationship(deleteRule: .cascade, inverse: \MedicalRecord.doctor) var medicalRecords: [MedicalRecord]?
    
    @Relationship(deleteRule: .cascade, inverse: \TriggeredActivity.nurse) var triggeredActivity: [TriggeredActivity]?
    
    @Relationship(deleteRule: .cascade, inverse: \IllnessHistory.patient) var illnessHistory: [IllnessHistory]?
    
    @Relationship(deleteRule: .cascade, inverse: \Allergy.patient) var allergy: [Allergy]?
    
    init(
        identifier: String,
        nickname: String,
        fullName: String,
        picture: Data? = nil,
        gender: String,
        birthDate: Date,
        bloodType: String,
        height: Double,
        weight: Double,
        roleType: String,
        expertise: [String],
        position: String,
        userRole: String,
        since: Date,
        patientStatus: String
    ) {
        self.identifier = identifier
        self.nickname = nickname
        self.fullName = fullName
        self.picture = picture
        self.gender = gender
        self.birthDate = birthDate
        self.bloodType = bloodType
        self.height = height
        self.weight = weight
        self.roleType = roleType
        self.expertise = expertise
        self.position = position
        self.userRole = userRole
        self.since = since
        self.patientStatus = patientStatus
    }
    
    init() {
        self.identifier = ""
        self.nickname = ""
        self.fullName = ""
        self.picture = nil
        self.gender = ""
        self.birthDate = Date()
        self.bloodType = ""
        self.height = 0.0
        self.weight = 0.0
        self.roleType = ""
        self.expertise = []
        self.position = ""
        self.userRole = ""
        self.since = Date()
        self.patientStatus = ""
    }
}
