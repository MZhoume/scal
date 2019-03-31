import Foundation

func formatTime(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    
    return formatter.string(from: date)
}

func formatDate(date: Date) -> String {
    if Calendar.current.isDateInToday(date) {
        return "Today"
    } else if Calendar.current.isDateInTomorrow(date) {
        return "Tomorrow"
    }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    
    return formatter.string(from: date)
}
