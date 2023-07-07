//
//  TodoItemCell.swift
//  To-do-list
//
//  Created by @_@ on 06.07.2023.
//

import UIKit

final class TodoItemCell: UITableViewCell {
    
    static let identifier = "TodoItemCell"
    weak var delegate: TodoItemCellDelegate?
    
    private var todoItem: TodoItem?
    
    // MARK: - UI
    private lazy var checkBox: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(checkBoxDidTapped),
                         for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private lazy var textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 7
        return stack
    }()
    
    private lazy var importanceImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        return view
    }()
    
    private lazy var textTodoLabel: UILabel = {
        let label = UILabel()
        label.text = "empty text label"
        label.font = .body
        label.textColor = .labelPrimary
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var dateStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 3.5
        stack.isHidden = true
        return stack
    }()
    
    private lazy var calendarImage: UIImageView = {
        let image = UIImage(systemName: "calendar",
                            withConfiguration: UIImage.SymbolConfiguration(pointSize: 13))

        let view = UIImageView()
        view.image = image
        view.tintColor = .supportSeparator
        view.widthAnchor.constraint(equalToConstant: 13).isActive = true
        view.contentMode = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "empty date label"
        label.font = .subhead
        label.textColor = .labelTertiary
        return label
    }()
    
    // arrow in the left of cell
    private lazy var chevron: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "chevron")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    @objc func checkBoxDidTapped() {
        guard let todoItem else { fatalError("Got nil instead todoItem in TodoItemCell when checkBox did checked") }
        
        if checkBox.isSelected {
            updateButton(with: todoItem)
        } else {
            checkBox.setImage(UIImage(named: "checked"), for: .normal)
        }
        checkBox.isSelected.toggle()
        delegate?.saveTodoItem(
            todoItem: TodoItem(
                id: todoItem.id,
                text: todoItem.text,
                importance: todoItem.importance,
                deadline: todoItem.deadline,
                isDone: !todoItem.isDone,
                dateOfChange: todoItem.dateOfChange,
                dateOfCreation: todoItem.dateOfCreation)
        )
        
    }
}

// MARK: - TodoItemCell Setup and Confuguration
extension TodoItemCell {
    private func setupSubviews() {
        contentView.addSubview(checkBox)
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(textStackView)
        mainStackView.addArrangedSubview(dateStackView)

        textStackView.addArrangedSubview(importanceImage)
        textStackView.addArrangedSubview(textTodoLabel)

        dateStackView.addArrangedSubview(calendarImage)
        dateStackView.addArrangedSubview(dateLabel)
        contentView.addSubview(chevron)
    }

    func configure(with todo: TodoItem?) {
        todoItem = todo
        guard let todoItem else { fatalError("Got nil instead TodoItem during TodoItemCell configuration") }
        if todoItem.isDone {
            textTodoLabel.attributedText = todoItem.text.attributedStringStrikedThrough
        } else {
            textTodoLabel.attributedText = todoItem.text.attributedStringEmptyAttributes
        }
        updateButton(with: todoItem)

        switch todoItem.importance {
        case .unimportant:
            importanceImage.image = UIImage(named: "unimportant")
            importanceImage.isHidden = false
        case .usual:
            importanceImage.isHidden = true
        case .important:
            importanceImage.image = UIImage(named: "important")
            importanceImage.isHidden = false
        }

        if let deadline = todoItem.deadline {
            dateStackView.isHidden = false
            dateLabel.text = deadline.toStringCropped
        } else {
            dateStackView.isHidden = true
        }

//        setupConstraints()
    }

    func updateButton(with todoItem: TodoItem?) {
        guard let todoItem else { fatalError("Error") }
        if todoItem.isDone {
            checkBox.setImage(UIImage(named: "checked"), for: .normal)
            checkBox.isSelected = true
        } else {
            if todoItem.importance == .important {
                checkBox.setImage(UIImage(named: "uncheckedImportant"), for: .normal)
            } else {
                checkBox.setImage(UIImage(named: "unchecked"), for: .normal)
            }
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkBox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            checkBox.widthAnchor.constraint(equalToConstant: 24),
            checkBox.heightAnchor.constraint(equalToConstant: 24),

            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            mainStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 12),
            mainStackView.trailingAnchor.constraint(equalTo: chevron.trailingAnchor, constant: -16),

            importanceImage.widthAnchor.constraint(equalToConstant: 11),

            chevron.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevron.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            chevron.widthAnchor.constraint(equalToConstant: 7),
            chevron.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
}
