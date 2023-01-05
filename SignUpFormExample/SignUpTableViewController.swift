//
//  SignUpTableViewController.swift
//  SignUpFormExample
//
//  Created by Yuriy Gudimov on 04.01.2023.
//

import UIKit
import Combine

// SIGN UP FORM RULES
// - email address must be valid (contain @ and .)
// - password must be at least 8 characters
// - password cannot be "password"
// - password confirmation must match
// - must agree to terms
// - BONUS: color email field red when invalid, password confirmation field red when it doesn't match the password
// - BONUS: email address must remove spaces, lowercased

class SignUpTableViewController: UITableViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var emailAddressField: FormTextField!
    @IBOutlet weak var passwordField: FormTextField!
    @IBOutlet weak var passwordConfirmationField: FormTextField!
    @IBOutlet weak var agreeTermsSwitch: UISwitch!
    @IBOutlet weak var signUpButton: BigButton!
    
    //MARK: - Subjects
    private var emailSubject = CurrentValueSubject<String, Never>("")
    private var passwordSubject = CurrentValueSubject<String, Never>("")
    private var passwordConfirmationSubject = CurrentValueSubject<String, Never>("")
    private var agreeTermsSubject = CurrentValueSubject<Bool, Never>(false)
    private var cancellables: Set<AnyCancellable> = []
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailAddressField.isSecureTextEntry = false
        
        formIsValid
            .assign(to: \.isEnabled, on: signUpButton)
            .store(in: &cancellables)
        
        setValidColor(field: emailAddressField, publisher: emailIsValid)
        setValidColor(field: passwordField, publisher: passwordIsValid)
        setValidColor(field: passwordConfirmationField, publisher: passwordConfirmationIsVaild)
        
        formattedEmailAddress
            .filter { [unowned self] in $0 != emailSubject.value }
            .map { $0 as String? }
            .assign(to: \.text, on: emailAddressField)
            .store(in: &cancellables)
    }
    
    //Coloring fields by rules
    private func setValidColor<P: Publisher>(field: UITextField, publisher: P) where P.Output == Bool, P.Failure == Never {
        publisher
            .map{ $0 ? UIColor.label : UIColor.systemRed }
            .assign(to: \.textColor, on: field)
            .store(in: &cancellables)
    }
    
    //MARK: - Publishers

    //Form check
    private var formIsValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(emailIsValid,
                                  passwordAndConfirmationIsValid,
                                  agreeTermsSubject
        )
        .map { $0.0 && $0.1 && $0.2 }
        .eraseToAnyPublisher()
    }

    //Email check
    private var formattedEmailAddress: AnyPublisher<String, Never> {
        emailSubject
            .map { $0.lowercased() }
            .map { $0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) }
            .eraseToAnyPublisher()
    }
    
    private var emailIsValid: AnyPublisher<Bool, Never> {
        formattedEmailAddress
            .map { [weak self] in self?.isValidEmail($0) }
            .replaceNil(with: false)
            .eraseToAnyPublisher()
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        email.contains("@") && email.contains(".")
    }
    
    //Password check
    private var passwordAndConfirmationIsValid: AnyPublisher<Bool, Never> {
        passwordIsValid.combineLatest(passwordConfirmationIsVaild)
            .map { valid, confirmed in
                valid && confirmed
            }
            .eraseToAnyPublisher()
    }
    private var passwordIsValid: AnyPublisher<Bool, Never> {
        passwordSubject
            .map { $0 != "password" && $0.count >= 8 }
            .eraseToAnyPublisher()
    }
    
    private var passwordConfirmationIsVaild: AnyPublisher<Bool, Never> {
        passwordSubject.combineLatest(passwordConfirmationSubject)
            .map { password, confirmation in
                password == confirmation
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Actions
    
    @IBAction func emailDidChanged(_ sender: FormTextField) {
        emailSubject.send(emailAddressField.text ?? "")
    }
    
    @IBAction func passwordDidChanged(_ sender: FormTextField) {
        passwordSubject.send(passwordField.text ?? "")
    }
    
    @IBAction func passwordConfirmationDidChanged(_ sender: FormTextField) {
        passwordConfirmationSubject.send(passwordConfirmationField.text ?? "")
    }
    
    @IBAction func agreeSwitchDidChanged(_ sender: UISwitch) {
        agreeTermsSubject.send(agreeTermsSwitch.isOn)
    }
    
    @IBAction func signUpTapped(_ sender: BigButton) {
        let alert = UIAlertController(title: "Welcome", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
}
