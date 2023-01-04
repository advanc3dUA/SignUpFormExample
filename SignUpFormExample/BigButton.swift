//
//  BigButton.swift
//  SignUpFormExample
//
//  Created by Yuriy Gudimov on 04.01.2023.
//

import UIKit

@IBDesignable
class BigButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        setBackgroundImage(image(with: .systemBlue), for: .normal)
        setBackgroundImage(image(with: .systemGray), for: .disabled)
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    }
    
    override func prepareForInterfaceBuilder() {
        setup()
    }
    
    private func image(with color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
