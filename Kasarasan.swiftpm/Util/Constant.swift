import SwiftUI

let menus: [NavigationMenu] = [
    NavigationMenu(name: UserRole.patient.rawValue, image: "patient"),
    NavigationMenu(name: UserRole.doctor.rawValue, image: "doctor"),
    NavigationMenu(name: UserRole.nurse.rawValue, image: "nurse")
]

let menuss: [String] = [
    "Patient",
    "Doctor",
    "Nurse"
]

let patientMenu: [String] = [
    "Personal Information",
    "Medical Record",
    "Triggered Activity"
]
