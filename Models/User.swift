import Foundation

/// Represents a user in the system, conformant to Codable for easy serialization and deserialization.
struct User: Codable {
    let id: String            // Unique identifier for the user, typically used as a key in database storage.
    let name: String          // User's full name.
    let email: String         // User's email address, which can be used for login or communication.
    let joined: TimeInterval  // The time at which the user joined, represented as a TimeInterval since epoch.

    /// Initializer for creating a new User object.
    /// - Parameters:
    ///   - id: The unique identifier for the user.
    ///   - name: The full name of the user.
    ///   - email: The email address of the user.
    ///   - joined: The time at which the user joined the application.
    init(id: String, name: String, email: String, joined: TimeInterval) {
        self.id = id
        self.name = name
        self.email = email
        self.joined = joined
    }
}
