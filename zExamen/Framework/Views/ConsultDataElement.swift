import SwiftUI

/// A view representing a single list element in the data consultation list.
struct ConsultDataListElement: View {
    /// The current color scheme of the environment (light or dark mode).
    @Environment(\.colorScheme) var colorScheme
    
    /// The name of the data item to display.
    var name: String
    
    /// The description of the data item to display.
    var description: String
    
    /// The ID of the data item (if needed for future functionality or display).
    var id: Int
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                HStack {
                    // Icon representing the data item (using a placeholder image for now).
                    Image(systemName: "app.fill")  // You can change this to a relevant icon.
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(.leading, 5)
                    
                    // Displays the data item's name, aligned to the leading edge.
                    Text(name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(maxWidth: .infinity)
                
                // Displays the description of the data item, centered within its frame.
                Text(description)
                    .frame(maxWidth: .infinity, alignment: .center)
                
                HStack {
                    // Placeholder for an additional feature, like an edit or detail button.
                    Button(action: {
                        // Handle action, e.g., navigate to detailed view or edit.
                    }) {
                        Image(systemName: "chevron.right.circle.fill")
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                            .padding(.trailing, 10)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .font(Font.custom("Times New Roman", size: 14))
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
            .padding(.vertical, 8)
            .frame(width: geometry.size.width * 0.9)
            .background(.white)
            .cornerRadius(20)
            .shadow(radius: 5)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .frame(height: 60)
    }
}
