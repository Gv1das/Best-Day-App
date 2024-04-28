import SwiftUI

/// NewItemView provides a form to create a new to-do item, including title and due date.
struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()  // ViewModel to handle the logic for creating new items.
    @Binding var newItemPresented: Bool  // Binding to manage the presentation state of this view.

    var body: some View {
        VStack {
            Text("New Item")
                .font(.system(size: 32))  // Large and bold text as the title of the view.
                .bold()
                .padding(.top, 100)  // Top padding to give some headspace on the screen.

            Form {
                // Title input field
                TextField("Title", text: $viewModel.title)  // Text field for entering the item title.
                    .textFieldStyle(DefaultTextFieldStyle())  // Default style for simplicity.
                
                // Due date picker
                DatePicker("Due Date", selection: $viewModel.dueDate)  // DatePicker to select the due date of the item.
                    .datePickerStyle(GraphicalDatePickerStyle())  // Graphical style for an intuitive interface.

                // Button to add the new item
                TLButton(
                    title: "ADD",
                    background: .pink  // Pink button for visual appeal.
                ) {
                    if viewModel.canSave {  // Check if all conditions for saving are met.
                        viewModel.save()  // Save the new item through the ViewModel.
                        newItemPresented = false  // Dismiss the view on successful save.
                    } else {
                        viewModel.showAlert = true  // Show alert if conditions are not met.
                    }
                }
                .padding()  // Padding around the button for better touch targets.
            }
            .alert(isPresented: $viewModel.showAlert, content: {
                Alert(
                    title: Text("Error"),  // Alert title.
                    message: Text("Please fill in all fields and select due date that is today or newer.")  // Message explaining the error.
                )
            })
        }
    }
}

// SwiftUI Preview for development and testing.
struct NewItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewItemView(newItemPresented: Binding(get: {
            return true  // Example binding to always present the view in previews.
        }, set: { _ in
        
        }))
    }
}
