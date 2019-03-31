import Foundation
import EventKit

import SwiftCLI

class NextReminderCommand: Command {
    let name = "next"
    
    let numParam = Parameter()
    
    func readReminders(store: EKEventStore) -> Void {
        let predicate = store.predicateForIncompleteReminders(withDueDateStarting: nil, ending: nil, calendars: nil)

        store.fetchReminders(matching: predicate, completion: {r in
            if let reminders = r {
                if let num = Int(self.numParam.value) {
                    if num <= 0 {
                        if let reminder = reminders.first {
                            print("\(reminder.title!)")
                        }
                    } else if reminders.count >= num {
                        let reminder = reminders[num - 1]
                        print("\(reminder.title!)")
                    }
                }
            }
        })
    }
    
    func execute() throws {
        switch EKEventStore.authorizationStatus(for: .reminder) {
        case .authorized:
            self.readReminders(store: EKEventStore())
        case .notDetermined:
            let store = EKEventStore()
            store.requestAccess(to: .reminder, completion: {granted, _ in
                if granted {
                    self.readReminders(store: store)
                } else {
                    print("Please grant access to reminder.")
                }
            })
        case .restricted, .denied:
            fallthrough
        default:
            print("Please grant access to reminder.")
        }
    }
}

class ReminderGroup: CommandGroup {
    let name = "reminder"
    let shortDescription = "Read reminder events"
    
    let children: [Routable] = [NextReminderCommand()]
}
