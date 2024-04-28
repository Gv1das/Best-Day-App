import SwiftUI
import FirebaseFirestoreSwift

/// ToDoListView provides a list of ToDo items and options to interact with them, including a celebrity routine list and a calendar view.
struct ToDoListView: View {
    @ObservedObject var viewModel: ToDoListViewViewModel  // ViewModel for ToDo list management
    @ObservedObject var celebrityViewModel: CelebrityRoutineListViewModel  // ViewModel for managing celebrity routines

    @State private var showingCelebrityRoutineList = false  // State to manage the visibility of the celebrity routines list
    @State private var showingCalendar = false  // State to toggle calendar view
    @State private var selectedDate: Date? = Date()  // State to hold the selected date from the calendar

    var body: some View {
        NavigationView {
            ZStack {
                List(filteredItems, id: \.id) { item in
                    ToDoListItemView(item: item)
                        .swipeActions {
                            Button("Delete") {
                                viewModel.deleteItem(item: item)
                            }
                            .tint(.red)  // Red color for delete action
                        }
                }
                .navigationTitle("To Do List")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            showingCalendar.toggle()
                        }) {
                            Image(systemName: "calendar")  // Calendar icon to open date picker
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Buy") {
                            showingCelebrityRoutineList = true
                            showingCalendar = false  // Hide calendar when showing celebrity routines
                        }
                        
                        Button(action: {
                            viewModel.showingNewItemView = true  // Show new item view
                            showingCalendar = false  // Hide calendar when adding new item
                        }) {
                            Image(systemName: "plus")  // Plus icon for adding new items
                        }
                    }
                }
                .sheet(isPresented: $viewModel.showingNewItemView) {
                    NewItemView(newItemPresented: $viewModel.showingNewItemView)
                }
                .sheet(isPresented: $showingCelebrityRoutineList) {
                    CelebrityRoutineListView(viewModel: celebrityViewModel, toDoListViewModel: viewModel)
                }

                if showingCalendar {
                    calendarOverlayView()  // Display calendar overlay if toggled
                }
            }
        }
    }

    /// Filters items based on the selected date from the calendar.
    var filteredItems: [ToDoListItem] {
        guard let selectedDate = selectedDate else { return viewModel.toDoItems }
        return viewModel.toDoItems.filter { item in
            let itemDate = Date(timeIntervalSince1970: item.dueDate)
            return Calendar.current.isDate(itemDate, inSameDayAs: selectedDate)
        }
    }

    /// Displays a calendar overlay for date selection.
    @ViewBuilder
    private func calendarOverlayView() -> some View {
        // Glassy overlay background
        VisualEffectView(effect: UIBlurEffect(style: .dark))
            .edgesIgnoringSafeArea(.all)

        // Container for the DatePicker and the Done button
        VStack {
            Spacer()

            DatePicker(
                "Select a date",
                selection: Binding<Date>(
                    get: { self.selectedDate ?? Date() },
                    set: { self.selectedDate = $0 }
                ),
                displayedComponents: .date
            )
            .datePickerStyle(GraphicalDatePickerStyle())
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(UIColor.systemBackground).opacity(0.6)))
            .padding()

            Button("Done") {
                showingCalendar = false  // Hide calendar when done
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.blue))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}

/// Preview provider for SwiftUI previews
struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView(viewModel: ToDoListViewViewModel(userId: "exampleId"), celebrityViewModel: CelebrityRoutineListViewModel(userId: "exampleId"))
    }
}
