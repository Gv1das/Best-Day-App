import SwiftUI

/// TLButton creates a stylized button component for the ToDoList app.
struct TLButton: View {
    
    let title: String  // Text to be displayed on the button.
    let background: Color  // Background color of the button.
    let action: () -> Void  // Closure that defines the action to be performed when the button is tapped.
    
    var body: some View {
        Button(action: {
            action()  // Execute the action passed to the button.
        }, label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)  // Rounded rectangle as the button shape.
                    .foregroundColor(background)  // Apply the background color passed to the button.
                
                Text(title)  // Display the title of the button.
                    .foregroundColor(Color.white)  // White text color for better contrast.
                    .bold()  // Bold text to make the title stand out.
            }
        })
    }
}

// SwiftUI Preview for development and testing.
struct TLButton_Previews: PreviewProvider {
    static var previews: some View {
        TLButton(title: "Value", background: .pink) {
            // Placeholder for the button action in previews.
        }
    }
}
