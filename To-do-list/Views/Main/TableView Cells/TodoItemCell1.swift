//
//  TodoItemCell.swift
//  To-do-list
//
//  Created by @_@ on 29.06.2023.
//

import UIKit

final class TodoItemCell1: UITableViewCell {
    
    static let identifier = "TodoItemCell1"
    weak var delegate: TodoItemCellDelegate?
    
    public var todoItem: TodoItem? {
        didSet {
            self.deadline = todoItem?.deadline
            self.todoText = todoItem?.text ?? ""
            self.importance = todoItem?.importance ?? .usual
            self.isImportant = todoItem?.importance == .important
            self.isDone = todoItem?.isDone ?? false
        }
    }
    
    private var deadline: Date? = nil {
        didSet {
            deadlineDateLabel.text = deadline?.toStringCropped
            
            switch deadline == nil {
            case true:
                calendarIcon.removeFromSuperview()
                deadlineDateLabel.removeFromSuperview()
                
                todoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = false
                todoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
                
                todoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
            case false:
                addSubview(calendarIcon)
                addSubview(deadlineDateLabel)
                
                todoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = false
                todoLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
                
                todoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = false
            }
        }
    }
    private var todoText: String = "" {
        didSet {
            let attText = NSMutableAttributedString(string: todoText)
            if isDone {
                attText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attText.length))
            }
            todoLabel.attributedText = attText
        }
    }
    private var importance: TodoItem.Importance = .usual {
        didSet {
            switch self.importance {
            case .important:
                importanceIcon.image = UIImage(named: "important")
                addSubview(importanceIcon)
                todoLabel.leadingAnchor.constraint(equalTo: importanceIcon.trailingAnchor, constant: 2).isActive = true
            case .usual:
                importanceIcon.image = nil
                importanceIcon.removeFromSuperview()
                todoLabel.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 12).isActive = true
            case .unimportant:
                importanceIcon.image = UIImage(named: "low")
                addSubview(importanceIcon)
                todoLabel.leadingAnchor.constraint(equalTo: importanceIcon.trailingAnchor, constant: 2).isActive = true
            }
        }
    }
    
    private var isImportant: Bool = false {
        didSet {
            checkBox.isImportant = isImportant
        }
    }
    private var isDone: Bool = false {
        didSet {
            todoLabel.textColor = isDone ? .labelTertiary : .labelPrimary
            
            let attText = NSMutableAttributedString(string: todoText)
            if isDone {
                attText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attText.length))
            }
            todoLabel.attributedText = attText
//            checkBox.checked = isDone
            checkbox2.isChecked = isDone
//            todoItem?.isDone = isDone
        }
    }
    
    // MARK: - UI
    private lazy var checkBox: Checkbox = {
        let checkBox = Checkbox(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        checkBox.checked = self.isDone
        checkBox.isImportant = self.isImportant
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.addTarget(self, action: #selector(checkBoxChecked), for: .touchUpInside) // TODO: !!!!!!!!!!!!!!!!!!!
        checkBox.isUserInteractionEnabled = true
        
        return checkBox
    }()
    
    private lazy var checkbox2: Checkbox2 = {
        let checkbox = Checkbox2()
        checkbox.isChecked = self.isDone
        checkbox.isImportant = self.isImportant
        checkbox.isUserInteractionEnabled = true
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.addTarget(self, action: #selector(checkBoxChecked), for: .touchUpInside)
        
        return checkbox
    }()
    
    private lazy var importanceIcon: UIImageView = { // !!
        let imageView = UIImageView()
        
        switch self.importance {
        case .important:
            imageView.image = UIImage(named: "important")
        case .usual:
            imageView.image = nil
        case .unimportant:
            imageView.image = UIImage(named: "low")
        }
        
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        
        return imageView
    }()
    
    private lazy var todoLabel: UILabel = { // TODO: 3 строки
        let label = UILabel()
        let attText = NSMutableAttributedString(string: todoText)
        label.textColor = isDone ? .labelTertiary : .labelPrimary
        if isDone {
            attText.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attText.length))
        }
        label.attributedText = attText
        label.numberOfLines = 3
        label.font = .body
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var calendarIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "calendar") //?.withTintColor(.labelTertiary) // TODO: SF
        imageView.contentMode = .scaleAspectFit
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 13).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
        
        return imageView
    }()
    
    private lazy var deadlineDateLabel: UILabel = {
        let label = UILabel()
        label.text = deadline?.toStringCropped
        label.numberOfLines = 1
        label.font = .body
        label.textColor = .labelTertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Methods
    @objc func checkBoxChecked() {
        guard let todoItem = todoItem else {
            fatalError("no todoitem")
        }
        self.isDone.toggle()
        delegate?.saveTodoItem(todoItem: todoItem)
        print("aaaaa")
    }

    // MARK: - Life cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - TableViewCell setup
private extension TodoItemCell1 {
    func setupSubviews() {
        addSubview(checkBox)
        addSubview(importanceIcon)
        addSubview(todoLabel)
        addSubview(calendarIcon)
        addSubview(deadlineDateLabel)
    }
}

private extension TodoItemCell1 {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            
            checkBox.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            importanceIcon.centerYAnchor.constraint(equalTo: todoLabel.centerYAnchor),
            importanceIcon.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 12),
            
            todoLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            calendarIcon.leadingAnchor.constraint(equalTo: checkBox.trailingAnchor, constant: 12),
            calendarIcon.centerYAnchor.constraint(equalTo: deadlineDateLabel.centerYAnchor),
            
            deadlineDateLabel.topAnchor.constraint(equalTo: todoLabel.bottomAnchor),
            deadlineDateLabel.leadingAnchor.constraint(equalTo: calendarIcon.trailingAnchor, constant: 2),
            deadlineDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            deadlineDateLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)
        ])
    }
}
