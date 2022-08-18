@testable import LeagueMobileChallenge

extension Post {
    static func fixture() -> Post {
        Post(userID: 1, id: 1, title: "title", body: "body")
    }
}

extension User {
    static func fixture() -> User {
        User(id: 1, avatar: "avatar", username: "name")
    }
}
