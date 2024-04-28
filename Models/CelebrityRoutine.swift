import Foundation

/// Represents a celebrity's routine, including tasks and relevant metadata. Conforms to Codable for easy serialization.
struct CelebrityRoutine: Codable, Identifiable {
    var id: String = ""  // Unique identifier for the routine; default is an empty string.
    var celebrityName: String  // Name of the celebrity associated with the routine.
    var photo: String  // URL or path to the photo representing the celebrity or routine.
    var description: String  // Description of the routine.
    var tasks: [RoutineTask]  // List of tasks that make up the routine.

    // Custom coding keys to match the property names with the keys used in external data sources like Firestore.
    enum CodingKeys: String, CodingKey {
        case celebrityName, photo, description, tasks
    }
}

/// Represents a single task within a celebrity's routine, conforming to Codable for serialization and Equatable for comparisons.
struct RoutineTask: Codable, Equatable {
    var time: TimeInterval  // The time at which the task is scheduled, as a TimeInterval since midnight.
    var taskName: String  // Name of the task.
    var description: String  // Detailed description of the task.
}

/// Extension to the TimeInterval type to provide additional functionality for handling date calculations.
extension TimeInterval {
    /// Converts the TimeInterval into a specific Date, representing when the task is scheduled on that day.
    func asDate(on date: Date) -> Date {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)  // Gets the start of the specified day.
        return startOfDay.addingTimeInterval(self)  // Adds the TimeInterval to the start of the day to get the exact time.
    }
}
