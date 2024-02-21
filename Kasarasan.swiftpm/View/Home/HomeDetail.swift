import SwiftUI
import SwiftData

struct HomeDetail: View {
    @Environment(\.modelContext) private var context
    
    var userRole = "Patient" 
    
    @Query(
        sort: \User.fullName
    ) var users: [User]
    
    @State var createNewPerson: Bool = false
    @State var deletePerson: Bool = false
    
    @State var filteredUser: [User] = []
    
    @State var searchTerm: String = ""
    
    var body: some View {
        VStack {
            List { 
                if filteredUser.isEmpty {
                    ContentUnavailableView("There is no \(userRole.lowercased()) here...", systemImage: "nosign")
                } else {
                    ForEach(self.filteredUser, id: \.self.identifier) { user in
                        NavigationLink {
                            if userRole == UserRole.patient.rawValue {
                                PatientDashboard(user: user)
                            } else {
                                UserDashboard(user: user, userRole: user.userRole)
                            }
                        } label: { 
                            HStack {
                                if user.picture != nil {
                                    Image(uiImage: UIImage(data: user.picture!)!)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .cornerRadius(10)
                                } else {
                                    Rectangle()
                                        .foregroundColor(.secondary)
                                        .scaledToFill()
                                        .frame(width: 50, height: 50, alignment: .center)
                                        .cornerRadius(10)
                                        .overlay { 
                                            Image(systemName: "figure.soccer")
                                        }
                                }
                                
                                VStack {
                                    HStack {
                                        Text("\(user.fullName)")
                                        Spacer()
                                    }
                                }
                                .padding(.leading)
                            }
                        }
                    }
                }
            }
            .navigationTitle("\(userRole) Dashboard")
            .searchable(text: self.$searchTerm, prompt: Text("Search \(userRole.lowercased())..."))
        }
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) { 
                Button(action: {
                    self.createNewPerson.toggle()
                }, label: {
                    Image(systemName: "plus")
                        .fontWeight(.bold)
                })
            }
        })
        .sheet(isPresented: self.$createNewPerson, content: {
            NavigationView(content: {
                UserSheet()
            })
        })
        .onAppear {
            self.filteredUser = users.filter {
                $0.userRole == self.userRole
            }
        }
        .onChange(of: self.searchTerm) {
            if !searchTerm.isEmpty {
                self.filteredUser = users.filter {
                    $0.fullName.contains(searchTerm) && $0.userRole == self.userRole
                }
            } else {
                self.filteredUser = users.filter {
                    $0.userRole == self.userRole
                }
            }
        }
        .onChange(of: self.users) {
            self.filteredUser = users.filter {
                $0.userRole == self.userRole
            }
        }
    }
}
