import SwiftUI

/// HeaderView creates a visually distinct header for views, utilizing a titled background with an angular rotation.
struct HeaderView: View {
    var title: String  // The main title text of the header.
    var subtitle: String  // The subtitle text displayed beneath the main title.
    let angle: Double  // The angle at which the background rectangle is rotated.
    let background: Color  // The background color of the header.

    var body: some View {
        ZStack {
            // Background shape with rotation
            RoundedRectangle(cornerRadius: 0)  // Creates a rectangle with no rounded corners.
                .foregroundColor(background)  // Apply the provided background color.
                .rotationEffect(Angle(degrees: angle))  // Rotate the rectangle by the specified angle.
                
            // Text stack for title and subtitle
            VStack {
                Text(title)
                    .font(.system(size: 50))  // Large font size for the title for emphasis.
                    .foregroundColor(Color.white)  // White text color for contrast.
                    .bold()  // Bold font weight for better visibility.
                
                Text(subtitle)
                    .font(.system(size: 30))  // Slightly smaller font size for the subtitle.
                    .foregroundColor(Color.white)  // Maintain white color for consistent contrast.
            }
            .padding(.top, 80)  // Top padding to push the text downward within the rotated background.
        }
        .frame(width: UIScreen.main.bounds.width*3, height: 350)  // Set the frame size large enough to ensure the rotated background covers the view area.
        .offset(y: -150)  // Vertically offset the header to align it as needed within the parent view.
    }
}

// SwiftUI Preview for development and testing.
struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Title",
                   subtitle: "Subtitle",
                   angle: 15,
                   background: .blue)  // Example preview with specific properties.
    }
}
