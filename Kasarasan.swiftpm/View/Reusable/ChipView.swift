import SwiftUI

struct ChipView<T: Hashable>: View {
    @Binding var chips: [T]
    let placeholder: String
    let user: User
    var isHistoryIllness = false
    
    @State private var inputText = ""
    
    @State private var showAlert = false
    @State var selectedChip : T? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(chips, id: \.self) { chip in
                        if isHistoryIllness {
                            let parsedChip = chip as? IllnessHistory
                            Chip(text: parsedChip?.disease ?? "Disease")
                                .onTapGesture {
                                    selectedChip = chip
                                    showAlert.toggle()
                                }
                        } else {
                            let parsedChip = chip as? Allergy
                            Chip(text: parsedChip?.allergy ?? "Allergy")
                                .onTapGesture {
                                    selectedChip = chip
                                    showAlert.toggle()
                                }
                        }
                        
                    }
                }
                .alert(
                    Text(getDialogTitle()), 
                    isPresented: $showAlert
                ) {
                    Button("Cancel", role: .cancel) {}
                    Button("Remove") {
                        if selectedChip != nil {
                            chips.removeAll(
                                where: { $0 == selectedChip }
                            )
                        }
                    }
                }
            }
            
            TextField(placeholder, text: $inputText, axis: .vertical)
                .onSubmit(of: .text) {
                    if isHistoryIllness {
                        let newChip = IllnessHistory(
                            identifier: UUID().uuidString, 
                            disease: inputText,
                            patient: user
                        )
                        chips.append(newChip as! T)
                    } else {
                        let newChip = Allergy(
                            identifier: UUID().uuidString, 
                            allergy: inputText,
                            patient: user
                        )
                        chips.append(newChip as! T)
                    }
                    inputText = ""
                }
        }
    }
    
    func getDialogTitle() -> String {
        if (isHistoryIllness) {
            let parsedChip = selectedChip as! IllnessHistory
            return "Remove \(parsedChip.disease) Disease"
        } else {
            let parsedChip = selectedChip as! Allergy
            return "Remove \(parsedChip.allergy) Allergy"
        }
    }
}
