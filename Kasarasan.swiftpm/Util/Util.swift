import SwiftUI

func convertDoubleToString(value: Double) -> String {
    return String(format: "%.2f", value)
}

func showSplitSecond(second: Int) -> String {
    var result = ""
    if second > 0 {
        let hour = second / 3600
        let minute = (second / 60) % 60
        let second = second % 60
        
        if hour >= 1 {
            result = result + "\(hour)h "
        }
        if minute >= 1 {
            result = result + "\(minute)m "
        } 
        if second >= 1 {
            result = result + "\(second)s "
        }
    } else {
        result = "0s"
    }
    return result
}

func splitSecond(second: Int) -> (hour: Int, minute: Int, second: Int) {
    if second > 0 {
        let hour = second / 3600
        let minute = (second / 60) % 60
        let second = second % 60
        
        return (hour, minute, second)
    } else {
        return (0,0,0)
    }
}

func mergeSecond(hour: Int, minute: Int, second: Int) -> Int {
    let newHour = hour * 3600
    let newMinute = minute * 60
    return newHour + newMinute + second
}

func getFilterData(list: [TriggeredActivity], startDate: Date, filterState: Bool) -> [TriggeredActivity] {
    
    let newStartDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: startDate)!
    
    let endDate = newStartDate.addingTimeInterval(86400)
    
    return (!filterState) ? list : list.filter { data in
        (newStartDate ... endDate).contains(data.date)
    }
}

func getFilterData(list: [MedicalRecord], startDate: Date, filterState: Bool) -> [MedicalRecord] {
    
    let newStartDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: startDate)!
    
    let endDate = newStartDate.addingTimeInterval(86400)
    
    return (!filterState) ? list : list.filter { data in
        (newStartDate ... endDate).contains(data.date)
    }
}

func setDate(date: String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = "ddMMyyyy HH:mm"
    let newDate = formatter.date(from: date)
    return newDate ?? Date()
}
