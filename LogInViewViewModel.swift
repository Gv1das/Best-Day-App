import FirebaseAuth
import Foundation

/// ViewModel managing the user login process for the application.
class LogInViewViewModel: ObservableObject {
    @Published var email = ""  // User's email input.
    @Published var password = ""  // User's password input.
    @Published var errorMessage = ""  // Message to display if there's an error during login.
    
    /// Initializes the view model.
    init() {}

    /// Attempts to log in the user using Firebase Authentication.
    func login() {
        // Validates the input fields before attempting to log in.
        guard validate() else {
            return  // Stops the login process if validation fails.
        }
        
        // Attempts to log in with Firebase Authentication.
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            // Checks if there is an error during the login process.
            if let error = error {
                // Updates the errorMessage with details from the error.
                self?.errorMessage = "Login failed: \(error.localizedDescription)"
            } else {
                // Clear the errorMessage if the login is successful.
                self?.errorMessage = ""
            }
        }
    }
    
    /// Validates the email and password input fields.
    private func validate() -> Bool {
        errorMessage = ""  // Resets the errorMessage before validation starts.

        // Checks if email and password fields are not empty.
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields."
            return false
        }
        
        // Validates the email format.
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter a valid email."
            return false
        }
        
        return true  // Returns true if all validations pass.
    }
}
