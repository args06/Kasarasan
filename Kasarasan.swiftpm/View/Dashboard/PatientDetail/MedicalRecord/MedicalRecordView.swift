import SwiftUI
import SwiftData

struct MedicalRecordView: View {
    @Environment(\.modelContext) private var context
    
    @Query(sort: \MedicalRecord.date, order: .forward) var medicalRecords: [MedicalRecord]
    
    @State var dateFilter : Date = Date()
    @State var filterState: Bool = false
    @State var userMedicalRecords: [MedicalRecord] = []
    @State var addMedicalRecord: Bool = false
    
    var user: User
    
    var body: some View {
        NavigationStack {
            VStack {
                if(userMedicalRecords.isEmpty) {
                    ContentUnavailableView("There is no data here", systemImage: "nosign")
                } else {
                    List(userMedicalRecords) { data in
                        NavigationLink {
                            MedicalRecordSheet(user: user, medicalRecord: data)
                        } label: {
                            Text(data.date.toString(dateFormat: "dd MMMM yyyy - hh:mm a"))
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Medical Record")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { 
                    Button(action: {
                        filterState = false
                        userMedicalRecords = getFilterData(list: resetData(), startDate: dateFilter, filterState: filterState)
                    }, label: {
                        Text("Reset")
                    })
                    .disabled(!filterState)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) { 
                    Image(systemName: "calendar")
                        .overlay {
                            DatePicker("", selection: self.$dateFilter, in: ...Date())
                                .blendMode(.destinationOver) 
                                .onChange(of: dateFilter) { 
                                    filterState = true
                                    userMedicalRecords = getFilterData(list: resetData(), startDate: dateFilter, filterState: filterState)
                                }
                        }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) { 
                    Button(action: {
                        self.addMedicalRecord.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    })
                }
            }
            .sheet(isPresented: self.$addMedicalRecord, content: {
                NavigationView(content: {
                    MedicalRecordSheet(user: user)
                })
            })
            .onAppear {
                self.userMedicalRecords = resetData()
            }
            .onChange(of: medicalRecords) {
                self.userMedicalRecords = resetData()
            }
        }
    }
    
    func resetData() -> [MedicalRecord] {
        return medicalRecords.filter {
            $0.patient.identifier == self.user.identifier
        }
    }
}
