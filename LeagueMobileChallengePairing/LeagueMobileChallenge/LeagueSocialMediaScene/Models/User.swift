// MARK: - User

struct User: Codable {
    let id: Int
    let avatar: String
    let name, username, email: String
    let address: Address
}

// MARK: - Address

struct Address: Codable {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo

struct Geo: Codable {
    let lat, lng: String
}
