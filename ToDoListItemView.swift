import SwiftUI

/// View representation of a single to-do item, displaying its title, due time, and completion status.
struct ToDoListItemView: View {
    @StateObject var viewModel = ToDoListItemViewViewModel() // ViewModel for managing item-specific actions such as marking as done.
    let item: ToDoListItem // The to-do item to display.

    var body: some View {
        HStack (spacing: 15){
            // Time label with a visual effect background to make it stand out.
            Text(Date(timeIntervalSince1970: item.dueDate), style: .time)
                .font(.system(size: 16, weight: .bold))
                .frame(width: 80, height: 50) // Fixed width and height for uniformity.
                .background(VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))) // Frosted glass effect.
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.leading, -20) // Adjusted padding for alignment.

            // Title label with a visual effect background to maintain consistency with the time label.
            Text(item.title)
                .font(.system(size: 25))
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50) // Expand to fill available space.
                .background(VisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))) // Frosted glass effect.
                .clipShape(RoundedRectangle(cornerRadius: 8))

            // Button to toggle the item's completion status with a checkmark icon.
            Button(action: {
                viewModel.toggleIsDone(item: item) // Toggle the completion status of the item.
            }) {
                Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle") // Show filled or empty circle based on completion status.
                    .resizable()
                    .frame(width: 30, height: 30) // Uniform size for the icon.
                    .foregroundColor(item.isDone ? .blue : .gray) // Color changes based on completion status.
            }
            .padding(.trailing, -15) // Adjust padding for alignment.
        }
        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading) // Ensure the entire row is selectable and aligned properly.
        .padding(.horizontal, 20) // Horizontal padding for spacing from the container edges.
        .background(Color.clear) // Transparent background to blend with any view.
        .cornerRadius(15)
        .shadow(radius: 5) // Subtle shadow for better layer separation.
    }
}

/// UIViewRepresentable wrapper for UIVisualEffectView to enable the use of UIBlurEffect within SwiftUI.
struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        return UIVisualEffectView(effect: effect) // Create and return a UIVisualEffectView with the specified effect.
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect // Update the effect whenever it changes.
    }
}

// SwiftUI Preview for development and testing.
struct ToDoListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListItemView(item: .init(
            id: "123",
            title: "Get milk",
            dueDate: Date().timeIntervalSince1970,
            createdTime: Date().timeIntervalSince1970,
            isDone: true)
        )
    }
}
