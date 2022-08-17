import Foundation

protocol LeagueSocialMediaInteracting: AnyObject {}

final class LeagueSocialMediaInteractor {
    private let service: LeagueSocialMediaServicing
    private let presenter: LeagueSocialMediaPresenting

    init(service: LeagueSocialMediaServicing, presenter: LeagueSocialMediaPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

extension LeagueSocialMediaInteractor: LeagueSocialMediaInteracting {}
