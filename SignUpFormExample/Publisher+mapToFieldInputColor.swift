//
//  Publisher+mapToFieldInputColor.swift
//  SignUpFormExample
//
//  Created by Yuriy Gudimov on 18.01.2023.
//

import Foundation
import Combine
import UIKit

extension Publisher where Output == Bool, Failure == Never {
    func mapToFieldInputColor() -> AnyPublisher<UIColor?, Never> {
        map { isValid -> UIColor? in
            isValid ? .label : .systemRed
        }
        .eraseToAnyPublisher()
    }
}
