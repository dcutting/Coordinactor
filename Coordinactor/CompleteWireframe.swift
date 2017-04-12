import UIKit

class CompleteWireframe {
    
    func make() -> CompleteViewController {
        guard let viewController = UIStoryboard.loadViewController(from: "Main", named: "complete") as? CompleteViewController else { preconditionFailure() }
        return viewController
    }
}
