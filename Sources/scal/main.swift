import Foundation
import EventKit

import SwiftCLI

let app = CLI(name: "scal", version: "1.0.0", description: "macOS calendar and reminder reader", commands: [
    CalendarGroup(),
    ReminderGroup()
])
exit(app.go())
