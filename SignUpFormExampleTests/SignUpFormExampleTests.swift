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
    
    func assertPublisher<P: Publisher>(_ publisher: P, producesExactly expected: P.Output..., block: () -> Void) where P.Failure == Never, P.Output: Equatable {
        let exp = expectation(description: "Publisher received value")
        exp.assertForOverFulfill = false
        
        //Arrange
        var value: [P.Output] = []
        publisher
            .handleEvents(receiveCompletion: { _ in
                exp.fulfill()
            })
            
            .sink {
                exp.fulfill()
                value.append($0)
            }
            .store(in: &cancellables)
        
        //Act
        block()
        
        wait(for: [exp], timeout: 1.0)
        
        //Assertion
        XCTAssertEqual(value, expected)
    }
    
    func assertPublisher<P: Publisher>(_ publisher: P, produces expected: P.Output, block: () -> Void) where P.Failure == Never, P.Output: Equatable {
        let exp = expectation(description: "Publisher received value")
        exp.assertForOverFulfill = false
        
        //Arrange
        var value: P.Output?
        publisher
            .handleEvents(receiveCompletion: { _ in
                exp.fulfill()
            })
            
            .sink {
                exp.fulfill()
                value = $0
            }
            .store(in: &cancellables)
        
        //Act
        block()
        
        wait(for: [exp], timeout: 1.0)
        
        //Assertion
        XCTAssertEqual(value, expected)
    }
    
    func testValidEmail() {
        assertPublisher(viewModel.emailIsValid, produces: true) {
            viewModel.email = "foo@bar.com"
        }
    }
    
    func testInvalidEmail() {
        assertPublisher(viewModel.emailIsValid, produces: false) {
            viewModel.email = "foo"
        }
    }
    
    func testPasswordIsValid() {
        assertPublisher(viewModel.passwordIsValid, produces: true) {
            viewModel.password = "123123123"
        }
    }
    
    func testPasswordIsInvalid() {
        assertPublisher(viewModel.passwordIsValid, produces: false) {
            viewModel.password = "123"
        }
    }
    
    func testPasswordMatchesConfirmation() {
        assertPublisher(viewModel.passwordConfirmationIsVaild.dropFirst(2), producesExactly: false, true) {
            viewModel.password = "123123123"
            viewModel.passwordConfirmation = "12312312"
            viewModel.passwordConfirmation = "123123123"
        }
    }
    
    func testFormIsValid() {
        var formIsValidSignal: Bool?
        viewModel.formIsValid
            .sink {
                formIsValidSignal = $0
            }
            .store(in: &cancellables)
        
        viewModel.email = "invalid"
        viewModel.password = "invalid"
        viewModel.passwordConfirmation = "invalid2"
        viewModel.agreeTerms = false
        XCTAssertEqual(formIsValidSignal, false)
        
        viewModel.email = "123123@123.com"
        viewModel.password = "validpassowrd"
        viewModel.passwordConfirmation = "validpassowrd"
        viewModel.agreeTerms = true
        XCTAssertEqual(formIsValidSignal, true)
    }
}
