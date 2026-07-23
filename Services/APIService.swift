import Foundation

class APIService {
    static let shared = APIService()

    private let session = URLSession.shared
    private let baseURL = "https://api.example.com"
    private let decoder = JSONDecoder()

    init() {
        decoder.dateDecodingStrategy = .iso8601
    }

    func fetchRecommendations(request: SchedulingRequest) async throws -> [ScheduleRecommendation] {
        guard let url = URL(string: "\(baseURL)/scheduling/recommendations") else {
            throw APIError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(getAPIKey())", forHTTPHeaderField: "Authorization")

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        urlRequest.httpBody = try encoder.encode(request)

        let (data, response) = try await session.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }

        let recommendations = try decoder.decode([ScheduleRecommendation].self, from: data)
        return recommendations
    }

    private func getAPIKey() -> String {
        ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case networkError(Error)

    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
