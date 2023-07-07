//
//  MainViewController.swift
//  To-do-list
//
//  Created by @_@ on 29.06.2023.
//

import UIKit

final class MainViewController2: UIViewController {
    
    // MARK: - Properties
    
    private let fileName = "TodoItems"
    private let fileCache = FileCache()
    
    lazy var todoList: [TodoItem] = {
        do {
            try fileCache.loadFromFile(fileName: fileName)
        } catch {
            print(error.localizedDescription)
        }

        let list = Array(fileCache.todoItemCollection.values)

        return list.sorted(by: { $0.dateOfCreation > $1.dateOfCreation } )
    }()
    
    lazy var notDoneTodoList: [TodoItem] = {
        return todoList.filter( { !$0.isDone } )
    }() {
        didSet {
            doneCount = self.todoList.count - notDoneTodoList.count
        }
    }
    
    private var doneCount = 0 {
        didSet {
            doneCountLabel.text = "Выполнено — \(doneCount)"
        }
    }
    
    private lazy var tableCollection: [TodoItem] = self.todoList {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var isDoneTasksShown = false {
        didSet {
            let title = isDoneTasksShown ? "Cкрыть" : "Показать"
            showDoneTasksButton.setTitle(title, for: .normal)
        }
    }
    
    // MARK: - UI
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
        label.text = "Выполнено — \(doneCount)"
        label.font = .body
        label.textColor = .labelTertiary
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var showDoneTasksButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Показать", for: .normal)
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
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.safeAreaLayoutGuide.layoutFrame.height), style: .grouped)
        
        tableView.backgroundColor = .clear
        tableView.estimatedRowHeight = 98
        
        tableView.separatorInset = UIEdgeInsets(top: 0.0, left: 52, bottom: 0.0, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: "todoItemCell")
        tableView.register(CreationCell.self, forCellReuseIdentifier: "creationcell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backPrimary
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Мои дела"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupSubViews()
        setupConstraints()
        
        
        try! fileCache.saveToFile(fileName: fileName)
    }
    
    //MARK: - Methods
    @objc func showDoneTasksButtonDidTapped() {
        isDoneTasksShown.toggle()
        tableCollection = isDoneTasksShown ? todoList : notDoneTodoList
    }
    
    @objc func createButtonDidTapped() {
        
    }
}

// MARK: - Views setup
extension MainViewController2 {
    private func setupSubViews() {
        view.addSubview(createButton)
        view.addSubview(tableView)
        
        doneStackView.addArrangedSubview(doneCountLabel)
        doneStackView.addArrangedSubview(showDoneTasksButton)
    }
}

extension MainViewController2 {
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            createButton.widthAnchor.constraint(equalToConstant: 44),
            createButton.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableView conformance
extension MainViewController2: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        var shapePath: UIBezierPath
        
        switch indexPath.row {
        case 0:
            shapePath = UIBezierPath(
                roundedRect: cell.bounds,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: CGSize(width: 16, height: 16))
        case todoList.count:
            shapePath = UIBezierPath(
                roundedRect: cell.bounds,
                byRoundingCorners: [.bottomLeft, .bottomRight],
                cornerRadii: CGSize(width: 16, height: 16))
        default:
            shapePath = UIBezierPath(
                roundedRect: cell.bounds,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: CGSize(width: 0, height: 0))
        }
        let shape = CAShapeLayer()
        shape.path = shapePath.cgPath
        cell.layer.mask = shape
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
}

extension MainViewController2: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //TODO: as!
        if indexPath.row == todoList.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "creationcell", for: indexPath) as! CreationCell 
            
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath) as! TodoItemCell
            let currentTodoItem = tableCollection[indexPath.row]
            cell.todoItem = currentTodoItem
            
            return cell
        }
    }
}
