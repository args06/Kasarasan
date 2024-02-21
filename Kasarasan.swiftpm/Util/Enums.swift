import SwiftUI

enum UserRole: String {
    case patient = "Patient"
    case nurse = "Nurse"
    case doctor = "Doctor"
}

enum UserGender: String, Codable {
    case male = "Male"
    case female = "Female"
}

enum BloodType: String, Codable {
    case a = "A"
    case b = "B"
    case o = "O"
    case ab = "AB"
}

enum ViewIdentifiers: String {
    case homeView = "Home"
}

enum PatientStatus: String {
    case inpatient = "Inpatient"
    case outpatient = "Outpatient"
}
