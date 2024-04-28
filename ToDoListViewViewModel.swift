import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift  // Needed for `setData(from:)` and `data(as:)`

/// Manages the state and interactions for the ToDo list items.
class ToDoListViewViewModel: ObservableObject {
    @Published var toDoItems: [ToDoListItem] = []  // Array to store the todo items.
    @Published var showingNewItemView = false  // Controls the presentation of the modal view for adding new items.
    private var db = Firestore.firestore()  // Firestore database reference.
    private var userId: String  // User identifier for database queries.
    
    /// Initializes the view model for a specific user.
    /// - Parameter userId: the identifier for the user
    init(userId: String) {
        self.userId = userId
        fetchToDoItems()  // Fetch todo items from Firestore on initialization.
    }
    
    /// Fetches todo items from Firestore and observes for any changes.
    func fetchToDoItems() {
        db.collection("users").document(userId).collection("todos")
            .order(by: "dueDate")  // Orders the fetched todo items by due date.
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents found")
                    return
                }
                
                self?.toDoItems = documents.compactMap { queryDocumentSnapshot -> ToDoListItem? in
                    try? queryDocumentSnapshot.data(as: ToDoListItem.self)  // Maps Firestore documents to ToDoListItem objects.
                }
            }
    }
    
    /// Deletes a specific todo item from Firestore.
    /// - Parameter item: the todo item to delete
    func deleteItem(item: ToDoListItem) {
        db.collection("users").document(userId).collection("todos").document(item.id).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document successfully deleted")
            }
        }
    }
    
    /// Adds tasks from a celebrity routine to the todo list on a specified date.
    /// - Parameters:
    ///   - routine: the celebrity routine containing tasks to add
    ///   - date: the date on which to schedule the tasks
    func addRoutineToToDoList(routine: CelebrityRoutine, on date: Date) {
        for task in routine.tasks {
            var components = Calendar.current.dateComponents([.year, .month, .day], from: date)
            let taskTime = Date(timeIntervalSince1970: task.time)  // Converts time interval to Date object.
            let timeComponents = Calendar.current.dateComponents([.hour, .minute], from: taskTime)
            components.hour = timeComponents.hour
            components.minute = timeComponents.minute

            if let dueDate = Calendar.current.date(from: components) {
                let newToDoItem = ToDoListItem(
                    id: UUID().uuidString,
                    title: task.taskName,
                    dueDate: dueDate.timeIntervalSince1970,  // Converts Date back to TimeInterval for storage.
                    createdTime: Date().timeIntervalSince1970,
                    isDone: false
                )
                saveToDoItem(item: newToDoItem)  // Saves the new todo item to Firestore.
            }
        }
    }

    /// Saves a todo item to Firestore.
    /// - Parameter item: the todo item to save
    private func saveToDoItem(item: ToDoListItem) {
        do {
            try db.collection("users").document(userId).collection("todos").document(item.id).setData(from: item)
        } catch let error {
            print("Error writing ToDo item to Firestore: \(error.localizedDescription)")
        }
    }
}
