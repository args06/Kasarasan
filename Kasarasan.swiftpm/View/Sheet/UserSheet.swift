import SwiftUI
import SwiftData
import PhotosUI

struct UserSheet: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @Query var illnessHistories: [IllnessHistory]
    @Query var allergies: [Allergy]
    
    @State var userNickname: String = ""
    @State var userFullname: String = ""
    @State var userImage: Data? = nil
    @State var userBirthday: Date = Date()
    @State var userHeight: Double = 0.0
    @State var userWeight: Double = 0.0
    @State var userSince: Date = Date()
    @State var roleType: String = ""
    @State var userPosition: String = ""
    
    @State var userExpertise: [String] = []
    @State var newExpertise: String = ""
    
    @State var selection: [PhotosPickerItem] = []
    
    @State var selectedRole: String = UserRole.patient.rawValue
    @State var availableRole: [UserRole] = [.patient, .nurse, .doctor]
    
    @State var selectedGender: String = UserGender.male.rawValue
    @State var availableGender: [UserGender] = [.male, .female]
    
    @State var selectedBloodType: String = BloodType.a.rawValue
    @State var availableBloodType: [BloodType] = [.a, .b, .o, .ab]
    
    @State var selectedStatus: String = PatientStatus.inpatient.rawValue
    @State var availableStatus: [PatientStatus] = [.inpatient, .outpatient]
    
    @State var userIllnessTempData: [IllnessHistory] = []
    @State var userAllergyTempData: [Allergy] = []
    
    @State var userIllnessNewData: [IllnessHistory] = []
    @State var userAllergyNewData: [Allergy] = []
    
    @State var isIllnessHistoryEdited: Bool = false
    @State var isAllergyEdited: Bool = false
    
    @State var isFirstIllnessHistoryEdited: Bool = true
    @State var isFirstAllergyEdited: Bool = true
    
    var user: User? = nil
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        VStack {
            Form {
                if self.userImage != nil {
                    PhotosPicker(selection: self.$selection, maxSelectionCount: 1, matching: .images) {
                        Image(uiImage: UIImage(data: self.userImage!)!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, maxHeight: 500, alignment: .center)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .cornerRadius(10)
                    }
                    .listRowInsets(EdgeInsets())
                } else {
                    PhotosPicker(selection: self.$selection, maxSelectionCount: 1, matching: .images) {
                        Rectangle()
                            .frame(height: 200, alignment: .center)
                            .cornerRadius(10)
                            .foregroundColor(.clear)
                            .overlay(alignment: .center) { 
                                Image(systemName: "person.crop.rectangle.badge.plus")
                                    .font(.system(size: 45))
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: 250, alignment: .center)
                            .listRowInsets(EdgeInsets())
                    }
                }
                
                Section { 
                    TextField("Nickname", text: self.$userNickname)
                    TextField("Full Name", text: self.$userFullname)
                    DatePicker("Birthday", selection: self.$userBirthday, in: ...Date(), displayedComponents: .date)
                    Picker(selection: self.$selectedGender) { 
                        ForEach(self.availableGender, id: \.self) { gender in 
                            switch gender {
                            case .male:
                                Text("Male")
                                    .tag(gender.rawValue)
                            case .female:
                                Text("Female")
                                    .tag(gender.rawValue)
                            }
                        }
                    } label: { 
                        Text("Gender")
                    }
                    Picker(selection: self.$selectedBloodType) { 
                        ForEach(self.availableBloodType, id: \.self) { bloodType in 
                            switch bloodType {
                            case .a:
                                Text("A")
                                    .tag(bloodType.rawValue)
                            case .b:
                                Text("B")
                                    .tag(bloodType.rawValue)
                            case .o:
                                Text("O")
                                    .tag(bloodType.rawValue)
                            case .ab:
                                Text("AB")
                                    .tag(bloodType.rawValue)
                            }
                        }
                    } label: { 
                        Text("Blood Type")
                    }
                    TextField("Height", value: self.$userHeight, formatter: self.formatter)
                        .keyboardType(.numberPad)
                    TextField("Weight", value: self.$userWeight, formatter: self.formatter)
                        .keyboardType(.numberPad)
                    DatePicker("Since", selection: self.$userSince, in: ...Date(), displayedComponents: .date)
                } header: {
                    Text("Personal information")
                }
                
                Section { 
                    Picker(selection: self.$selectedRole) { 
                        ForEach(self.availableRole, id: \.self) { role in 
                            switch role {
                            case .patient:
                                Text("Patient")
                                    .tag(role.rawValue)
                            case .nurse:
                                Text("Nurse")
                                    .tag(role.rawValue)
                            case .doctor:
                                Text("Doctor")
                                    .tag(role.rawValue)
                            }
                        }
                    } label: { 
                        Text("Role")
                    }
                    
                    
                    if selectedRole == UserRole.nurse.rawValue {
                        TextField("Position", text: self.$userPosition)
                    }
                    
                    if selectedRole == UserRole.doctor.rawValue {
                        TextField("Role Type", text: self.$roleType)
                        DisclosureGroup("Expertise") {
                            ForEach(userExpertise, id: \.self) { expert in
                                HStack {
                                    Text(expert)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .contentShape(Rectangle())
                                }
                            }
                            .onDelete{ indexSet in
                                indexSet.forEach { index in
                                    userExpertise.remove(at: index)
                                }
                            }
                            
                            TextField("Insert Expertise", text: self.$newExpertise)
                            
                            Button("Add") {
                                userExpertise.append(newExpertise)
                                newExpertise = ""
                            }
                        }
                        
                    }
                    if selectedRole == UserRole.patient.rawValue {
                        Picker(selection: self.$selectedStatus) { 
                            ForEach(self.availableStatus, id: \.self) { status in 
                                switch status {
                                case .inpatient:
                                    Text("Inpatient")
                                        .tag(status.rawValue)
                                case .outpatient:
                                    Text("Outpatient")
                                        .tag(status.rawValue)
                                }
                            }
                        } label: { 
                            Text("Patient Status")
                        }
                    }
                } header: {
                    Text("Role information")
                }
                
                if selectedRole == "Patient" {
                    
                    Section { 
                        VStack {
                            IllnessChipView(
                                chips: $userIllnessNewData, 
                                placeholder: "Insert Disease"
                            )
                        }
                        
                    } header: {
                        Text("Illness History")
                    }
                    
                    Section { 
                        AllergyChipView(
                            chips: $userAllergyNewData, 
                            placeholder: "Insert Allergy"
                        )
                    } header: {
                        Text("Allergy")
                    }
                }
                
                Button(action: {
                    if !self.userNickname.isEmpty {
                        if self.user != nil {
                            self.user!.nickname = self.userNickname
                            self.user!.fullName = self.userFullname
                            self.user!.picture = self.userImage
                            self.user!.birthDate = self.userBirthday
                            self.user!.gender = self.selectedGender
                            self.user!.bloodType = self.selectedBloodType
                            self.user!.height = self.userHeight
                            self.user!.weight = self.userWeight
                            self.user!.since = self.userSince
                            self.user!.userRole = self.selectedRole
                            self.user!.position = self.userPosition
                            self.user!.roleType = self.roleType
                            self.user!.expertise = self.userExpertise
                            self.user!.patientStatus = self.selectedStatus
                            
                            if self.isIllnessHistoryEdited {
                                for disease in userIllnessTempData {
                                    context.delete(disease)
                                }
                                
                                for disease in userIllnessNewData {
                                    let storedDisease = IllnessHistory(
                                        identifier: disease.identifier, 
                                        disease: disease.disease, 
                                        patient: user!
                                    )
                                    context.insert(storedDisease)
                                }
                            }
                            
                            if self.isAllergyEdited {
                                for allergy in userAllergyTempData {
                                    context.delete(allergy)
                                }
                                
                                for allergy in userAllergyNewData {
                                    let storedAllergy = Allergy(
                                        identifier: allergy.identifier, 
                                        allergy: allergy.allergy, 
                                        patient: user!
                                    )
                                    context.insert(storedAllergy)
                                }
                            }
                        } else {
                            let newUser = User(
                                identifier: UUID().uuidString,
                                nickname: self.userNickname,
                                fullName: self.userFullname,
                                picture: self.userImage,
                                gender: self.selectedGender,
                                birthDate: self.userBirthday,
                                bloodType: self.selectedBloodType,
                                height: self.userHeight,
                                weight: self.userWeight,
                                roleType: self.roleType,
                                expertise: self.userExpertise,
                                position: self.userPosition,
                                userRole: self.selectedRole,
                                since: self.userSince,
                                patientStatus: self.selectedStatus
                            )
                            context.insert(newUser)
                            
                            if !userIllnessNewData.isEmpty {
                                let _ = print("Here Illness")
                                for disease in self.userIllnessNewData {
                                    let storedDisease = IllnessHistory(
                                        identifier: disease.identifier, 
                                        disease: disease.disease, 
                                        patient: newUser
                                    )
                                    let _ = print("Illness Added")
                                    context.insert(storedDisease)
                                }
                            }
                            
                            if !userAllergyNewData.isEmpty {
                                let _ = print("Here Allergy")
                                for allergy in self.userAllergyNewData {
                                    let storedAllergy = Allergy(
                                        identifier: allergy.identifier, 
                                        allergy: allergy.allergy, 
                                        patient: newUser
                                    )
                                    let _ = print("Allergy Added")
                                    context.insert(storedAllergy)
                                }
                            }
                        }
                        
                        userIllnessTempData = []
                        userAllergyTempData = []
                        
                        try? context.save()
                        
                        self.dismiss()
                    }
                }, label: {
                    HStack {
                        Spacer()
                        Text(self.user != nil ? "Save" : "Create User")
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                })
                .disabled(self.userNickname.isEmpty)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .listRowInsets(EdgeInsets())
            }
        }
        .onChange(of: self.selection) {
            for value in self.selection {
                let _ = self.loadTransferable(from: value)
            }
        }
        .onChange(of: self.userIllnessNewData) {
            if isFirstIllnessHistoryEdited && !userIllnessTempData.isEmpty {
                isFirstIllnessHistoryEdited = false
            } else {
                isIllnessHistoryEdited = true
            }
        }
        .onChange(of: self.userAllergyNewData) {
            if isFirstAllergyEdited && !userAllergyTempData.isEmpty{
                isFirstAllergyEdited = false
            } else {
                isAllergyEdited = true
            }
        }
        .onAppear(perform: {
            if user != nil {
                self.userNickname = self.user!.nickname
                self.userFullname = self.user!.fullName
                self.userImage = self.user!.picture
                self.userBirthday = self.user!.birthDate
                self.selectedGender = self.user!.gender
                self.selectedBloodType = self.user!.bloodType
                self.userHeight = self.user!.height
                self.userWeight = self.user!.weight
                self.userSince = self.user!.since
                self.selectedRole = self.user!.userRole
                self.roleType = self.user!.roleType
                self.userPosition = self.user!.position
                self.userExpertise = self.user!.expertise
                self.selectedStatus = self.user!.patientStatus
                
                let userIllnessHistories = self.illnessHistories.filter{ disease in
                    disease.patient.identifier == self.user!.identifier
                }
                
                if(!userIllnessHistories.isEmpty) {
                    self.userIllnessTempData = userIllnessHistories
                    self.userIllnessNewData = userIllnessHistories
                }
                
                let userAllergies = self.allergies.filter{ allergy in
                    allergy.patient.identifier == self.user!.identifier
                }
                
                if(!userAllergies.isEmpty) {
                    self.userAllergyTempData = userAllergies
                    self.userAllergyNewData = userAllergies
                }
            }
        })
    }
    
    func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == imageSelection else { 
                    return 
                }
                switch result {
                case .success(let data?):
                    self.userImage = data
                case .success(nil):
                    break
                case .failure(_):
                    break
                }
            }
        }
    }
    
}
