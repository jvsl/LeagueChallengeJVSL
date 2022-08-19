import Foundation

final class Parser {
    static func decode<T : Decodable>(from data: Data) throws -> T {
        
        return try JSONDecoder().decode(T.self, from: data)
    }
}
