//
//  TodoItemCellDelegate.swift
//  To-do-list
//
//  Created by @_@ on 05.07.2023.
//

import UIKit

protocol TodoItemCellDelegate: AnyObject {
    func saveTodoItem(todoItem: TodoItem)
}
