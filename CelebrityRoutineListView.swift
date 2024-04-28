import SwiftUI

/// CelebrityRoutineListView presents a list of celebrity routines that users can browse and potentially purchase.
struct CelebrityRoutineListView: View {
    @ObservedObject var viewModel: CelebrityRoutineListViewModel  // ViewModel managing the data and interactions for celebrity routines.
    @ObservedObject var toDoListViewModel: ToDoListViewViewModel  // ViewModel for managing the ToDo list which integrates with routines.

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    // Check if the list of routines is empty and display a message if so.
                    if viewModel.celebrityRoutines.isEmpty {
                        Text("No routines available")
                            .padding()
                            .foregroundColor(.secondary)  // Use secondary color for less emphasis on the message.
                    } else {
                        // List each celebrity routine using a ForEach loop.
                        ForEach(viewModel.celebrityRoutines, id: \.id) { celebrityRoutine in
                            // NavigationLink to detail view for each routine.
                            NavigationLink(destination: CelebrityRoutineDetailView(
                                routine: celebrityRoutine,
                                isPurchased: viewModel.isPurchased(celebrityRoutine),  // Determine if the routine has been purchased.
                                onBuyTap: { viewModel.purchaseRoutine(celebrityRoutine) },  // Handle purchase action.
                                toDoListViewModel: toDoListViewModel
                            )) {
                                // Display each routine using a custom card view.
                                CelebrityCardView(
                                    routine: celebrityRoutine,
                                    isPurchased: viewModel.isPurchased(celebrityRoutine)  // Indicate purchase status.
                                )
                            }
                        }
                    }
                }
                .padding()  // Padding around the stack for layout purposes.
            }
            .navigationTitle("Buy Celebrity Routines")  // Set the navigation bar title.
            .onAppear {
                viewModel.fetchCelebrityRoutines()  // Fetch celebrity routines when the view appears.
                viewModel.fetchUserPurchases()  // Fetch user purchases to update purchase status.
            }
        }
    }
}
