import SwiftUI

/// `ToastView` is a view that displays a toast message with information, warning, success, or error types.
/// Includes a title, an icon associated with the type, and a close button.
struct ToastView: View {
    let message: String          // Message to display in the toast
    let type: ToastType          // Type of toast (success, error, etc.)
    let show: Bool               // Defines if the toast is visible
    let onDismiss: () -> Void    // Action to close the toast
    
    @State private var offset: CGFloat = 100  // Controls the initial position for the animation

    var body: some View {
        if show {  // Only shows the toast when 'show' is true
            VStack {
                HStack(spacing: 12) {
                    // Icon and title of the toast type
                    HStack {
                        type.icon
                            .foregroundColor(type.accentColor)
                        
                        Text(type.title)
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    // Button to close the toast
                    Button(action: onDismiss) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 8)
                
                // Main message of the toast
                HStack {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
            .padding()
            .background(Color(uiColor: .systemBackground))  // Background of the toast
            .cornerRadius(8)  // Rounded corners of the toast
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)  // Shadow of the toast
            .padding(.horizontal)
            .offset(y: offset)
            .onAppear {
                withAnimation(.spring()) {
                    offset = 0  // Animates the offset to the initial position
                }
            }
        }
    }
}

/// `ToastType` represents the available toast types and defines their associated properties.
enum ToastType {
    case success   // Success toast
    case error     // Error toast
    case info      // Informative toast
    case warning   // Warning toast
    
    // Icon associated with each toast type
    var icon: Image {
        switch self {
        case .success:
            return Image(systemName: "checkmark.circle.fill")
        case .error:
            return Image(systemName: "xmark.circle.fill")
        case .info:
            return Image(systemName: "info.circle.fill")
        case .warning:
            return Image(systemName: "exclamationmark.triangle.fill")
        }
    }
    
    // Title of the toast type
    var title: String {
        switch self {
        case .success:
            return "Exito"
        case .error:
            return "Error"
        case .info:
            return "Info"
        case .warning:
            return "Alerta"
        }
    }
    
    // Accent color associated with each toast type
    var accentColor: Color {
        switch self {
        case .success:
            return .green
        case .error:
            return .red
        case .info:
            return .blue
        case .warning:
            return .orange
        }
    }
}
