import SwiftUI

struct TimerView: View {
    @ObservedObject var stopWatch = StopWatch()
    
    @Binding var isInsertData: Bool
    @Binding var triggeredTime: Int
    @Binding var isFirstMenu: Bool
    
    @State var isTimerRunning: Bool = false
    
    var body: some View {
        
        let hours = String(format: "%02d", stopWatch.counter / 3600)
        let minutes = String(format: "%02d", (stopWatch.counter / 60) % 60)
        let seconds = String(format: "%02d", stopWatch.counter % 60)
        let union = hours + " : " + minutes + " : " + seconds
        
        VStack {
            Spacer()
            HStack {
                if isTimerRunning {
                    ButtonState(stopWatch: stopWatch, isTimerRunning: $isTimerRunning, label: "Pause")
                } else {
                    if stopWatch.counter == 0 {
                        ButtonState(stopWatch: stopWatch, isTimerRunning: $isTimerRunning, label: "Start")
                    } else {
                        ButtonState(stopWatch: stopWatch, isTimerRunning: $isTimerRunning, label: "Resume")
                    }
                }
                
                ButtonState(stopWatch: stopWatch, isTimerRunning: $isTimerRunning, label: "Reset")
            }
            Text("\(union)")
                .font(.custom("", size: 52))
                .padding(.top, 72)
            
            Spacer()
        }
        
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Back") { 
                    isFirstMenu.toggle()
                    stopWatch.reset()
                }
                .foregroundColor(.red)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    triggeredTime = stopWatch.counter 
                    isInsertData.toggle()
                }, label: {
                    Text("Insert Data")
                })
                .disabled(isTimerRunning || stopWatch.counter == 0)
            }
        }
    }
}

struct ButtonState: View {
    
    @ObservedObject var stopWatch: StopWatch
    @Binding var isTimerRunning: Bool
    
    var label: String
    
    var body: some View {
        if label == "Reset" {
            Button(label) {
                self.stopWatch.reset()
                self.stopWatch.isTimerRunning = false
                isTimerRunning = false
            }.foregroundStyle(.red)
        } else {
            Button(label) {
                if label == "Start" || label == "Resume" {
                    self.stopWatch.start() 
                    self.stopWatch.isTimerRunning = true
                    isTimerRunning = true
                } else if label == "Pause" {
                    self.stopWatch.stop() 
                    self.stopWatch.isTimerRunning = false
                    isTimerRunning = false
                }
            }
        }
    }
}

class StopWatch: ObservableObject {
    
    @Published var counter: Int = 0
    var timer = Timer()
    
    var isTimerRunning : Bool = false
    
    func start() {
        if !isTimerRunning {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                self.counter += 1
            }
        }
    }
    func stop() {
        self.timer.invalidate()
    }
    func reset() {
        self.counter = 0
        self.timer.invalidate()
    }
}
