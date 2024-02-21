import SwiftUI

struct IllnessChipView: View {
    @Binding var chips: [IllnessHistory]
    var placeholder: String
    
    @State private var inputText = ""
    
    @State private var showAlert = false
    @State var selectedChip : IllnessHistory? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(chips, id: \.self) { chip in
                        Chip(text: chip.disease)
                            .onTapGesture {
                                selectedChip = chip
                                showAlert.toggle()
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
                                where: { $0.identifier == selectedChip?.identifier ?? "" }
                            )
                        }
                    }
                }
            }
            
            TextField(placeholder, text: $inputText)
                .lineLimit(1)
                .onSubmit(of: .text) {
                    if !inputText.isEmpty {
                        let newChip = IllnessHistory(
                            identifier: UUID().uuidString, 
                            disease: inputText,
                            patient: User()
                        )
                        chips.append(newChip)
                        inputText = ""
                    }
                }
        }
    }
    
    func getDialogTitle() -> String {
        return "Remove \(selectedChip?.disease ?? "") Disease"
    }
}
