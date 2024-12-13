//
//  LogInViewModel.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 13.12.2024.
//

import Foundation

class LogInViewModel {
    var loginText: String = ""
    var passwordText: String = ""

    var onValidationError: ((String) -> Void)?
    var onLoginSuccess: (() -> Void)?
    var onLoginBlocked: ((String) -> Void)?

    private var countErrors: Int = 0

    func validateAndLogin() {
        guard !loginText.isEmpty, !passwordText.isEmpty else {
            onValidationError?("Login or password not specified".localized)
            incrementErrorCount()
            return
        }

        FirebaseAutch.shared.singIn(withEmail: loginText, password: passwordText) { result in
            switch result {
            case .success(let uid):
                print("uid: \(uid)")
                UserService.shared.getUser(byId: uid) { user, error in
                    if let error = error {
                        self.onValidationError?("Ошибка: \(error.localizedDescription)")
                    } else if let user = user {
                        CurrentUser.shared.user = user
                        self.onLoginSuccess?()
                    } else {
                        self.onValidationError?("Failed to load user data".localized)
                    }
                }
            case .failure(_):
                self.onValidationError?("Invalid login or password".localized)
                self.incrementErrorCount()
            }
        }
    }

    private func incrementErrorCount() {
        countErrors += 1
        if countErrors >= 3 {
            blockLogin()
        }
    }

    private func blockLogin() {
        var counter = 60
        onLoginBlocked?("До следующей попытки \(counter) с.")

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            counter -= 1

            if counter <= 0 {
                timer.invalidate()
                self.countErrors = 0
                self.onLoginBlocked?("")
            } else {
                self.onLoginBlocked?("До следующей попытки \(counter) с.")
            }
        }
    }
}
