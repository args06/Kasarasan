import SwiftUI
import SwiftData

struct UserDashboard: View {
    @Environment(\.modelContext) var context
    
    @Query var illnessHistories: [IllnessHistory]
    @Query var allergies: [Allergy]
    
    @State var userIllnessHistories: [IllnessHistory] = []
    @State var userAllergies: [Allergy] = []
    
    var user: User
    
    @State private var isUpdateData = false
    @State private var isDeleteUser = false
    
    var userRole: String = ""
    
    var body: some View {
        VStack {
            Form {
                VStack { 
                    if self.user.picture != nil {
                        Image(uiImage: UIImage(data: self.user.picture!)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .cornerRadius(10)
                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 250, height: 250, alignment: .center)
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .cornerRadius(10)
                    }
                }
                
                Section {
                    DetailInformation(
                        label: "Role", 
                        value: self.user.userRole
                    )
                    
                    DetailInformation(
                        label: "Since", 
                        value: self.user.since.toString(dateFormat: "MM/dd/yyyy")
                    )
                    
                    if userRole == UserRole.nurse.rawValue {
                        DetailInformation(
                            label: "Position", 
                            value: self.user.position
                        )
                    }
                    
                    if userRole == UserRole.doctor.rawValue {
                        DetailInformation(
                            label: "Role Type", 
                            value: self.user.roleType
                        )
                        
                        DisclosureGroup("Expertise") {
                            ForEach(user.expertise, id: \.self) { expert in
                                HStack {
                                    Text(expert)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .contentShape(Rectangle())
                                }
                            }
                        }
                    }
                    
                    if userRole == UserRole.patient.rawValue {
                        DetailInformation(
                            label: "Patient Status", 
                            value: self.user.patientStatus
                        )
                    }
                } header: {
                    Text("Current Role")
                }
                
                Section {
                    DetailInformation(
                        label: "Full Name", 
                        value: self.user.fullName
                    )
                    DetailInformation(
                        label: "Nickname", 
                        value: self.user.nickname
                    )
                    DetailInformation(
                        label: "Gender", 
                        value: self.user.gender
                    )
                    DetailInformation(
                        label: "Date of Birth", 
                        value: self.user.birthDate.toString(dateFormat: "MM/dd/yyyy")
                    )
                    DetailInformation(
                        label: "Blood Type", 
                        value: self.user.bloodType
                    )
                    DetailInformation(
                        label: "Height", 
                        value: "\(convertDoubleToString(value: user.height)) cm"
                    )
                    DetailInformation(
                        label: "Weight", 
                        value: "\(convertDoubleToString(value: user.weight)) kg"
                    )
                } header: {
                    Text("Personal Information")
                }
                
//                if user.userRole == UserRole.patient.rawValue {
//                    Section { 
//                        DetailInformation(label: "Diagnose", value: user.diagnose)
//                        
//                        DisclosureGroup("Symptoms") {
//                            ForEach(user.symptoms, id: \.self) { symptom in
//                                HStack {
//                                    Text(symptom)
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                        .contentShape(Rectangle())
//                                }
//                            }
//                        }
//                    } header: { 
//                        HStack {
//                            Text("Medical Condition")
//                        }
//                    }    
//                }
                
                if !userIllnessHistories.isEmpty {
                    Section { 
                        ForEach(userIllnessHistories, id: \.self) { disease in
                            DetailInformation(label: disease.disease, value: "")
                        }
                    } header: { 
                        HStack {
                            Text("Illness Histories")
                            Spacer()
                            Text("\(userIllnessHistories.count)")
                        }
                    }
                }
                
                if !userAllergies.isEmpty {
                    Section { 
                        ForEach(userAllergies, id: \.self) { allergy in
                            DetailInformation(label: allergy.allergy, value: "")
                        }
                    } header: { 
                        HStack {
                            Text("Allergies")
                            Spacer()
                            Text("\(userAllergies.count)")
                        }
                    }
                }
                
                Button("Delete User", role: .destructive) {
                    self.isDeleteUser.toggle()
                }
            }
        }
        .navigationTitle(self.user.fullName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) { 
                Button(action: {
                    isUpdateData.toggle()
                }, label: {
                    Text("Edit")
                })
            }
        })
        .sheet(isPresented: $isUpdateData ) {
            NavigationStack {
                UserSheet(user: self.user)
            }
        }
        .alert(isPresented: $isDeleteUser) {
            Alert(
                title: Text("Delete this user?"),
                message: Text("You can't undo this action!"),
                primaryButton: .destructive(Text("Delete")) {
                    context.delete(user)
                    navigation!.popViewControllers(viewsToPop: 1)
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear {
            self.userIllnessHistories = self.illnessHistories.filter{ disease in
                disease.patient.identifier == self.user.identifier
            }
            
            self.userAllergies = self.allergies.filter{ allergy in
                allergy.patient.identifier == self.user.identifier
            }
        }
        .onChange(of: self.illnessHistories) {
            self.userIllnessHistories = self.illnessHistories.filter{ disease in
                disease.patient.identifier == self.user.identifier
            }
        }
        .onChange(of: self.allergies) {
            self.userAllergies = self.allergies.filter{ allergy in
                allergy.patient.identifier == self.user.identifier
            }
        }
    }
}
