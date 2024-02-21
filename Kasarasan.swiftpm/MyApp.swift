import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            Home()
                .modelContainer(for: [
                    User.self,
                    MedicalRecord.self,
                    TriggeredActivity.self,
                    IllnessHistory.self,
                    Allergy.self
                ])
        }
    }
}
