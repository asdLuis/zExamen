import Foundation
import ParseCore

class ParseService {
    static let shared = ParseService()
    /// Tracks the success status of the Parse Service login operation
    @Published var successfulParse = false
    
    /// Private initializer to restrict instantiation to the `shared` instance only
    private init() {}
    
    /// Fetches historical events for a specific page.
    /// - Parameter page: The page number to fetch data for.
    /// - Returns: An array of `HistoricalItem` objects.
    /// - Throws: An error if the fetch operation fails.
    func fetchHistoricalEvents() async throws -> [HistoricalItem] {
        return try await withCheckedThrowingContinuation { continuation in
            PFCloud.callFunction(inBackground: "hello", withParameters: [:]) { (response, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let responseDict = response as? [String: Any],
                      let pfObjects = responseDict["data"] as? [PFObject] else {
                    continuation.resume(throwing: NSError(domain: "ParseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"]))
                    return
                }
                
                // Convert PFObjects to HistoricalItem
                let historicalItems = pfObjects.map { pfObject -> HistoricalItem in
                    return HistoricalItem(
                        date: pfObject["date"] as? String ?? "",
                        description: pfObject["description"] as? String ?? "",
                        lang: pfObject["lang"] as? String ?? "",
                        category1: pfObject["category1"] as? String ?? "",
                        category2: pfObject["category2"] as? String ?? "",
                        granularity: pfObject["granularity"] as? String ?? "",
                        createdAt: pfObject.createdAt ?? Date(),
                        updatedAt: pfObject.updatedAt ?? Date(),
                        objectId: pfObject.objectId ?? "",
                        type: "__type",
                        className: pfObject.parseClassName ?? ""
                    )
                }
                
                continuation.resume(returning: historicalItems)
            }
        }
    }
}
