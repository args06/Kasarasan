import SwiftUI
import SwiftData

struct PatientDashboard: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.modelContext) var viewContext
    
    var user: User
    
    @State var onHiddenToolbar = false
    
    @State var columnVisibility: NavigationSplitViewVisibility = .all
    
    private var bothAreShown: Bool {columnVisibility != .detailOnly}
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            VStack(alignment: .leading) {
                Button("Back") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.blue)
                .padding([.top, .leading], 21)
                List {
                    ForEach(patientMenu, id: \.self) { menu in
                        NavigationLink {
                            switch menu {
                            case "Personal Information":
                                UserDashboard(user: user, userRole: user.userRole)
                                
                            case "Medical Record":
                                MedicalRecordView(user: user)
                                
                            case "Triggered Activity":
                                TriggeredActivityView(user: user)
                                
                            default:
                                Text("Wrong Menu!")
                            }
                        } label : {
                            Text(menu)
                        }
                    }
                }
            }
        } detail: {
            Text("Choose your menu")
        }
        .navigationBarBackButtonHidden(true)
        
    }
}
