import Foundation

/// Protocol that defines the requirement to consult data.
protocol ConsultDataRequirementProtocol {
    /// Fetches all historical events from the database.
    ///
    /// - Returns: An array of HistoricalEvent objects.
    /// - Throws: An error if the fetch operation fails.
    func fetchData() async throws -> [HistoricalItem]
}

/// Class responsible for consulting data using a repository.
class ConsultDataRequirement: ConsultDataRequirementProtocol {
    /// Repository for managing data operations.
    private let repository: DataRepositoryProtocol
    
    /// Singleton instance for shared usage across the app.
    static let shared = ConsultDataRequirement()
    
    /// Initializes an instance of ConsultDataRequirement with the specified data repository.
    ///
    /// - Parameter repository: An object conforming to DataRepositoryProtocol used to fetch data. Defaults to the singleton DataRepository.shared.
    init(with repository: DataRepository = DataRepository.shared) {
        self.repository = repository
    }
    
    /// Fetches all historical events using the specified repository.
    ///
    /// - Returns: An array of HistoricalEvent objects.
    /// - Throws: An error if the fetch operation fails.
    func fetchData() async throws -> [HistoricalItem] {
        return try await repository.fetchData()
    }
}
