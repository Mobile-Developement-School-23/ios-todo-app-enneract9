//
//  EditorViewDelegate.swift
//  To-do-list
//
//  Created by @_@ on 05.07.2023.
//

import UIKit

protocol EditorViewDelegate: AnyObject {
    func textDidBeginEditing(textView: UITextView)
    func textDidEndEditing(textView: UITextView)
    func textDidChange(_ textView: UITextView)
    func deleteButtonDidTapped(_ todoItem: TodoItem)
}
