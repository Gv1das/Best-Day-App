import FirebaseFirestore
import FirebaseAuth
import Foundation

/// ViewModel managing user registration in the application.
class RegisterViewViewModel: ObservableObject {
    @Published var name = ""  // User's name input.
    @Published var email = ""  // User's email input.
    @Published var password = ""  // User's password input.

    /// Initializes the view model.
    init() {}

    /// Attempts to register a new user using Firebase Authentication.
    func register() {
        guard validate() else {
            return  // Stops the registration process if validation fails.
        }

        // Creates a new user in Firebase Authentication.
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let userId = result?.user.uid else {
                // Handle the case where user registration fails.
                return
            }

            // If registration is successful, create a user record in Firestore.
            self?.insertUserRecord(id: userId)
        }
    }

    /// Inserts a new user record into Firestore after successful authentication.
    private func insertUserRecord(id: String) {
        let newUser = User(id: id,
                           name: name,
                           email: email,
                           joined: Date().timeIntervalSince1970)  // Sets the join date to the current time.

        let db = Firestore.firestore()
        db.collection("users").document(id).setData(newUser.asDictionary())
    }

    /// Validates the input fields for creating a new user.
    private func validate() -> Bool {
        // Checks that none of the fields are empty and trims whitespace.
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            return false
        }

        // Ensures the email contains necessary characters.
        guard email.contains("@") && email.contains(".") else {
            return false
        }

        // Ensures the password is at least 6 characters long.
        guard password.count >= 6 else {
            return false
        }

        return true
    }
}
