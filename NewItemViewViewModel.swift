import FirebaseAuth
import FirebaseFirestore
import Foundation

/// ViewModel for managing the creation and saving of new todo items.
class NewItemViewViewModel: ObservableObject {
    @Published var title = ""  // Title for the new todo item.
    @Published var dueDate = Date()  // Due date for the new todo item.
    @Published var showAlert = false  // Controls the visibility of an alert, typically used when saving fails.

    /// Initializes the ViewModel.
    init() {}

    /// Saves a new todo item to Firestore if the current user is authenticated and the item is valid.
    func save() {
        // Check if the item can be saved based on the validation rules.
        guard canSave else {
            showAlert = true  // Show an alert if the item cannot be saved.
            return
        }

        // Attempt to retrieve the current user's UID.
        guard let uId = Auth.auth().currentUser?.uid else {
            showAlert = true  // Show an alert if there is no logged-in user.
            return
        }

        // Create a new todo item model.
        let newId = UUID().uuidString  // Generate a unique identifier for the new item.
        let newItem = ToDoListItem(
            id: newId,
            title: title,
            dueDate: dueDate.timeIntervalSince1970,  // Convert Date to TimeInterval for storage.
            createdTime: Date().timeIntervalSince1970,  // Record the creation time.
            isDone: false  // Initialize as not done.
        )
        
        // Save the new todo item to Firestore under the current user's 'todos' collection.
        let db = Firestore.firestore()
        db.collection("users").document(uId).collection("todos").document(newId).setData(newItem.asDictionary())
    }

    /// Determines whether the new todo item can be saved.
    var canSave: Bool {
        // Ensure the title is not just whitespace.
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            showAlert = true
            return false
        }
        
        // Ensure the due date is not set in the past (allowing 1 day of leeway).
        guard dueDate >= Date().addingTimeInterval(-86400) else {
            showAlert = true
            return false
        }
        
        return true
    }
}
