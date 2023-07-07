//
//  EditorViewController.swift
//  To-do-list
//
//  Created by @_@
//

import UIKit

final class EditorViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    private let todoItem: TodoItem?
    private var editorView: EditorView?
    weak var delegate: MainViewController?
    
    // MARK: - Lifecycle
    init(todoItem: TodoItem?) {
        self.todoItem = todoItem

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.updateData()
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        view.setNeedsUpdateConstraints()
    }
    
    // action for left button in navBar
    @objc private func cancelButtonDidTapped() {
        dismiss(animated: true)
    }
    
    // action for right button in navBar
    @objc private func saveButtonDidTapped() {
        var importance: TodoItem.Importance = .usual
        switch editorView?.importanceAndDeadlineView.importanceSegmentedControl.selectedSegmentIndex {
        case 0: importance = .unimportant
        case 1: importance = .usual
        default: importance = .important
        }
        let todoItem = TodoItem(
            id: todoItem?.id ?? UUID().uuidString,
            text: editorView?.textView.text ?? "Error",
            importance: importance,
            deadline: (editorView?.importanceAndDeadlineView.deadlineSwitch.isOn ?? false) ? editorView?.importanceAndDeadlineView.datePicker.date : nil
        )
        _ = delegate?.fileCache.addTodoItem(todoItem: todoItem)
        try? delegate?.fileCache.saveToFile(fileName: "Cache")
        dismiss(animated: true)
    }
}

// MARK: - EditorViewDelegate conformance
extension EditorViewController: EditorViewDelegate {

    // Avoiding saving text of todoItem with extra spaces
    func textDidChange(_ textView: UITextView) {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        if !trimmedText.isEmpty { // enable save button in navBar
            if let rightButton = navigationItem.rightBarButtonItem {
                rightButton.isEnabled = true
                rightButton.tintColor = .blue
            }
        } else { // disable save button in navBar
            if let rightButton = navigationItem.rightBarButtonItem {
                rightButton.isEnabled = false
                rightButton.tintColor = .labelTertiary
            }
        }
    }

    // Placeholder deleton when user start to edit text to textView
    func textDidBeginEditing(textView: UITextView) {
        if textView.textColor?.cgColor == UIColor.labelTertiary.cgColor {
            textView.text = nil
            textView.textColor = .labelPrimary
        }
    }

    // Additing placeholder when user stops editing text in textView and text is empty
    func textDidEndEditing(textView: UITextView) {
        let trimmedText = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)

        if textView.text.isEmpty {
            textView.text = "Что надо сделать?"
            textView.textColor = .labelTertiary
        }
        if trimmedText.isEmpty { // disable save button in navBar
            if let rightButton = navigationItem.rightBarButtonItem {
                rightButton.isEnabled = false
                rightButton.tintColor = .labelTertiary
            }
        }
    }

    func deleteButtonDidTapped(_ todoItem: TodoItem) {
        // TODO: Перенести это все в главный контроллер, чтобы не плодить экземпляры FileCache
        _ = delegate?.fileCache.removeTodoItem(id: todoItem.id)
        try? delegate?.fileCache.saveToFile(fileName: "Cache")
        dismiss(animated: true)
    }
}

// MARK: Setting up Editor view
extension EditorViewController {
    private func setupView() {
        editorView = EditorView(todoItem: todoItem)
        editorView?.delegate = self
        view = self.editorView
    }
    
    // Setting up navigation bar
    private func setupNavBar() {
        title = "Дело"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.headline]
        view.backgroundColor = .backPrimary

        let cancelButton = UIBarButtonItem(
            title: "Отменить",
            style: .plain,
            target: self,
            action: #selector(cancelButtonDidTapped)
        )

        let saveButton = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: #selector(saveButtonDidTapped)
        )

        cancelButton.tintColor = .blue
        if todoItem != nil {
            saveButton.isEnabled = true
            saveButton.tintColor = .blue
        } else {
            saveButton.isEnabled = false
            saveButton.tintColor = .labelTertiary
        }

        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
}
