import SwiftUI
import SwiftData

struct TriggeredActivitySheet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @Query var users: [User]
    
    var user: User? = nil
    var triggeredData: TriggeredActivity? = nil
    
    @State var nurses: [User] = []
    @State var patients: [User] = []
    
    @State var triggeredDate: Date = Date()
    @State var triggeredTime: Int = 0
    @State var selectedNurse: User = User()
    @State var selectedPatient: User = User()
    @State var rootCause: String = ""
    @State var description: String = "" 
    
    @State var hour: Int = 0
    @State var minute: Int = 0
    @State var second: Int = 0
    
    @State var isInsertData: Bool = false
    @State var isManualInsert: Bool = false
    @State var isFirstMenu: Bool = true
    @State var isDeleteData: Bool = false
    
    var body: some View {
        VStack {
            if isInsertData {
                Form {
                    Section {
                        if user != nil {
                            DetailInformation(label: "Patient Name", value: user!.fullName)
                            
                            DetailInformation(
                                label: "Date of Birth", 
                                value: self.user!.birthDate.toString(dateFormat: "MM/dd/yyyy")
                            )
                            
                            DetailInformation(label: "Gender", value: self.user!.gender)
                            
                            DetailInformation(label: "Patient Status", value: self.user!.patientStatus)
                        } else {
                            if !self.patients.isEmpty {
                                Picker(selection: self.$selectedPatient) { 
                                    ForEach(self.patients, id: \.self) { patient in 
                                        Text(patient.fullName)
                                    }
                                } label: { 
                                    Text("Patient")
                                }
                            } else {
                                Text("Please Add Patient First!")
                                    .foregroundStyle(.red)
                            }
                            
                        }
                    } header: {
                        Text("Personal Information")
                    }
                    
                    
                    Section { 
                        DatePicker("Triggered Date", selection: self.$triggeredDate, in: ...Date(), displayedComponents: .date)
                        
                        if isManualInsert {
                            HStack {
                                Text("Triggered Time")
                                
                                Spacer()
                                
                                Picker("", selection: $hour) {
                                    ForEach(0...23, id: \.self) { number in
                                        Text("\(number)h")
                                            .font(.custom("", size: 16))
                                    }
                                }
                                .frame(width: 55, height: 40)
                                .pickerStyle(.wheel)
                                .clipped()
                                
                                Text(":")
                                
                                Picker("", selection: $minute) {
                                    ForEach(0...59, id: \.self) { number in
                                        Text("\(number)m")
                                            .font(.custom("", size: 16))
                                    }
                                }
                                .frame(width: 55, height: 40)
                                .pickerStyle(.wheel)
                                .clipped()
                                .padding(.horizontal, 0)
                                
                                Text(":")
                                
                                Picker("", selection: $second) {
                                    ForEach(0...59, id: \.self) { number in
                                        Text("\(number)s")
                                            .font(.custom("", size: 16))
                                    }
                                }
                                .frame(width: 55, height: 40)
                                .pickerStyle(.wheel)
                            }
                        } else {
                            DetailInformation(label: "Triggered Time", value: showSplitSecond(second: triggeredTime))
                        }
                        
                        TextField("Root Cause", text: $rootCause)
                        
                        TextField("Description", text: $description, axis: .vertical)
                            .lineLimit(2...6)
                        
                        if !self.nurses.isEmpty {
                            Picker(selection: self.$selectedNurse) { 
                                ForEach(self.nurses, id: \.self) { nurse in 
                                    Text(nurse.fullName)
                                }
                            } label: { 
                                Text("Nurse")
                            }
                        } else {
                            Text("Please Add Nurse First!")
                                .foregroundStyle(.red)
                        }
                        
                    } header: {
                        Text("Triggered Data")
                    }
                }
            } else {
                if isFirstMenu {
                    VStack {
                        Button("Manual Insert Data") { 
                            isInsertData = true
                            isManualInsert = true
                            isFirstMenu = false
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Timer Insert Data") { 
                            isInsertData = false
                            isManualInsert = false
                            isFirstMenu = false
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 12)
                    }
                } else {
                    if !isManualInsert {
                        TimerView(
                            isInsertData: $isInsertData, 
                            triggeredTime: $triggeredTime,
                            isFirstMenu: $isFirstMenu
                        )
                    }
                }
            }
        }
        .navigationTitle(self.triggeredData != nil ? "Update Triggered Data" : "Insert Triggered Data")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.nurses = self.users.filter { user in
                user.userRole == UserRole.nurse.rawValue
            }
            if !self.nurses.isEmpty {
                self.selectedNurse = nurses[0]
            }
            
            self.patients = self.users.filter { user in
                user.userRole == UserRole.patient.rawValue
            }
            if !self.patients.isEmpty {
                self.selectedPatient = patients[0]
            }
            
            if triggeredData != nil {
                isFirstMenu = false
                isInsertData = true
                isManualInsert = true
                
                self.rootCause = triggeredData!.rootCause
                self.triggeredDate = triggeredData!.date
                self.description = triggeredData!.desc
                self.selectedNurse = triggeredData!.nurse
                
                let triggeredTime = splitSecond(second: triggeredData!.second)
                
                self.hour = triggeredTime.hour
                self.minute = triggeredTime.minute
                self.second = triggeredTime.second
            }
        }
        .alert(isPresented: $isDeleteData) {
            Alert(
                title: Text("Delete this data?"),
                message: Text("You can't undo this action!"),
                primaryButton: .destructive(Text("Delete")) {
                    if triggeredData != nil {
                        context.delete(triggeredData!)
                        try? context.save()
                    }
                    
                    dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .toolbar {
            if isInsertData {
                if triggeredData == nil {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Back") { 
                            isFirstMenu.toggle()
                            isInsertData.toggle()
                            triggeredTime = 0
                        }
                        .foregroundColor(.red)
                    }
                }
                
                if triggeredData != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: {
                            isDeleteData.toggle()
                        }, label: {
                            Text("Remove")
                                .bold()
                                .foregroundStyle(.red)
                        })
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        if triggeredData != nil {
                            if isManualInsert {
                                triggeredTime = mergeSecond(hour: hour, minute: minute, second: second)
                            }
                            
                            self.triggeredData!.date = self.triggeredDate
                            self.triggeredData!.second = self.triggeredTime
                            self.triggeredData!.rootCause = self.rootCause
                            self.triggeredData!.desc = self.description
                            self.triggeredData!.nurse = self.selectedNurse
                        } else {
                            if isManualInsert {
                                triggeredTime = mergeSecond(hour: hour, minute: minute, second: second)
                            }
                            
                            if user != nil {
                                let triggeredActivity = TriggeredActivity(
                                    identifier: UUID().uuidString, 
                                    date: triggeredDate, 
                                    second: triggeredTime, 
                                    rootCause: rootCause, 
                                    desc: description, 
                                    nurse: selectedNurse, 
                                    patient: user!
                                )
                                context.insert(triggeredActivity)
                            }
                            
                            if !selectedPatient.identifier.isEmpty && user == nil {
                                let triggeredActivity = TriggeredActivity(
                                    identifier: UUID().uuidString, 
                                    date: triggeredDate, 
                                    second: triggeredTime, 
                                    rootCause: rootCause, 
                                    desc: description, 
                                    nurse: selectedNurse, 
                                    patient: selectedPatient
                                )
                                context.insert(triggeredActivity)
                            }
                        }
                        
                        try? context.save()
                        dismiss()
                    }, label: {
                        Text(self.triggeredData != nil ? "Save" : "Insert")
                            .bold()
                    })
                    .disabled(self.description.isEmpty || self.rootCause.isEmpty || self.selectedNurse.identifier.isEmpty)
                }
            }
        }
    }
}
