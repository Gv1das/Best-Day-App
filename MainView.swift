import SwiftUI

/// MainView is the root view of the application that handles user authentication and routes to the appropriate view.
struct MainView: View {
    @StateObject var viewModel = MainViewViewModel() // ViewModel for handling the main view logic such as authentication.
    @StateObject var toDoListViewModel = ToDoListViewViewModel(userId: "1fOvZLz1hiTSpjwZzXyUPH7a1Bf1") // ViewModel for managing ToDo list related data.
    @StateObject var celebrityViewModel = CelebrityRoutineListViewModel(userId: "1fOvZLz1hiTSpjwZzXyUPH7a1Bf1")  // ViewModel for managing celebrity routine data.

    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            // If user is signed in and the user ID is not empty, show the account view.
            AccountView(viewModel: viewModel, toDoListViewModel: toDoListViewModel, celebrityViewModel: celebrityViewModel)
        } else {
            // If not signed in, show the login view.
            LogInView()
        }
    }
}

/// AccountView is a container for other views managing different parts of the application post-login.
struct AccountView: View {
    @ObservedObject var viewModel: MainViewViewModel
    @ObservedObject var toDoListViewModel: ToDoListViewViewModel
    @ObservedObject var celebrityViewModel: CelebrityRoutineListViewModel

    var body: some View {
        TabView {
            // Tab for the To-Do List view.
            ToDoListView(viewModel: toDoListViewModel, celebrityViewModel: celebrityViewModel)
                .tabItem { Label("Home", systemImage: "house") }
            
            // Tab for the Profile view.
            ProfileView()
                .tabItem { Label("Profile", systemImage: "person.circle") }
            
        }
    }
}

/// MainView_Previews allows for a preview of MainView in Xcode's canvas or during UI tests.
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
