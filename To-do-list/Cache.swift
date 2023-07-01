//
//  Cache.swift
//  To-do-list
//
//  Created by @_@ on 01.07.2023.
//

import Foundation

final class Cache {
    private let fileName = "TodoItems"
    private let fileCache = FileCache()
    
    lazy var todoItems: [TodoItem] = {
        try fileCache.loadFromFile(fileName: fileName)
        
        return fileCache.todoItemCollection.values as? [TodoItem] ?? []
    }()
}
