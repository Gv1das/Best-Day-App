import Foundation

/// Extension to `Encodable` to provide additional functionality for serialization.
extension Encodable {
    /// Converts the object to a dictionary representation.
    ///
    /// Uses `JSONEncoder` to encode the object into JSON data, and then uses `JSONSerialization`
    /// to convert this JSON data into a dictionary if possible.
    ///
    /// - Returns: A dictionary representation of the object, or an empty dictionary if encoding fails.
    func asDictionary() -> [String: Any] {
        // Attempt to encode the object into JSON data.
        guard let data = try? JSONEncoder().encode(self) else {
            // If encoding fails, return an empty dictionary.
            return [:]
        }
        
        // Attempt to convert the JSON data into a dictionary.
        do {
            // Use `JSONSerialization` to try to convert the data to JSON, expecting a dictionary format.
            let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            // If successful, return the JSON dictionary; otherwise, return an empty dictionary.
            return json ?? [:]
        } catch {
            // If conversion fails (e.g., due to invalid JSON), return an empty dictionary.
            return [:]
        }
    }
}
