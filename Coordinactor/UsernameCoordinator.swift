import UIKit

protocol UsernameCoordinatorDelegate: class {
    func didSucceed()
    func didFail(with error: Error)
}

class UsernameCoordinator {
    
    weak var delegate: UsernameCoordinatorDelegate?
    
    let navigationController: UINavigationController
    
    let interactor = UsernameInteractor(signupService: MockSignupService())
    let presenter = UsernamePresenter()
    let viewController: UsernameViewController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "username") as? UsernameViewController else { preconditionFailure() }
        self.viewController = viewController
        viewController.delegate = self
    }

    func start() {
        showUsernameScreen()
    }
    
    private func showUsernameScreen() {
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension UsernameCoordinator: UsernameViewControllerDelegate {
    
    func viewReady() {
        showDefault()
    }
    
    private func showDefault() {
        let viewData = presenter.prepareDefault()
        viewController.viewData = viewData
    }
    
    func didChangeUsername(to text: String) {
        updateUsername(text: text)
    }
    
    private func updateUsername(text: String) {
        interactor.updateUsername(text: text) { validateStatus in
            let viewData = presenter.prepare(status: validateStatus)
            viewController.viewData = viewData
        }
    }
    
    func didTapNext(with text: String) {
        submitUsername(text: text)
    }
    
    private func submitUsername(text: String) {
        showLoading()
        interactor.submitUsername(text: text) { [weak self] submitStatus in
            guard let `self` = self else { return }
            self.hideLoading()
            switch submitStatus {
            case .success:
                self.delegate?.didSucceed()
            case let .error(error):
                self.delegate?.didFail(with: error)
            }
        }
    }
    
    private func showLoading() {
        let alert = UIAlertController(title: "Submitting...", message: nil, preferredStyle: .alert)
        navigationController.present(alert, animated: true)
    }
    
    private func hideLoading() {
        navigationController.dismiss(animated: true)
    }
}
