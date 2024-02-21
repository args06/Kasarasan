import SwiftUI
import SwiftData
import Charts

struct TriggeredActivityView: View {
    @Environment(\.managedObjectContext) var context
    
    var user: User
    
    @Query(sort: \TriggeredActivity.date, order: .forward) var triggeredActivities: [TriggeredActivity]
    
    @State private var dateFilter : Date = Date()
    @State var filterState: Bool = false
    @State var userTriggeredActivities: [TriggeredActivity] = []
    @State var addTriggeredData: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if(userTriggeredActivities.isEmpty && resetData().isEmpty) {
                    ContentUnavailableView("There is no data here", systemImage: "nosign")
                } else {
                    Chart() {
                        ForEach(cleanedData().suffix(7), id: \.self) { data in
                            LineMark(
                                x: .value("Date", data.date),
                                y: .value("Value", data.value)
                            )
                            PointMark(
                                x: .value("Date", data.date),
                                y: .value("Value", data.value)
                            )
                        }
                    }
                    .frame(height: 250)
                    .padding([.horizontal,.top], 12)
                    .chartXAxisLabel(position: .bottom, alignment: .center, spacing: 25) {
                        Text("Date")
                    }
                    .chartYAxisLabel(position: .leading, alignment: .center, spacing: 25) {
                        Text("Triggered Count")
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    if(userTriggeredActivities.isEmpty) {
                        ContentUnavailableView("There is no data with selected date", systemImage: "nosign")
                    } else {
                        List(userTriggeredActivities) { data in
                            NavigationLink {
                                TriggeredActivitySheet(user: user, triggeredData: data)
                            } label: {
                                Text(data.date.toString(dateFormat: "dd MMMM yyyy - hh:mm a"))
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Triggered Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { 
                    Button(action: {
                        filterState = false
                        userTriggeredActivities = getFilterData(list: resetData(), startDate: dateFilter, filterState: filterState)
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
                                    userTriggeredActivities = getFilterData(list: resetData(), startDate: dateFilter, filterState: filterState)
                                }
                        }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) { 
                    Button(action: {
                        self.addTriggeredData.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .fontWeight(.bold)
                    })
                }
            }
            .sheet(isPresented: self.$addTriggeredData, content: {
                NavigationView(content: {
                    TriggeredActivitySheet(user: user)
                })
            })
            .onAppear {
                self.userTriggeredActivities = resetData()
            }
            .onChange(of: triggeredActivities) {
                self.userTriggeredActivities = resetData()
            }
        }
    }
    
    func resetData() -> [TriggeredActivity] {
        return triggeredActivities.filter {
            $0.patient.identifier == self.user.identifier
        }
    }
    
    func cleanedData() -> [ShowedTriggeredData] {
        let formattedData = resetData().map {
            $0.copy(date: $0.date.stripTime())
        }
        
        let sortedData =  Dictionary(grouping: formattedData, by: { $0.date }).mapValues { items in items.count }.sorted(by: { $0.key < $1.key})
        
        var fixedData : [ShowedTriggeredData] = []
        
        if !sortedData.isEmpty {
            for i in 0...sortedData.count - 1 {
                let newDate = sortedData[i].key
                let newFixData = ShowedTriggeredData(
                    date: newDate.toString(dateFormat: "dd MMM yy"), 
                    value: sortedData[i].value
                )
                fixedData.append(newFixData)
            }
        }
        return fixedData
    }
}
