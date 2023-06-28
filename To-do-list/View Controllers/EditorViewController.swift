//
//  EditorViewController.swift
//  To-do-list
//
//  Created by @_@
//

import UIKit

class EditorViewController: UIViewController, UITextViewDelegate {
    
    var todoItem: TodoItem?
    var keyboardHeight: CGFloat = 0
    
    var cancelButton: UIBarButtonItem?
    var saveButton: UIBarButtonItem?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .backPrimary
        return scrollView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.textContainerInset = UIEdgeInsets(top: 17, left: 16, bottom: 12, right: 16)
        textView.backgroundColor = .backSecondary
        textView.isScrollEnabled = false
        textView.layer.cornerRadius = 16
        textView.font = .body
        textView.text = "Что надо сделать?"
        textView.textColor = .labelTertiary
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var importanceAndDeadlineView = ImportanceAndDeadlineView()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(.labelTertiary, for: .disabled)
        button.titleLabel?.font = .body
        button.backgroundColor = .backSecondary
        button.layer.cornerRadius = 16
        button.isEnabled = false
        button.addTarget(self, action: #selector(deleteButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(keyboardShowNotification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        
        setupNavBar()
        checkTodoItem()
        setupView()
        setConstraints()
    }
    
    func checkTodoItem() {
        guard let todoItem else {
            return
        }
        
        textView.text = todoItem.text
        textView.textColor = .labelPrimary
        
        if todoItem.importance == .unimportant {
            importanceAndDeadlineView.importanceSegmentedControl.selectedSegmentIndex = 0
        } else if todoItem.importance == .usual {
            importanceAndDeadlineView.importanceSegmentedControl.selectedSegmentIndex = 1
        } else {
            importanceAndDeadlineView.importanceSegmentedControl.selectedSegmentIndex = 2
        }
        
        if let deadline = todoItem.deadline {
            importanceAndDeadlineView.deadline = deadline
            importanceAndDeadlineView.datePicker.date = deadline
            importanceAndDeadlineView.deadlineButton.setTitle(deadline.toString, for: .normal)
            importanceAndDeadlineView.deadlineSwitch.isOn = true
            importanceAndDeadlineView.showDeadlineButton(bool: true)
        }
        saveButton?.tintColor = .blue
        
        deleteButton.isEnabled = true
    }
    
    func setupView() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(importanceAndDeadlineView)
        stackView.addArrangedSubview(deleteButton)
    }
    
    func setupNavBar() {
        self.title = "Дело"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.headline]
        view.backgroundColor = .backPrimary
        
        cancelButton = UIBarButtonItem(
            title: "Отменить",
            style: .plain,
            target: self,
            action: #selector(cancel)
        )
        
        saveButton = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(save)
        )
        
        cancelButton?.tintColor = .blue
        saveButton?.tintColor = .labelTertiary
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    @objc func save() {
        let fc = FileCache()
        var importance: TodoItem.Importance = .usual
        
        switch importanceAndDeadlineView.importanceSegmentedControl.selectedSegmentIndex {
        case 0: importance = .unimportant
        case 1: importance = .important
        default: importance = .usual
        }
        
        let todo = TodoItem(
            text: textView.text,
            importance: importance,
            deadline: importanceAndDeadlineView.deadlineSwitch.isOn ? importanceAndDeadlineView.datePicker.date : nil
        )
        fc.addTodoItem(todoItem: todo)
        try? fc.saveToFile(fileName: "TodoItems")
        todoItem = todo
        dismiss(animated: true)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor?.cgColor == UIColor.labelTertiary.cgColor {
            textView.text = nil
            textView.textColor = .labelPrimary
            saveButton?.isEnabled = true
            saveButton?.tintColor = .blue
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = .labelTertiary
            saveButton?.isEnabled = false
            saveButton?.tintColor = .labelTertiary
        }
        
        scrollView.contentInset = UIEdgeInsets(
            top: 0, left: 0, bottom: 0, right: 0
        )
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func deleteButtonDidTapped() {
        let fc = FileCache()
        try? fc.loadFromFile(fileName: "TodoItems")
        _ = fc.removeTodoItem(id: "1")
        try? fc.saveToFile(fileName: "TodoItems")
        todoItem = nil
        resetButtons()
        importanceAndDeadlineView.showDeadlineButton(bool: false)
        dismiss(animated: true)
    }
    
    @objc func keyboardDidShow(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardRectangle.height
            scrollView.contentInset = UIEdgeInsets(
                top: 0, left: 0, bottom: keyboardHeight, right: 0
            )
        }
    }
    
    func resetButtons() {
        saveButton?.isEnabled = false
        textView.text = "Что надо сделать?"
        textView.textColor = .labelTertiary
        importanceAndDeadlineView.importanceSegmentedControl.selectedSegmentIndex = 1
        importanceAndDeadlineView.datePicker.date = Date()
        importanceAndDeadlineView.deadlineSwitch.isOn = false
        deleteButton.isEnabled = false
    }
    
}


extension EditorViewController {
    func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight),
            
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32),
            
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120),
            
            deleteButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}
