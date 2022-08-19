enum LeagueSocialMediaFactory {
    static func make() -> LeagueSocialMediaViewController {
        let service: LeagueSocialMediaServicing = LeagueSocialMediaService()
        let coordinator: LeagueSocialMediaCoordinating = LeagueSocialMediaCoordinator()
        let presenter: LeagueSocialMediaPresenting = LeagueSocialMediaPresenter(coordinator: coordinator)
        let interactor = LeagueSocialMediaInteractor(service: service, presenter: presenter)
        let viewController = LeagueSocialMediaViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
