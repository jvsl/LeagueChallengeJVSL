import XCTest
@testable import LeagueMobileChallenge

final class LeagueSocialMediaCoordinatorTests: XCTestCase {
    
    var viewControllerSpy = ViewControllerSpy()
    private lazy var sut: LeagueSocialMediaCoordinating = {
        let coordinator = LeagueSocialMediaCoordinator()
        coordinator.viewController = viewControllerSpy
        return coordinator
    }()
    
    func testActionRetry_action_shouldIncrementPresentControllerCounter() {
        sut.perform(action: .error(retry: { print("RETRY") }))
        
        XCTAssertEqual(viewControllerSpy.callPresentControllerCount, 1)
    }
}
