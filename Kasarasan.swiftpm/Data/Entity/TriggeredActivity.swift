import SwiftUI
import SwiftData

@Model
class TriggeredActivity {
    @Attribute(.unique) var identifier: String
    var date: Date = Date()
    var second: Int = 0
    var rootCause: String = ""
    var desc: String = ""
    var nurse: User
    var patient: User
    
    init(identifier: String, date: Date, second: Int, rootCause: String, desc: String, nurse: User, patient: User) {
        self.identifier = identifier
        self.date = date
        self.second = second
        self.rootCause = rootCause
        self.desc = desc
        self.nurse = nurse
        self.patient = patient
    }
    
    init(identifier: String, date: Date, second: Int, nurse: User, patient: User) {
        self.identifier = identifier
        self.date = date
        self.second = second
        self.rootCause = ""
        self.desc = ""
        self.nurse = nurse
        self.patient = patient
    }
    
    func copy(identifier: String? = nil, date: Date? = nil, second: Int? = nil, rootCause: String? = nil, desc: String? = nil, nurse: User? = nil, patient: User? = nil) -> TriggeredActivity {
        TriggeredActivity(
            identifier: identifier ?? self.identifier, 
            date: date ?? self.date, 
            second: second ?? self.second, 
            rootCause: rootCause ?? self.rootCause, 
            desc: desc ?? self.desc, 
            nurse: nurse ?? self.nurse, 
            patient: patient ?? self.patient
        )
    } 
}
