import Foundation

/// Represents a purchase of a celebrity routine by a user, conformant to Codable for easy serialization.
struct CelebrityRoutinePurchase: Codable {
    let userId: String  // The unique identifier for the user who made the purchase.
    let routineId: String  // The unique identifier of the purchased celebrity routine.
    let purchaseDate: TimeInterval  // The date and time when the purchase was made, stored as a TimeInterval since epoch.

}
