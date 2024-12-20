import Foundation

/// Protocol defining methods for managing data operations.
protocol DataRepositoryProtocol {
    /// Fetches a list of historical events.
    ///
    /// - Returns: An array of HistoricalEvent objects.
    /// - Throws: An error if the fetch request fails.
    func fetchData() async throws -> [HistoricalItem]
}

/// Concrete implementation of DataRepositoryProtocol for handling data operations.
class DataRepository: DataRepositoryProtocol {
    /// Service for managing backend operations related to data.
    let nservice: ParseService
    
    /// Singleton instance for shared usage across the app.
    static let shared = DataRepository()
    
    /// Initializes a new DataRepository with a specified ParseService.
    ///
    /// - Parameter nservice: A ParseService instance used for backend communication (default: shared instance).
    init(nservice: ParseService = ParseService.shared) {
        self.nservice = nservice
    }
    
    /// Retrieves a list of historical events from the backend.
    ///
    /// - Returns: An array of HistoricalEvent objects.
    /// - Throws: An error if the retrieval fails.
    func fetchData() async throws -> [HistoricalItem] {
        return try await nservice.fetchHistoricalEvents()
    }
}
