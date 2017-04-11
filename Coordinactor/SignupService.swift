enum SignupServiceError: Error {
    case duplicate
    case network
}

enum SignupServiceStatus {
    case success
    case error(Error)
}

protocol SignupService {
    func signup(username: String, completion: @escaping (SignupServiceStatus) -> Void)
}
