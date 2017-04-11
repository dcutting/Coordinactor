import Foundation

class MockSignupService: SignupService {
    
    func signup(username: String, completion: @escaping (SignupServiceStatus) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.completeSignup(completion: completion)
        }
    }
    
    private func completeSignup(completion: (SignupServiceStatus) -> Void) {
        let rnd = arc4random() % 3
        if 0 == rnd {
            completion(.success)
        } else if 1 == rnd {
            let error = SignupServiceError.network
            completion(.error(error))
        } else {
            let error = SignupServiceError.duplicate
            completion(.error(error))
        }
    }
}
