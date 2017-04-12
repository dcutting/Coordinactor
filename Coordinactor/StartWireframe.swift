import UIKit

class StartWireframe {
    
    func make() -> StartViewController {
        guard let viewController = UIStoryboard.loadViewController(from: "Main", named: "start") as? StartViewController else { preconditionFailure() }
        return viewController
    }
}
