import FirebaseAuth
import FirebaseFirestore
import Foundation

/// ViewModel for managing the state and interactions for a single to-do list item.
class ToDoListItemViewViewModel: ObservableObject {
    /// Initializes the ViewModel.
    init() {}

    /// Toggles the completion state of a to-do list item and updates its record in Firestore.
    func toggleIsDone(item: ToDoListItem) {
        var itemCopy = item  // Creates a mutable copy of the item to modify.
        itemCopy.setDone(!item.isDone)  // Toggles the 'isDone' state of the item.

        // Retrieves the current user's UID. If no user is signed in, the function exits.
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }

        // Firestore database reference.
        let db = Firestore.firestore()

        // Updates the item in Firestore within the user's 'todos' collection.
        db.collection("users")
            .document(uid)
            .collection("todos")
            .document(itemCopy.id)
            .setData(itemCopy.asDictionary())  // Updates the document with the new state of the item.
    }
}
