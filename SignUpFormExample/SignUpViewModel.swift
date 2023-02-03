//
//  SignUpViewModel.swift
//  SignUpFormExample
//
//  Created by Yuriy Gudimov on 18.01.2023.
//

import Foundation
import Combine
import UIKit

class SignUpViewModel {
    @Published
    var email: String?
    @Published
    var password = ""
    @Published
    var passwordConfirmation = ""
    @Published
    var agreeTerms = false
    @Published
    var emailFieldTextColor: UIColor?
    @Published
    var passwordFieldTextColor: UIColor?
    @Published
    var passwordConfirmationFieldTextColor: UIColor?
    @Published
    var signUpButtonEnabled = false
    
    init() {
        setupPipeline()
    }
    
    //MARK: - Pipeline
    private func setupPipeline() {
        configureEmailAddressBehaviour()
        configurePasswordBahaviour()
        configurePasswordConfirmationBehaviour()
        configureSignUpButtonBehaviour()
    }
    
    private func configureEmailAddressBehaviour() {
        // format emsil address
        formattedEmailAddress
            .map { $0 as String? }
            .removeDuplicates()
            .assign(to: &$email)
        
        // set the text color when invalid
        emailIsValid
            .mapToFieldInputColor()
            .assign(to: &$emailFieldTextColor)
    }
    
    private func configurePasswordBahaviour() {
        passwordIsValid
            .mapToFieldInputColor()
            .assign(to: &$passwordFieldTextColor)
    }
    
    private func configurePasswordConfirmationBehaviour() {
        passwordAndConfirmationIsValid
            .mapToFieldInputColor()
            .assign(to: &$passwordConfirmationFieldTextColor)
    }
    
    private func configureSignUpButtonBehaviour() {
        formIsValid.assign(to: &$signUpButtonEnabled)
    }
    
    //MARK: - Publishers

    //Form check
    var formIsValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(emailIsValid,
                                  passwordAndConfirmationIsValid,
                                  $agreeTerms
        )
        .map { $0.0 && $0.1 && $0.2 }
        .eraseToAnyPublisher()
    }

    //Email check
    var formattedEmailAddress: AnyPublisher<String, Never> {
        $email
            .map { ($0 ?? "").lowercased() }
            .map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
            .eraseToAnyPublisher()
    }
    
    var emailIsValid: AnyPublisher<Bool, Never> {
        formattedEmailAddress
            .map { [weak self] in self?.isValidEmail($0) }
            .replaceNil(with: false)
            .eraseToAnyPublisher()
    }
    
    func isValidEmail(_ email: String) -> Bool {
        email.contains("@") && email.contains(".")
    }
    
    //Passwords check
    var passwordAndConfirmationIsValid: AnyPublisher<Bool, Never> {
        passwordIsValid.combineLatest(passwordConfirmationIsVaild)
            .map { valid, confirmed in
                valid && confirmed
            }
            .eraseToAnyPublisher()
    }
    var passwordIsValid: AnyPublisher<Bool, Never> {
        $password
            .map { $0 != "password" && $0.count >= 8 }
            .eraseToAnyPublisher()
    }
    
    var passwordConfirmationIsVaild: AnyPublisher<Bool, Never> {
        $password.combineLatest($passwordConfirmation)
            .map { password, confirmation in
                password == confirmation
            }
            .eraseToAnyPublisher()
    }
}
