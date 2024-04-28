import SwiftUI

/// ProfileView displays the user's profile information within a navigation view.
struct ProfileView: View {
    @StateObject var viewModel = ProfileViewViewModel() // ViewModel for managing profile data.
    
    var body: some View {
        NavigationView {
            VStack {
                // Conditionally display user profile or a loading indicator.
                if let user = viewModel.user {
                    profile(user: user)  // Call to the profile builder function if user data is available.
                } else {
                    Text("Loading Profile...")  // Show loading text if user data is not yet available.
                }
            }
            .navigationTitle("Profile")  // Set the navigation bar title.
        }
        .onAppear {
            viewModel.fetchUser()  // Fetch user data when the view appears.
        }
    }

    /// Constructs the user profile view.
    @ViewBuilder
    func profile(user: User) -> some View {
        Image(systemName: "person.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(Color.blue)  // Set the image color to blue.
            .frame(width: 125, height: 125)  // Set image dimensions.
            .padding()
        
        // Display user information: name, email, and membership start date.
        VStack(alignment: .leading) {
            HStack {
                Text("Name: ")
                    .bold()
                
                Text(user.name)  // Display user's name.
            }
            .padding()
            HStack {
                Text("Email: ")
                    .bold()
                
                Text(user.email)  // Display user's email.
            }
            .padding()
            HStack {
                Text("Member Since: ")
                    .bold()
                
                // Format and display the membership start date.
                Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
            }
            .padding()
        }
        .padding()
        
        // Logout button.
        Button("Log Out") {
            viewModel.logOut()  // Call logout function from ViewModel.
        }
        .tint(.red)  // Set the button color to red.
        .padding()
        
        Spacer()  // Push all content to the top.
    }
}

// SwiftUI Preview for development and testing.
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
