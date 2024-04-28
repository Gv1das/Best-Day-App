import SwiftUI

/// TaskView displays individual tasks within a celebrity's routine with expandable details.
struct TaskView: View {
    let task: RoutineTask  // Holds the task data including time, name, and description.
    @State private var isExpanded: Bool = false  // Tracks whether the task description is expanded.

    var body: some View {
        VStack {
            HStack {
                // Time label with visual effect background.
                Text(task.time.formattedTimeString())
                    .font(.headline)  // Use headline font for emphasis.
                    .frame(width: 80)  // Fixed width for uniform styling.
                    .padding(.vertical, 10)  // Vertical padding for better touch target and visual separation.
                    .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterial)))  // Apply a blur effect for a modern look.
                    .clipShape(RoundedRectangle(cornerRadius: 8))  // Rounded corners for aesthetics.

                // Task name and expandable description.
                VStack(alignment: .leading, spacing: 5) {
                    Text(task.taskName)
                        .font(.headline)  // Bold and slightly larger font for the task name.
                        .foregroundColor(.primary)  // Use the primary color for high visibility.

                    if isExpanded {
                        Text(task.description)
                            .font(.subheadline)  // Smaller font for the detailed description.
                            .foregroundColor(.secondary)  // Secondary color for less emphasis.
                            .transition(.opacity)  // Fade transition for expanding/collapsing.
                    }
                }
                
                Spacer()  // Pushes content to the left and button to the right.

                // Expand/Collapse button.
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()  // Animate the expansion/collapse of the description.
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")  // Chevron indicates expansion state.
                        .foregroundColor(.secondary)  // Subdued color to not distract from main content.
                }
            }
            .contentShape(Rectangle())  // Make the whole row tappable.
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()  // Allow the entire row to toggle the expansion.
                }
            }
        }
        .padding(.horizontal)  // Horizontal padding within the card.
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemMaterial)))  // Background visual effect for the whole row.
        .clipShape(RoundedRectangle(cornerRadius: 15))  // Rounded corners for the outer container.
        .padding(.horizontal)  // Additional padding to handle the visual overflow from rounded corners.
        .padding(.vertical, 5)  // Vertical padding for spacing between task entries.
    }
}

// Extension to format TimeInterval (stored as UNIX timestamp) to a readable time string.
extension TimeInterval {
    func formattedTimeString() -> String {
        let date = Date(timeIntervalSince1970: self)
        return date.formatted(date: .omitted, time: .shortened) // Converts timestamp to a short time format, omitting the date.
    }
}

/// CelebrityRoutineDetailView is the main detail view for displaying a celebrity routine.
struct CelebrityRoutineDetailView: View {
    let routine: CelebrityRoutine  // Holds the celebrity routine data.
    let isPurchased: Bool  // Indicates if the routine has been purchased.
    var onBuyTap: () -> Void  // Closure to handle the purchase action.
    @ObservedObject var toDoListViewModel: ToDoListViewViewModel  // ViewModel for managing the ToDo list.

    @State private var showingAddToCalendarSheet = false  // Tracks visibility of the calendar addition sheet.
    @State private var selectedDate = Date()  // Tracks the date selected by the user for adding tasks.

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    // List each task in the routine using TaskView.
                    ForEach(routine.tasks, id: \.taskName) { task in
                        TaskView(task: task)
                    }
                }
                .padding()

                // Display 'Add to My Calendar' button if the routine is purchased.
                if isPurchased {
                    Spacer()
                    Button("Add to My Calendar") {
                        showingAddToCalendarSheet = true  // Show the calendar sheet when tapped.
                    }
                    .padding()
                }
            }
            .navigationBarTitle(routine.celebrityName, displayMode: .large)

            // Show purchase overlay if not purchased.
            if !isPurchased {
                VisualBlurEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial), cornerRadius: 20)
                    .padding(.horizontal)
                    .padding(.top, 20) // Excludes the header from the blur effect.
                    .edgesIgnoringSafeArea(.bottom)

                GlassButton(text: "Tap to Buy", action: onBuyTap)
            }
        }
        .navigationBarTitle(routine.celebrityName, displayMode: .inline)
        .sheet(isPresented: $showingAddToCalendarSheet) {
            // Display a sheet to add routine to calendar.
            CalendarAddSheet(selectedDate: $selectedDate) {
                toDoListViewModel.addRoutineToToDoList(routine: routine, on: selectedDate)
                showingAddToCalendarSheet = false  // Dismiss the sheet after adding to calendar.
            }
        }
    }

    @ViewBuilder
    private var purchaseOverlay: some View {
        if !isPurchased {
            GlassButton(text: "Tap to Buy", action: onBuyTap)
                .padding()
                .padding(.top, UIScreen.main.bounds.height / 3) // Position the button in the middle third of the screen for visibility.
        }
    }
}
import SwiftUI

