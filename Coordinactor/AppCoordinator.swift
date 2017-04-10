import UIKit

class AppCoordinator {
    
    let window: UIWindow
    
    var welcomeViewController: WelcomeViewController?
    var signupCoordinator: SignupCoordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        welcomeViewController = storyboard.instantiateViewController(withIdentifier: "welcome") as? WelcomeViewController
        welcomeViewController?.delegate = self
        window.rootViewController = welcomeViewController
    }
}

extension AppCoordinator: WelcomeViewControllerDelegate {
    
    func didTapSignup() {
        guard let rootViewController = welcomeViewController else { return }
        signupCoordinator = SignupCoordinator(rootViewController: rootViewController)
        signupCoordinator?.delegate = self
        signupCoordinator?.start()
    }
}

extension AppCoordinator: SignupCoordinatorDelegate {
    
    func didCancel() {
        signupCoordinator = nil
    }
}
