import FirebaseAuth
import Foundation

/// ViewModel for managing the main view's authentication state.
class MainViewViewModel: ObservableObject {
    @Published var currentUserId: String = ""  // Stores the user ID of the currently logged-in user.
    
    // Holds a handle to the Firebase authentication state listener.
    private var handler: AuthStateDidChangeListenerHandle?
    
    /// Initializes the ViewModel and sets up an authentication state listener.
    init() {
        // Sets up the authentication state listener to update `currentUserId` whenever the authentication state changes.
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            // Ensures that the user ID update is performed on the main thread to comply with SwiftUI's requirements for UI updates.
            DispatchQueue.main.async {
                self?.currentUserId = user?.uid ?? ""  // Sets currentUserId to the user's UID or an empty string if no user is logged in.
            }
        }
    }
    
    /// Returns true if a user is currently signed into the application.
    public var isSignedIn: Bool {
        return Auth.auth().currentUser != nil  // Checks if there is a current user signed in.
    }
    
    /// Deinitializes the ViewModel and removes the authentication state listener.
    deinit {
        if let handler = handler {
            Auth.auth().removeStateDidChangeListener(handler)  // Removes the listener when the ViewModel is deallocated.
        }
    }
}
