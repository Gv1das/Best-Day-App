import FirebaseCore  // Import FirebaseCore to use Firebase services.
import SwiftUI       // Import SwiftUI framework for UI elements.

/// Main structure for the SwiftUI application.
@main  // Marks this struct as the entry point of the SwiftUI application.
struct ToDoListApp: App {
    /// Initializes the ToDoListApp.
    init() {
        FirebaseApp.configure()  // Configures Firebase when the app is launched.
    }
    
    /// Defines the scene (or window) content of the app.
    var body: some Scene {
        WindowGroup {
            MainView()  // The root view that the app displays when it starts.
        }
    }
}
