class UsernamePresenter {
    
    let validMessage = "Username is valid"
    
    func prepareDefault() -> UsernameViewData {
        return UsernameViewData(text: "", messages: "")
    }
    
    func prepare(status: UsernameInteractor.ValidateStatus) -> UsernameViewData {
        switch status {
        case let .valid(username):
            return UsernameViewData(text: username, messages: validMessage)
        case let .invalid(username, reasons):
            let messages = makeMessages(for: reasons)
            return UsernameViewData(text: username, messages: messages)
        }
    }
    
    private func makeMessages(for reasons: [UsernameInteractor.InvalidReason]) -> String {
        let reasonMessages: [String] = reasons.map { reason in
            switch reason {
            case let .disallowedCharacters(characters):
                let characterList = characters.map { String($0) }.joined(separator: ", ")
                return "Contains disallowed characters: \(characterList)"
            case let .tooShort(minimumLength):
                return "Minimum length must be \(minimumLength) characters"
            }
        }
        let messages = reasonMessages.joined(separator: "\n")
        return messages
    }
}
