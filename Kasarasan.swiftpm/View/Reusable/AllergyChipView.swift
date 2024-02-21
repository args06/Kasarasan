import SwiftUI

struct AllergyChipView: View {
    @Binding var chips: [Allergy]
    var placeholder: String
    
    @State private var inputText = ""
    
    @State private var showAlert = false
    @State var selectedChip : Allergy? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(chips, id: \.self) { chip in
                        Chip(text: chip.allergy)
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
                        let newChip = Allergy(
                            identifier: UUID().uuidString, 
                            allergy: inputText,
                            patient: User()
                        )
                        chips.append(newChip)
                        inputText = ""
                    }
                }
        }
    }
    
    func getDialogTitle() -> String {
        return "Remove \(selectedChip?.allergy ?? "") Allergy"
    }
}
