import Foundation

// Represents the top-level response structure that contains the result.
struct HistoricalResponse: Codable {
    // The `result` key holds the actual historical data.
    let result: HistoricalResult
}

// Represents the result structure which contains metadata and the actual data.
struct HistoricalResult: Codable {
    let code: Int  // Response code indicating success or failure.
    let count: Int // The total number of historical items returned.
    let page: String? // Page number if paginated, optional.
    let data: [HistoricalItem] // Array of historical items.
}

// Represents an individual historical item.
struct HistoricalItem: Codable {
    let date: String // Date of the historical event.
    let description: String // Description of the event.
    let lang: String // Language of the description.
    let category1: String // Primary category of the event.
    let category2: String // Secondary category of the event.
    let granularity: String // Granularity of the data (e.g., daily, monthly).
    let createdAt: Date // Date when the item was created.
    let updatedAt: Date // Date when the item was last updated.
    let objectId: String // Unique identifier for the historical item.
    let type: String // Type of object, e.g., “type” for a custom type.
    let className: String // Name of the class this object belongs to.

    // Custom keys for decoding JSON to match property names with API response.
    enum CodingKeys: String, CodingKey {
        case date, description, lang, category1, category2, granularity
        case createdAt, updatedAt, objectId
        case type = "__type" // Decode the "__type" JSON key into "type".
        case className
    }
}

// A JSONDecoder extension that customizes decoding settings for historical data.
extension JSONDecoder {
    static func historicalDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        // Set the decoding strategy for dates to ISO 8601 format.
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
