import SwiftUI

/// LogInView provides a user interface for logging into the application, including error handling and navigation to registration.
struct LogInView : View {
    
    @StateObject var viewModel = LogInViewViewModel()  // ViewModel for handling log in logic.
    
    var body: some View {
        NavigationView {
            VStack {
                // Header: Displays the title and subtitle of the app with a dynamic visual style.
                HeaderView(title: "To Do List",
                           subtitle: "Get Things Done",
                           angle: 15,  // Stylistic angle for the header background.
                           background: .pink)  // Pink background for visual distinction.
                
                // Log In Form: Includes fields for email and password entry and error messages.
                Form {
                    // Display error message if any.
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                    }
                    
                    // Email address input field.
                    TextField("Email Address", text: $viewModel.email)
                        .textFieldStyle(DefaultTextFieldStyle())
                        .autocapitalization(.none)  // Disable capitalization for email input.
                    
                    // Password input field using SecureField for hidden text.
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(DefaultTextFieldStyle())
                    
                    // Login button with action handler.
                    TLButton(
                        title: "Log In",
                        background: .blue  // Blue button for the primary action.
                    ) {
                        viewModel.login()  // Trigger login function on ViewModel.
                    }
                    .padding()
                }
                .offset(y: -50)  // Adjust form position for better visual layout.
                
                // Link to registration view for new users.
                VStack {
                    Text("New around here?")
                    NavigationLink("Create An Account", destination: RegisterView())
                    .padding(.bottom, 50)
                }
                
                Spacer()  // Push content upwards.
            }
        }
    }
}

// SwiftUI Preview for development and testing.
struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
