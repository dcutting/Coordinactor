import UIKit

class UsernameWireframe {
    
    func make() -> UsernameViewController {
        guard let viewController = UIStoryboard.loadViewController(from: "Main", named: "username") as? UsernameViewController else { preconditionFailure() }
        return viewController
    }
}
