import UIKit

class ErrorWireframe {
    
    func make() -> ErrorViewController {
        guard let viewController = UIStoryboard.loadViewController(from: "Main", named: "error") as? ErrorViewController else { preconditionFailure() }
        return viewController
    }
}
