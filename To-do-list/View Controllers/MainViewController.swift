//
//  MainViewController.swift
//  To-do-list
//
//  Created by @_@ on 05.07.2023.
//

import UIKit

final class MainViewController: UIViewController, MainViewDelegate {
    
    let fileCache = FileCache()
    private var todoItems: [TodoItem] = []
    private var mainView: MainView?
    let fileName = "Cache"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        updateData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        updateData()
    }
    
    func updateData() {
        try? fileCache.loadFromFile(fileName: fileName)
        todoItems = Array(fileCache.todoItemCollection.values).sorted(by: { $0.dateOfCreation >= $1.dateOfCreation } )
        mainView?.updateData(todoItems: todoItems)
        
//                print("\n_ _ _ _ _ _ _ _ _ _ _ _ READING _ _ _ _ _ _ _ _ _ _ _ _")
//                print(todoItems)
//                print("_ _ _ _ _ _ _ _ _ _ _ _ READING _ _ _ _ _ _ _ _ _ _ _ _\n")
    }

// MARK: - MainViewDelegate conformation
    // presents EditorView with empty todoItem (in users attempt to create new - pushed last creation cell in tableView or blue creation button)
    func createButtonDidTapped() {
        let editorViewController = EditorViewController(todoItem: nil)
        editorViewController.delegate = self
        let navController = UINavigationController(rootViewController: editorViewController)
        present(navController, animated: true)
    }
    
    // presents EditorView with todoItem from selected tableView cell from MainView (in users attempt to edit todoItem)
    func didSelectTodoItem(_ todoItem: TodoItem?) {
        let editorViewController = EditorViewController(todoItem: todoItem)
        editorViewController.delegate = self
        let navController = UINavigationController(rootViewController: editorViewController)
        present(navController, animated: true)
    }
    
    // saves todoItem to fileCache .json file when (save in editor view performs in EditorViewController)
    func saveTodoItem(_ todoItem: TodoItem) {
        
        fileCache.addTodoItem(todoItem: todoItem)
        try? fileCache.saveToFile(fileName: fileName)
//        print("\n_ _ _ _ _ _ _ _ _ _ _ _ WRITING _ _ _ _ _ _ _ _ _ _ _ _")
//        print(fileCache.todoItemCollection)
//        print("_ _ _ _ _ _ _ _ _ _ _ _ WRITING _ _ _ _ _ _ _ _ _ _ _ _\n")
        updateData()
    }
    
    // deletes todoItem from fileCache .json file in result of trailing swipe of cell in tableView (deletion in editor view performs in EditorViewController)
    func deleteTodoItem(_ todoItem: TodoItem) {
        _ = fileCache.removeTodoItem(id: todoItem.id)
        try? fileCache.saveToFile(fileName: fileName)
        updateData()
    }
}

extension MainViewController {
    func setupViews() {
        // MainView setup
        mainView = MainView(todoItems: self.todoItems)
        mainView?.delegate = self
        view = mainView
        view.backgroundColor = .backPrimary
        
        // Navigation bar setup
        title = "Мои дела"
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.layoutMargins = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 0)
    }
}
