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
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    
    @IBAction func emailDidChanged(_ sender: FormTextField) {
    }
    
    @IBAction func passwordDidChanged(_ sender: FormTextField) {
    }
    
    @IBAction func passwordConfirmationDidChanged(_ sender: FormTextField) {
    }
    
    @IBAction func agreeSwitchDidChanged(_ sender: UISwitch) {
    }
    
    @IBAction func signUpTapped(_ sender: BigButton) {
        let alert = UIAlertController(title: "Welcome", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
}
