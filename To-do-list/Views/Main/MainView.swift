//
//  MainView.swift
//  To-do-list
//
//  Created by @_@ on 05.07.2023.
//

import UIKit

final class MainView: UIView {
    
    weak var delegate: MainViewDelegate?
    var todoItems: [TodoItem]
    var undoneTodoItems: [TodoItem]
    var isShowingDone: Bool = true
    
    private lazy var doneStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()
    
    private lazy var doneCountLabel: UILabel = {
        let label = UILabel()
        label.text = "Выполнено — {0}"
        label.font = .body
        label.textColor = .labelTertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var showDoneTasksButton: UIButton = {
        let button = UIButton(type: .custom)
        let title = isShowingDone ? "Скрыть" : "Показать"
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .headline
        button.addTarget(self, action: #selector(showDoneTasksButtonDidTapped), for: .touchUpInside)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
//    Creation button that presents EditorViewController
    let createButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "createButton"), for: .normal) // TODO: SF Symbols
        button.layer.cornerRadius = 0.5 * 44
        button.layer.shadowColor = UIColor(red: 0/255, green: 49/255, blue: 102/255, alpha: 0.30).cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowOpacity = 0.5
        button.addTarget(nil, action: #selector(createButtonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.safeAreaLayoutGuide.layoutFrame.width, height: self.safeAreaLayoutGuide.layoutFrame.height), style: .grouped)
        
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 98
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 52, bottom: 0.0, right: 0)
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: TodoItemCell.identifier)
        tableView.register(CreationCell.self, forCellReuseIdentifier: CreationCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    init(todoItems: [TodoItem]) {
        self.todoItems = todoItems
        self.undoneTodoItems = todoItems.filter({!$0.isDone})
        
        super.init(frame: .zero)
        setupSubViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    // Updates data in MainViewController when show button in tableView header did tapped
    @objc func showDoneTasksButtonDidTapped() {
        isShowingDone.toggle()
        showDoneTasksButton.setTitle(isShowingDone ? "Скрыть" : "Показать", for: .normal)
        let vc = delegate as? MainViewController
        vc?.updateData()
    }
    
    @objc func createButtonDidTapped() {
        delegate?.createButtonDidTapped()
    }
    
    func updateDoneCountLabel(count: Int) {
        doneCountLabel.text = "Выполнено - \(count)"
    }
    
    func cellDidTapped(indexPath: IndexPath) {
        if (isShowingDone && indexPath.row == todoItems.count) || (!isShowingDone && indexPath.row == undoneTodoItems.count) {
            delegate?.createButtonDidTapped()
        } else {
            delegate?.didSelectTodoItem(isShowingDone ? todoItems[indexPath.row] : undoneTodoItems[indexPath.row])
        }
    }
    
    func updateData(todoItems: [TodoItem]) {
        self.todoItems = todoItems
        self.undoneTodoItems = todoItems.filter( {!$0.isDone} )
        tableView.reloadData()
        updateDoneCountLabel(count: self.todoItems.count - self.undoneTodoItems.count)
    }
    
    func updateTodoItemWithToggledIsDone(todoItem: TodoItem) {
        delegate?.saveTodoItem(TodoItem(
            id: todoItem.id,
            text: todoItem.text,
            importance: todoItem.importance,
            deadline: todoItem.deadline,
            isDone: !todoItem.isDone,
            dateOfChange: todoItem.dateOfChange,
            dateOfCreation: todoItem.dateOfCreation)
        )
    }
    
    func deleteTodoItem(todoItem: TodoItem) {
        delegate?.deleteTodoItem(todoItem)
    }
}

extension MainView {
    private func setupSubViews() {
        
        self.addSubview(tableView)
        self.addSubview(createButton)
        
        doneStackView.addArrangedSubview(doneCountLabel)
        doneStackView.addArrangedSubview(showDoneTasksButton)
    }
}

extension MainView {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            createButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 44),
            createButton.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}


// MARK: - UITableViewDelegate conformance
extension MainView: UITableViewDelegate {
    
    // Cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.17) {
            guard let selectedCell = tableView.cellForRow(at: indexPath) else {
                fatalError("Error appearing while selecting cell. Check UITableView conformance - didSelectRowAt.")
            }
            selectedCell.transform = CGAffineTransform(scaleX: 1.033, y: 1.033)
        } completion: { _ in
            UIView.animate(withDuration: 0.17) {
                guard let selectedCell = tableView.cellForRow(at: indexPath) else {
                    fatalError("Error appearing while selecting cell. Check UITableView conformance - didSelectRowAt.")
                }
                selectedCell.transform = .identity
                tableView.deselectRow(at: indexPath, animated: true)
            }
            
            self.cellDidTapped(indexPath: indexPath)
        }
    }
    
    // Rounding corners of cells
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var roundingCorners: UIRectCorner
        if tableView.isFirstRow(indexPath) && tableView.isLastRow(indexPath) {
            roundingCorners = [.topLeft, .topRight, .bottomLeft, .bottomRight]
        } else if tableView.isFirstRow(indexPath) {
            roundingCorners = [.topLeft, .topRight]
        } else if tableView.isLastRow(indexPath) {
            roundingCorners = [.bottomLeft, .bottomRight]
        } else {
            roundingCorners = []
        }
        
        cell.roundCorners(corners: roundingCorners, radius: 16)
    }
    
    // Getting height for each cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    // Getting header for tableView
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(doneStackView)
        headerView.addSubview(spacer)
        
        NSLayoutConstraint.activate([
            doneStackView.topAnchor.constraint(equalTo: headerView.topAnchor),
            doneStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            doneStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            doneStackView.heightAnchor.constraint(equalToConstant: 20),
            doneStackView.widthAnchor.constraint(equalTo: headerView.widthAnchor, constant: -32),
            
            spacer.leadingAnchor.constraint(equalTo: doneStackView.leadingAnchor),
            spacer.trailingAnchor.constraint(equalTo: doneStackView.trailingAnchor),
            spacer.topAnchor.constraint(equalTo: doneStackView.bottomAnchor),
            spacer.heightAnchor.constraint(equalToConstant: 12),
            spacer.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
        ])
        
        return headerView
    }
    
    // Getting height for tableView header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    // Managing cell swipes
    // Leading swipe
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Last cell that don't have swipes
        if (indexPath.row == todoItems.count && isShowingDone) || (indexPath.row == undoneTodoItems.count && !isShowingDone) {
            return nil
        }

        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completion) in
            guard let self = self else { return }
            let todoItem: TodoItem = isShowingDone ? todoItems[indexPath.row] : undoneTodoItems[indexPath.row]
            updateTodoItemWithToggledIsDone(todoItem: todoItem)
            completion(true)
        }

        action.image = UIImage(systemName: "checkmark.circle.fill")
        action.image?.withTintColor(.white)
        action.backgroundColor = .systemGreen

        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // Trailing swipe
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Last cell that don't have swipes
        if (indexPath.row == todoItems.count && isShowingDone) || (indexPath.row == undoneTodoItems.count && !isShowingDone) {
            return nil
        }

        let action = UIContextualAction(style: .normal, title: nil) { [weak self] (_, _, completion) in
            guard let self = self else { return }
            let todoItem: TodoItem = isShowingDone ? todoItems[indexPath.row] : undoneTodoItems[indexPath.row]
            deleteTodoItem(todoItem: todoItem)
            completion(true)
        }

        action.image = UIImage(systemName: "trash.fill")
        action.image?.withTintColor(.white)
        action.backgroundColor = .systemRed

        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // Context menu configuration
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            guard tableView.cellForRow(at: indexPath) is TodoItemCell else { return nil }
            
            let accomlish = UIAction(title: "Отметить", image: UIImage(systemName: "checkmark.circle.fill")) { _ in
                self.updateTodoItemWithToggledIsDone(todoItem: self.isShowingDone ? self.todoItems[indexPath.row] : self.undoneTodoItems[indexPath.row])
            }
            let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.cellDidTapped(indexPath: indexPath)
            }
            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash.fill")) { _ in
                self.deleteTodoItem(todoItem: self.isShowingDone ? self.todoItems[indexPath.row] : self.undoneTodoItems[indexPath.row])
            }

            let menu = UIMenu(children: [accomlish, edit, delete])

            return menu
        }

        return configuration
    }
}

// MARK: - UITableViewDatasource conformance
extension MainView: UITableViewDataSource {
    // number of sections
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (isShowingDone ? todoItems.count : undoneTodoItems.count) + 1
    }
    
    // setting tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { 
        if (isShowingDone && indexPath.row == todoItems.count) || (!isShowingDone && indexPath.row == undoneTodoItems.count) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CreationCell.identifier, for: indexPath) as? CreationCell else {
                fatalError("Can not set CreationCell for tableView")
            }
            cell.backgroundColor = .backSecondary
            cell.selectionStyle = .none
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoItemCell.identifier, for: indexPath) as? TodoItemCell else {
                fatalError("Can not set TodoItemCell for tableView")
            }
            cell.backgroundColor = .backSecondary
            cell.selectionStyle = .none
            cell.delegate = self
            cell.configure(with: isShowingDone ? todoItems[indexPath.row] : undoneTodoItems[indexPath.row])
            
            return cell
        }
    }
}

extension MainView: TodoItemCellDelegate {
    func saveTodoItem(todoItem: TodoItem) {
        delegate?.saveTodoItem(todoItem)
    }
}
