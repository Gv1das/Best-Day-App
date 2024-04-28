import SwiftUI

/// RegisterView provides a user interface for new users to create an account in the ToDoList app.
struct RegisterView: View {
    @StateObject var viewModel = RegisterViewViewModel()  // ViewModel to manage registration logic.
    
    var body: some View {
        VStack {
            // Header: A stylized header view for the registration screen.
            HeaderView(title: "Register",
                       subtitle: "Start organizing todos",
                       angle: -15,  // Negative angle for visual differentiation from other headers.
                       background: .orange)  // Orange background color for a vibrant look.
            
            // Form: A form containing input fields for user registration.
            Form {
                // Full name input field with standard text field styling.
                TextField("Full Name", text: $viewModel.name)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()  // Disable autocorrection.
                
                // Email address input field styled similarly, with autocapitalization turned off.
                TextField("Email Address", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocapitalization(.none)  // Ensure email address is entered in lowercase.
                    .autocorrectionDisabled()  // Disable autocorrection.
                
                // Password input field using a secure field to hide input text.
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                // Button to submit the form and attempt to create a new account.
                TLButton(
                    title: "Create Account",
                    background: .green  // Green color to signify go-ahead or creation.
                ) {
                    viewModel.register()  // Call the register function in the ViewModel.
                }
                .padding()  // Padding around the button for aesthetics.
            }
            .offset(y: -50)  // Shift the form up slightly to utilize space better.
            
            Spacer()  // Pushes all content up and fills remaining space.
        }
    }
}

// SwiftUI Preview for development and testing.
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
