//
//  CreationCell.swift
//  To-do-list
//
//  Created by @_@ on 01.07.2023.
//

import UIKit

final class CreationCell: UITableViewCell {
    
    static let identifier = "CreationCell"
    
    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        var image = UIImage(systemName: "plus.circle.fill")?.withRenderingMode(.alwaysOriginal) ?? UIImage()
        image = image.withTintColor(.backPrimary)
        
        imageView.image = image
        
        imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Новое"
        label.numberOfLines = 1
        label.font = .body
        label.textColor = .labelTertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(icon)
        addSubview(label)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            icon.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
