//
//  Checkbox2.swift
//  To-do-list
//
//  Created by @_@ on 06.07.2023.
//

import UIKit

final class Checkbox2: UIButton {
    
    // images:
    private let uncheckedImportantImage = UIImage(named: "uncheckedImportant") ?? UIImage()
    private let uncheckedImage = UIImage(named: "unchecked") ?? UIImage()
    private let checkedImage = UIImage(named: "checked") ?? UIImage()
    
    public var isChecked: Bool = false {
        didSet {
            self.setImage(isChecked ? checkedImage : isImportant ? uncheckedImportantImage : uncheckedImage, for: .normal)
        }
    }
    
    public var isImportant: Bool = false {
        didSet {
            self.setImage(isChecked ? checkedImage : isImportant ? uncheckedImportantImage : uncheckedImage, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 24),
            heightAnchor.constraint(equalToConstant: 24),
        ])
        
        self.backgroundColor = .clear
        self.setImage(isChecked ? checkedImage : isImportant ? uncheckedImportantImage : uncheckedImage, for: .normal)
    }
}
