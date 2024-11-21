import SwiftUI
import Combine

/// `ToastManager` is a class that manages the display of toast messages in the app.
/// It implements the logic to show a message and automatically hide it after a set time.
class ToastManager: ObservableObject {
    @Published var isShowing = false  // Indicates if the toast is being displayed
    @Published var message = ""       // Message to be displayed in the toast
    @Published var type: ToastType = .info  // Type of toast, can change visual style
    
    static let shared = ToastManager()  // Shared instance for global access
    private var cancellable: AnyCancellable?  // Controls the auto-dismiss timer
    
    /// Private initializer to prevent multiple instances.
    /// Sets up a `sink` that hides the toast after a 3-second delay.
    private init() {
        cancellable = $isShowing
            .filter { $0 }
            .delay(for: 3, scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.dismiss()
            }
    }
    
    /// Displays a message in the toast.
    /// - Parameters:
    ///   - message: The message to display.
    ///   - type: The type of message (defaults to `.info`).
    func show(message: String, type: ToastType = .info) {
            self.message = message
            self.type = type
            self.isShowing = true
            
            // Cancel any existing timer
            cancellable?.cancel()
            
            // Start a new timer for auto-dismiss after 3 seconds
            cancellable = Just(())
                .delay(for: .seconds(3), scheduler: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.dismiss()
                }
        }
    
    /// Hides the toast with an animation.
    func dismiss() {
        withAnimation {
            isShowing = false
        }
    }
}

/// `ToastModifier` is a view modifier that adds a `ToastView` above the main view.
/// This modifier allows any view to display a toast when needed.
struct ToastModifier: ViewModifier {
    @StateObject private var toastManager = ToastManager.shared
    
    /// Defines the view content, adding `ToastView` above the main content.
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            ToastView(
                message: toastManager.message,
                type: toastManager.type,
                show: toastManager.isShowing,
                onDismiss: toastManager.dismiss
            )
        }
    }
}

extension View {
    /// View extension that applies the toast modifier.
    /// This method makes it easy to use `ToastModifier` on any view.
    func toast() -> some View {
        modifier(ToastModifier())
    }
}
