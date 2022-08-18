import UIKit

public final class NavigationControllerSpy: UINavigationController {
    public private(set) var callPushViewControllerCount: Int = 0
    public private(set) var callPopViewControllerCount: Int = 0
    public private(set) var callPopToViewControllerCount: Int = 0
    public private(set) var callPresentViewControllerCount: Int = 0
    public private(set) var callDismissViewControllerCount: Int = 0
    
    public private(set) var pushedViewController: UIViewController?
    public private(set) var popedViewController: UIViewController?
    public private(set) var viewControllerPresented: UIViewController?
    
    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !(viewController is ViewControllerSpy) {
            pushedViewController = viewController
            callPushViewControllerCount += 1
        }
        super.pushViewController(viewController, animated: false)
    }
    
    override public func popViewController(animated: Bool) -> UIViewController? {
        let viewController = super.popViewController(animated: false)
        popedViewController = viewController
        callPopViewControllerCount += 1
        return viewController
    }
    
    override public func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        let viewControllers = super.popToViewController(viewController, animated: animated)
        popedViewController = viewController
        callPopToViewControllerCount += 1
        return viewControllers
    }
    
    override public func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        viewControllerPresented = viewControllerToPresent
        callPresentViewControllerCount += 1
        super.present(viewControllerToPresent, animated: false)
        completion?()
    }
    
    override public func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        callDismissViewControllerCount += 1
        super.dismiss(animated: false)
        completion?()
    }

    // MARK: - Helpers
    public func tapAtBackBarButton() {
        let controllers = viewControllers.filter { $0 != topViewController }

        guard let controller = controllers.first else {
            return
        }

        setViewControllers(controllers, animated: false)
        delegate?.navigationController?(self, didShow: controller, animated: true)
    }
}