/// VisualBlurEffectView wraps a UIVisualEffectView from UIKit to be used in SwiftUI.
struct VisualBlurEffectView: UIViewRepresentable {
    var effect: UIVisualEffect  // Defines the visual effect to be applied.
    var cornerRadius: CGFloat  // Radius for rounding the corners of the visual effect view.

    // Creates and configures the UIVisualEffectView when added to a SwiftUI view hierarchy.
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: effect)
        view.clipsToBounds = true  // Ensures that subviews are clipped to the bounds of the view.
        view.layer.cornerRadius = cornerRadius  // Applies the corner radius to the layer of the view.
        return view
    }
    
    // Updates the existing UIVisualEffectView when view's properties change.
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = effect  // Updates the visual effect if it has changed.
    }
}

/// GlassButton is a stylized button component that uses a visual blur effect.
struct GlassButton: View {
    var text: String  // Text to be displayed on the button.
    var action: () -> Void  // Action to perform when the button is tapped.
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 24, weight: .bold))  // Larger font size for readability and emphasis.
                .foregroundColor(.white)  // Text color.
                .padding(.vertical, 20)  // Vertical padding for increased tap area and aesthetic spacing.
                .padding(.horizontal, 50)  // Horizontal padding to extend the content area.
                .background(
                    VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
                        .cornerRadius(20)  // Applies a corner radius to the background blur effect.
                        .overlay(
                            Color.blue.opacity(0.8)  // Applies a semi-transparent blue overlay.
                        )
                )
                .cornerRadius(20)  // Ensures the content and background have rounded corners.
        }
        .frame(height: 60)  // Sets a fixed height for the button.
        .shadow(radius: 10)  // Adds a shadow for a subtle 3D effect.
    }
}

/// CalendarAddSheet presents a UI for selecting a date and adding it to a calendar.
struct CalendarAddSheet: View {
    @Binding var selectedDate: Date  // Binding to a selected date shared with other views.
    var onAddAction: () -> Void  // Closure to execute when adding the date to the calendar.

    var body: some View {
        NavigationView {
            VStack {
                // DatePicker to allow users to select a date.
                DatePicker(
                    "Select Date",
                    selection: $selectedDate,  // Bind to the selected date.
                    displayedComponents: .date  // Only show date picker components.
                )
                .datePickerStyle(GraphicalDatePickerStyle())  // Use the graphical style for better UX.
                .padding()

                // Button to confirm the addition of the selected date to the calendar.
                Button("Add to My Calendar", action: onAddAction)
                    .buttonStyle(FilledButtonStyle())  // Apply the custom button style defined below.

                Spacer()  // Pushes all content to the top of the screen.
            }
            .navigationTitle("Select Date")  // Title for the navigation bar.
            .navigationBarItems(trailing: Button("Done") {
                onAddAction()  // Execute the add action when 'Done' is tapped.
            })
        }
    }
}

/// FilledButtonStyle defines a consistent and visually appealing style for buttons.
struct FilledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()  // Padding inside the button for better touch targets.
            .background(Color.blue)  // Blue background for a distinctive look.
            .foregroundColor(.white)  // White text for high contrast.
            .clipShape(RoundedRectangle(cornerRadius: 10))  // Rounded corners for a modern appearance.
            .scaleEffect(configuration.isPressed ? 0.95 : 1)  // Slightly shrink the button when pressed.
    }
}
