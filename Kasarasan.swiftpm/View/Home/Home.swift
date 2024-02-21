import SwiftUI

struct Home: View {
    
    @State var addTriggeredData = false
    
    var body: some View {
        NavigationStack {
            List(menus) { menu in
                NavigationLink {
                    HomeDetail(userRole: menu.name)
                } label : {
                    NavigationRow(menu: menu)
//                    Text(menu.name)
                }
            }
            .navigationTitle("Dashboard")
            .sheet(isPresented: self.$addTriggeredData, content: {
                NavigationView {
                    TriggeredActivitySheet()
                }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { 
                    Button(action: {
                        addTriggeredData.toggle()
                    }, label: {
                        Text("Add Triggered Data")
                    })
                }
            }
        }
    }
}
