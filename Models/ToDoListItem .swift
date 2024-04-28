import Foundation

/// Represents a single item in a to-do list, conformant to Codable for easy serialization and deserialization.
struct ToDoListItem: Codable, Identifiable {
    let id: String             // Unique identifier for each to-do item.
    let title: String          // Title or description of the to-do item.
    let dueDate: TimeInterval  // Scheduled time for the to-do item as a TimeInterval since the epoch.
    let createdTime: TimeInterval // Creation time of the to-do item as a TimeInterval since the epoch.
    var isDone: Bool           // Status flag indicating whether the to-do item has been completed.

    /// Mutates the completion state of the to-do item.
    /// - Parameter state: A boolean value indicating the new completion state.
    mutating func setDone(_ state: Bool) {
        isDone = state
    }
}

/// Extension to ToDoListItem to provide additional functionality.
extension ToDoListItem {
    /// Converts the to-do item properties into a dictionary format suitable for database operations.
    var dictionary: [String: Any] {
        return [
            "id": id,
            "title": title,
            "dueDate": dueDate,
            "createdTime": createdTime,
            "isDone": isDone
        ]
    }
}
