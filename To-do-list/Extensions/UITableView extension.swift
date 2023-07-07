//
//  UITableView extension.swift
//  To-do-list
//
//  Created by @_@ on 05.07.2023.
//

import UIKit

extension UITableView {
    func isFirstRow(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == 0
    }

    func isLastRow(_ indexPath: IndexPath) -> Bool {
        let lastSectionIndex = numberOfSections - 1
        let lastRowIndex = numberOfRows(inSection: lastSectionIndex) - 1
        return indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex
    }
}
