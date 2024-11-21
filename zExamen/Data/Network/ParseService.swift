import Foundation
import ParseCore

class ParseService {
    static let shared = ParseService()
    /// Tracks the success status of the Parse Service login operation
    @Published var successfulParse = false
    
    /// Private initializer to restrict instantiation to the `shared` instance only
    private init() {}
    
    /// Calls a cloud function asynchronously and returns the result.
    ///
    /// - Parameters:
    ///   - functionName: The name of the cloud function to be called.
    ///   - params: A dictionary of parameters to be passed to the cloud function.
    /// - Returns: The result of the cloud function call as the specified type `T`.
    /// - Throws: An error if the cloud function call fails or the result type is unexpected.
    
    func callCloudFunction<T>(
        functionName: String,
        params: [String: Any]
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            PFCloud.callFunction(inBackground: functionName, withParameters: params) { (result, error) in
                if let error = error {
                    // If an error occurs, resume with the error.
                    continuation.resume(throwing: error)
                } else if let result = result as? T {
                    // If the result is of the expected type, resume with the result.
                    continuation.resume(returning: result)
                } else {
                    // If the result type is unexpected, throw an error.
                    
                    let parseError = NSError(domain: "ParseError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected type of result"])
                    continuation.resume(throwing: parseError)
                }
            }
        }
    }
    
    func fetchData() async throws -> [Data] {
        let params: [String: Any] = [:]
        
        let result: [[String: String]] = try await callCloudFunction(functionName: "consultarDatos", params: params)
        
        return result.compactMap { dataMap in
            guard let idString = dataMap["id"],
                  let id = Int(idString),
                  let name = dataMap["name"],
                  let description = dataMap["description"] else {
                return nil
            }
            return Data(id: id, name: name, description: description)
        }
    }
}
