//
//  Checkbox.swift
//  To-do-list
//
//  Created by @_@ on 29.06.2023.
//

import UIKit

final class Checkbox: UIControl {
    
    // images:
    private let uncheckedImportantImage = UIImage(named: "uncheckedImportant") ?? UIImage()
    private let uncheckedImage = UIImage(named: "unchecked") ?? UIImage()
    private let checkedImage = UIImage(named: "checked") ?? UIImage()
    
    private weak var imageView: UIImageView!
    
    public var checked: Bool = false
    
    public var isImportant: Bool = false {
        didSet {
            imageView.image = checked ? checkedImage : isImportant ? uncheckedImportantImage : uncheckedImage
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
//            widthAnchor.constraint(equalToConstant: 24),
//            heightAnchor.constraint(equalToConstant: 24),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        imageView.image = checked ? checkedImage : isImportant ? uncheckedImportantImage : uncheckedImage
        imageView.contentMode = .scaleAspectFit
        
        self.imageView = imageView
        
        backgroundColor = .clear
        
        addTarget(self, action: #selector(checkboxDidTouched), for: .touchUpInside)
    }
    
    @objc func checkboxDidTouched() {
        checked.toggle()
        updateCheckbox()
        sendActions(for: .valueChanged)
    }
    
    func updateCheckbox() {
        imageView.image = checked ? checkedImage : isImportant ? uncheckedImportantImage : uncheckedImage
    }
}
