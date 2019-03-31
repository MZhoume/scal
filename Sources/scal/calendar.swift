import Foundation
import EventKit

import SwiftCLI

class NextEventCommand: Command {
    let name = "next"
    
    let numParam = Parameter()
    
    func readEventsNow(store: EKEventStore) -> Void {
        let now = Date()
        let later = now.addingTimeInterval(60 * 60 * 24)
        let predicate = store.predicateForEvents(withStart: now, end: later, calendars: nil)
        
        let events = store.events(matching: predicate).filter({!$0.isAllDay && $0.startDate > now})
        if let num = Int(numParam.value) {
            if num <= 0 {
                if let event = events.first {
                    if Calendar.current.isDateInToday(event.startDate) {
                        print("(\(formatTime(date: event.startDate!))) \(event.title!)")
                    } else {
                        print("(\(formatDate(date: event.startDate)) \(formatTime(date: event.startDate!))) \(event.title!)")
                    }
                }
            } else if events.count >= num {
                let event = events[num - 1]
                print("(\(formatDate(date: event.startDate)) \(formatTime(date: event.startDate!))) \(event.title!)")
            }
        }
    }
    
    func execute() throws {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .authorized:
            self.readEventsNow(store: EKEventStore())
        case .notDetermined:
            let store = EKEventStore()
            store.requestAccess(to: .event, completion: {granted, _ in
                if granted {
                    self.readEventsNow(store: store)
                } else {
                    print("Please grant access to calendar.")
                }
            })
        case .restricted, .denied:
            fallthrough
        default:
            print("Please grant access to calendar.")
        }
    }
}

class CalendarGroup: CommandGroup {
    let name = "calendar"
    let shortDescription = "Read calendar events"
    
    let children: [Routable] = [NextEventCommand()]
}
