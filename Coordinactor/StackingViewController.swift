import UIKit

protocol StackingViewController {
    
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
    func present(_ viewControllerToPresent: PresentingViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
    func present(_ viewControllerToPresent: StackingViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
    func dismiss(animated flag: Bool, completion: (() -> Swift.Void)?)

    var viewControllers: [UIViewController] { get set }
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    @discardableResult func popToRootViewController(animated: Bool) -> [UIViewController]?
}

extension UINavigationController: StackingViewController {}
