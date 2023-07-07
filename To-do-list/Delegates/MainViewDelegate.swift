//
//  MainViewDelegate.swift
//  To-do-list
//
//  Created by @_@ on 05.07.2023.
//

import UIKit

protocol MainViewDelegate: AnyObject {
    func createButtonDidTapped()
    func didSelectTodoItem(_ todoItem: TodoItem?)
    func saveTodoItem(_ todoItem: TodoItem)
    func deleteTodoItem(_ todoItem: TodoItem)
}
