//
//  SignUpFormExampleTests.swift
//  SignUpFormExampleTests
//
//  Created by Yuriy Gudimov on 03.02.2023.
//

import XCTest
import Combine
@testable import SignUpFormExample

final class SignUpFormExampleTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var viewModel: SignUpViewModel!

    
    override func setUp() {
        super.setUp()
        cancellables = []
        viewModel = SignUpViewModel()
    }
    
    override func tearDown() {
        super.tearDown()
        cancellables = nil
    }
    
    func testValidEmail() {
        var validEmailSignal: Bool?
        viewModel.emailIsValid
            .sink { validEmailSignal = $0 }
            .store(in: &cancellables)
        viewModel.email = "foo"
        XCTAssertEqual(validEmailSignal, false)
        
        viewModel.email = "foo@bar.com"
        XCTAssertEqual(validEmailSignal, true)
    }
}
