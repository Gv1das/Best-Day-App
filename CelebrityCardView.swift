import SwiftUI

/// CelebrityCardView displays a single celebrity routine as a card within a list, showing a lock icon if not purchased.
struct CelebrityCardView: View {
    let routine: CelebrityRoutine  // Data model for the celebrity routine.
    let isPurchased: Bool  // Indicates whether the routine has been purchased by the user.

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(routine.celebrityName)  // Display the celebrity's name.
                        .font(.headline)  // Larger font size for better visibility.
                        .foregroundColor(.white)
                    Text(routine.description)  // Display the routine description.
                        .font(.footnote)  // Smaller font size for secondary text.
                        .foregroundColor(.white.opacity(0.7))  // Slightly transparent for subtlety.
                        .multilineTextAlignment(.leading)  // Align text to the left.
                }
                
                Spacer()  // Pushes the content to the left and lock icon to the right.
                
                if !isPurchased {
                    Image(systemName: "lock.fill")  // Lock icon indicates the routine is not purchased.
                        .foregroundColor(.white)
                        .opacity(0.8)
                        .padding(.trailing, 5)
                }
                
                AsyncImage(url: URL(string: routine.photo)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()  // Displayed while the image is loading.
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()  // Ensures the image fills the frame while maintaining its aspect ratio.
                            .frame(width: 60, height: 60)  // Fixed size for all images.
                            .clipShape(RoundedRectangle(cornerRadius: 10))  // Rounded corners for aesthetics.
                    case .failure:
                        Image(systemName: "photo")  // Default placeholder if the image fails to load.
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()  // Fallback for future cases.
                    }
                }

            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .frame(height: 100)  // Fixed height for uniformity across cards.
        .background(VisualEffectView(effect: UIBlurEffect(style: .dark)))  // Dark blurred background for readability.
        .clipShape(RoundedRectangle(cornerRadius: 15))  // Rounded corners for the entire card.
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)  // Subtle border around the card.
        )
        .padding(.horizontal)  // Horizontal padding to give space between cards in the list.
    }
}
