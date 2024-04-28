import FirebaseAuth
import FirebaseFirestore
import Foundation

/// ViewModel for managing user profile data and interactions in the profile view.
class ProfileViewViewModel: ObservableObject {
    /// Initializes the ViewModel.
    init() {}

    @Published var user: User? = nil  // Holds the current user's profile data.

    /// Fetches the current user's data from Firestore.
    func fetchUser() {
        // Retrieves the UID of the currently logged-in user. Exits if no user is found.
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

        // Firestore database reference.
        let db = Firestore.firestore()

        // Retrieves the user document from Firestore.
        db.collection("users").document(userId).getDocument { [weak self] snapshot, error in
            // Checks for errors and that data exists.
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            // Updates the `user` published property on the main thread to ensure UI updates.
            DispatchQueue.main.async {
                self?.user = User(
                    id: data["id"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    joined: data["joined"] as? TimeInterval ?? 0
                )
            }
        }
    }
    
    /// Logs out the current user from Firebase Authentication.
    func logOut() {
        do {
            try Auth.auth().signOut()  // Attempts to sign out the user.
        } catch {
            // If there's an error signing out, prints the error to the console.
            print("Error signing out: \(error)")
        }
    }
}
