import UIKit

class AppCoordinator {
    
    let window: UIWindow
    
    var signupCoordinator: SignupCoordinator?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showWelcomeScreen()
    }
    
    func showWelcomeScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let welcomeViewController = storyboard.instantiateViewController(withIdentifier: "welcome") as? WelcomeViewController else { preconditionFailure() }
        welcomeViewController.delegate = self
        window.rootViewController = welcomeViewController
    }
}

extension AppCoordinator: WelcomeViewControllerDelegate {
    
    func didTapSignup() {
        startSignupCoordinator()
    }

    private func startSignupCoordinator() {
        guard let rootViewController = window.rootViewController else { preconditionFailure() }
        signupCoordinator = SignupCoordinator(presentingViewController: rootViewController)
        signupCoordinator?.delegate = self
        signupCoordinator?.start()
    }
    
    fileprivate func finishSignupCoordinator() {
        signupCoordinator = nil
    }
}

extension AppCoordinator: SignupCoordinatorDelegate {
    
    func didSucceed() {
        finishSignupCoordinator()
    }
    
    func didCancel() {
        finishSignupCoordinator()
    }
}
