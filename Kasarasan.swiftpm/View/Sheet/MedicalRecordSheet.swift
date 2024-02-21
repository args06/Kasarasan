import SwiftUI
import SwiftData

struct MedicalRecordSheet: View {
    @Environment(\.modelContext) var context
    @Environment(\.dismiss) var dismiss
    
    @Query var users: [User]
    @Query var illnessHistories: [IllnessHistory]
    @Query var allergies: [Allergy]
    @Query var medications: [Medication]
    
    var user: User
    var medicalRecord: MedicalRecord? = nil
    
    @State var doctors: [User] = []
    @State var userIllnessHistories: [IllnessHistory] = []
    @State var userAllergies: [Allergy] = []
    
    @State var consultationDate: Date = Date()
    @State var selectedDoctor: User = User()
    @State var description: String = "" 
    @State var newMedicine: String = ""
    @State var newDosage: String = ""
    @State var userDiagnose: String = ""
    
    @State var tempMedications: [Medication] = []
    @State var newMedications: [Medication] = []
    
    @State var userSymptoms: [String] = []
    @State var newSymptom: String = ""
    
    @State var isDeleteData: Bool = false
    
    var body: some View {
        VStack {
            Form {
                Section {
                    DetailInformation(label: "Patient Name", value: user.fullName)
                    
                    DetailInformation(
                        label: "Date of Birth", 
                        value: self.user.birthDate.toString(dateFormat: "MM/dd/yyyy")
                    )
                    
                    DetailInformation(label: "Gender", value: user.gender)
                    
                    DetailInformation(label: "Patient Status", value: user.patientStatus)
                    
                    if !userIllnessHistories.isEmpty {
                        DisclosureGroup("Illness History") {
                            ForEach(userIllnessHistories, id: \.self) { illness in
                                HStack {
                                    Text(illness.disease)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                            }
                        }
                    }
                    
                    if !userAllergies.isEmpty {
                        DisclosureGroup("Allergy") {
                            ForEach(userAllergies, id: \.self) { allergy in
                                HStack {
                                    Text(allergy.allergy)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                            }
                        }
                    }
                } header: {
                    Text("Personal Information")
                }
                
                Section {
                    if !self.doctors.isEmpty {
                        Picker(selection: self.$selectedDoctor) { 
                            ForEach(self.doctors, id: \.self) { doctor in 
                                Text(doctor.fullName)
                            }
                        } label: { 
                            Text("Doctor")
                        }
                        
                        DetailInformation(label: "Role Type", value: selectedDoctor.roleType)
                        
                        DisclosureGroup("Expertise") {
                            ForEach(selectedDoctor.expertise, id: \.self) { expert in
                                HStack {
                                    Text(expert)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .contentShape(Rectangle())
                                }
                            }
                        }
                    } else {
                        
                        Text("Please Add Doctor First!")
                            .foregroundStyle(.red)
                    }
                    
                    DatePicker("Consultation Date", selection: self.$consultationDate, in: ...Date(), displayedComponents: .date)
                    
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(2...6)
                } header: {
                    Text("Medical Record Data")
                }
                
                Section {
                    TextField("Diagnose", text: self.$userDiagnose)
                    
                    DisclosureGroup("Symptoms") {
                        ForEach(userSymptoms, id: \.self) { symptom in
                            HStack {
                                Text(symptom)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .contentShape(Rectangle())
                            }
                        }
                        .onDelete{ indexSet in
                            indexSet.forEach { index in
                                userSymptoms.remove(at: index)
                            }
                        }
                        
                        TextField("Enter Symptom", text: $newSymptom, axis: .vertical)
                        
                        Button("Add Symptom") {
                            userSymptoms.append(newSymptom)
                            newSymptom = ""
                        }
                    }
                } header: {
                    Text("Medical Conditions")
                }
                
                Section {
                    HStack {
                        Text("Medicine")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                        
                        Text("Dosage")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    ForEach(newMedications, id: \.self) { medicine in
                        HStack {
                            Text(medicine.medicine)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                            
                            Text(medicine.dosage)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .contentShape(Rectangle())
                        }
                    }
                    .onDelete{ indexSet in
                        indexSet.forEach { index in
                            newMedications.remove(at: index)
                        }
                    }
                    
                    HStack {
                        TextField("Enter Medicine", text: $newMedicine, axis: .vertical)
                        TextField("Enter Dosage", text: $newDosage, axis: .vertical)
                    }
                    
                    Button("Add") {
                        newMedications.append(
                            Medication(
                                identifier: UUID().uuidString,
                                medicine: newMedicine, 
                                dosage: newDosage,
                                medicalRecord: (medicalRecord == nil) ? MedicalRecord() : self.medicalRecord!
                            )
                        )
                        newMedicine = ""
                        newDosage = ""
                    }
                } header: {
                    Text("Medications")
                }
            }
        }
        .navigationTitle(self.medicalRecord != nil ? "Update Medical Record" : "Insert Medical Record")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.doctors = self.users.filter { user in
                user.userRole == UserRole.doctor.rawValue
            }
            
            self.userIllnessHistories = self.illnessHistories.filter { illness in
                illness.patient.identifier == user.identifier
            }
            
            self.userAllergies = self.allergies.filter { allergy in
                allergy.patient.identifier == user.identifier
            }
            
            if !self.doctors.isEmpty {
                self.selectedDoctor = doctors[0]
            }
            if medicalRecord != nil {
                self.consultationDate = medicalRecord!.date
                self.description = medicalRecord!.desc
                self.userDiagnose = medicalRecord!.diagnose
                self.userSymptoms = medicalRecord!.symptoms
                self.selectedDoctor = medicalRecord!.doctor
                
                let userMedications = self.medications.filter{ medicine in
                    medicine.medicalRecord.identifier == self.medicalRecord!.identifier
                }
                
                if !userMedications.isEmpty {
                    self.tempMedications = userMedications
                    self.newMedications = userMedications
                }
            }
        }
        .alert(isPresented: $isDeleteData) {
            Alert(
                title: Text("Delete this data?"),
                message: Text("You can't undo this action!"),
                primaryButton: .destructive(Text("Delete")) {
                    if medicalRecord != nil {
                        context.delete(medicalRecord!)
                        try? context.save()
                    }
                    
                    dismiss()
                },
                secondaryButton: .cancel()
            )
        }
        .toolbar {
            if medicalRecord != nil {
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
                    if medicalRecord != nil {
                        self.medicalRecord!.date = self.consultationDate
                        self.medicalRecord!.desc = self.description
                        self.medicalRecord!.diagnose = self.userDiagnose
                        self.medicalRecord!.symptoms = self.userSymptoms
                        self.medicalRecord!.doctor = self.selectedDoctor
                        
                        for medicine in tempMedications {
                            context.delete(medicine)
                        }
                        
                        for medicine in newMedications {
                            context.insert(medicine)
                        }
                    } else {
                        let newMedicalRecord = MedicalRecord(
                            identifier: UUID().uuidString, 
                            date: consultationDate, 
                            desc: description,
                            diagnose: userDiagnose,
                            symptoms: userSymptoms,
                            doctor: selectedDoctor, 
                            patient: user
                        )
                        context.insert(newMedicalRecord)
                        
                        for medicine in newMedications {
                            let newMedicine = Medication(
                                identifier: medicine.identifier,
                                medicine: medicine.medicine, 
                                dosage: medicine.dosage,
                                medicalRecord: newMedicalRecord
                            )
                            context.insert(newMedicine)
                        }
                    }
                    
                    try? context.save()
                    dismiss()
                }, label: {
                    Text(self.medicalRecord != nil ? "Save" : "Insert")
                        .bold()
                })
                .disabled(self.description.isEmpty || self.selectedDoctor.identifier.isEmpty)
            }
        }
    }
}
