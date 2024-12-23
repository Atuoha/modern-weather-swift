import Foundation



func getCurrentDateFormatted() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEEE, d MMM, yyyy"
    dateFormatter.locale = Locale(identifier: "en_GB")
    let currentDate = Date()
    let formattedDate = dateFormatter.string(from: currentDate)
    let day = Calendar.current.component(.day, from: currentDate)
    let dayWithOrdinal = "\(day)\(ordinalSuffix(for: day))"
    
    let formattedDateWithOrdinal = formattedDate.replacingOccurrences(of: "\(day)", with: dayWithOrdinal)
    
    return formattedDateWithOrdinal
}

 func ordinalSuffix(for day: Int) -> String {
    switch day {
    case 11...13:
        return "th"
    default:
        switch day % 10 {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
}


