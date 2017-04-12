import UIKit

protocol UsernameCoordinatorDelegate: class {
    func didSucceed()
    func didFail(with error: Error)
}

class UsernameCoordinator {
    
    weak var delegate: UsernameCoordinatorDelegate?
    
    let rootViewController: StackingViewController
    
    let interactor = UsernameInteractor(signupService: MockSignupService())
    let presenter = UsernamePresenter()
    let viewController: UsernameViewController
    
    init(stackingViewController: StackingViewController) {
        self.rootViewController = stackingViewController
        viewController = UsernameWireframe().make()
        viewController.delegate = self
    }

    func start() {
        showUsernameScreen()
    }
    
    private func showUsernameScreen() {
        rootViewController.pushViewController(viewController, animated: true)
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
        rootViewController.present(alert, animated: true, completion: nil)
    }
    
    private func hideLoading() {
        rootViewController.dismiss(animated: true, completion: nil)
    }
}
