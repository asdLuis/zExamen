import Foundation

/// ConsultDataViewModel manages historical events data fetching, including loading state and error handling.
class ConsultDataViewModel: ObservableObject {
    /// Holds the list of all fetched historical events.
    @Published var dataItems: [HistoricalItem] = []
    
    /// Indicates if a loading process is in progress.
    @Published var isLoading: Bool = false
    
    /// Stores an error message if the data fetch fails.
    @Published var errorMessage: String?
    
    private let requirement: ConsultDataRequirementProtocol
    
    /// Initializes ConsultDataViewModel with a dependency on a ConsultDataRequirementProtocol instance.
    ///
    /// - Parameter requirement: The protocol instance used to fetch data. Defaults to the singleton instance.
    init(requirement: ConsultDataRequirementProtocol = ConsultDataRequirement.shared) {
        self.requirement = requirement
    }

    /// Fetches all historical events from the database and updates view model properties accordingly.
    ///
    /// Displays a success or informational message based on the result and updates dataItems and errorMessage.
    @MainActor
    func fetchData() async {
        isLoading = true
        errorMessage = nil
        do {
            let fetchedData = try await requirement.fetchData()
            self.dataItems = fetchedData
            
            if fetchedData.isEmpty {
                ToastManager.shared.show(message: "No historical events found.", type: .info)
            }
        } catch {
            self.errorMessage = "Error fetching historical events."
            ToastManager.shared.show(message: self.errorMessage!, type: .error)
        }
        isLoading = false
    }
}
