import UIKit

protocol PresentingViewController {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
    func present(_ viewControllerToPresent: PresentingViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
    func present(_ viewControllerToPresent: StackingViewController, animated flag: Bool, completion: (() -> Swift.Void)?)
    func dismiss(animated flag: Bool, completion: (() -> Swift.Void)?)
}

extension PresentingViewController {
    
    func present(_ viewControllerToPresent: PresentingViewController, animated flag: Bool, completion: (() -> Swift.Void)?) {
        guard let viewController = viewControllerToPresent as? UIViewController else { preconditionFailure() }
        present(viewController, animated: flag, completion: completion)
    }
    
    func present(_ viewControllerToPresent: StackingViewController, animated flag: Bool, completion: (() -> Swift.Void)?) {
        guard let viewController = viewControllerToPresent as? UIViewController else { preconditionFailure() }
        present(viewController, animated: flag, completion: completion)
    }
}

extension UIViewController: PresentingViewController {}
