//
//  FileCache.swift
//  To-do-list
//
//  Created by @_@
//

import Foundation


class FileCache {
    private(set) public var todoItemCollection: [String:TodoItem] = [:]
    
    func addTodoItem(todoItem: TodoItem) {
        
        /*
         Функция добавления новой задачи
         Предусмотреть механизм защиты от дублирования задач (сравниванием id)
         Если в функцию добавления новой задачи приходит новый TodoItem с тем же id, мы перезаписываем данные в старый, то есть обновляем уже существующий адрес с таким id
         */
        
        todoItemCollection[todoItem.id] = todoItem
    }
    
    func removeTodoItem(id: String) -> TodoItem? {
        
        /*
         Функция удаления задачи (на основе id)
         */
        
        return todoItemCollection.removeValue(forKey: id)
    }
    
    func saveToFile(fileName: String) throws {
        
        /*
         Функция сохранения всех дел в файл (.documentDirectory)
         Вход: имя файла
         Если файл с таким названием уже существует, он перезаписывается.
         Если нет, то создаётся новый с нужным названием.
         */
        
        let fileManager = FileManager.default
        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheErrors.cannotFindSystemDirectory
        }
        
        let path = directory.appendingPathComponent("\(fileName).json")
        let serializedItems = todoItemCollection.map { _, item in item.json}
        let data = try JSONSerialization.data(withJSONObject: serializedItems, options: [])
        try data.write(to: path)
    }
    
    func loadFromFile(fileName: String) throws {
        
        /*
         Функция загрузки всех дел из файла (.documentDirectory)
         Вход: имя файла
         Можем иметь несколько разных файлов
         Если в json/csv файле некоторые дела записаны с ошибками (записаны не все обязательные данные, невалидные даты, или что-угодно еще), то при загрузке этих дел из файла браковать только дела с ошибками (например в файле записано 100 дел, но в 10 есть ошибки, тогда в FileCache запишется 90 дел), или браковать все дела (если хотя бы одно дело записано невалидно, то пробрасываем ошибку например)
         */
        
        let fileManager = FileManager.default
        guard let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            throw FileCacheErrors.cannotFindSystemDirectory
        }
        
        let path = directory.appendingPathComponent("\(fileName).json")
        let data = try Data(contentsOf: path, options: [])
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        guard let js = json as? [Any] else {
            throw FileCacheErrors.unparsableData
        }
        let deserializedItems = js.compactMap { TodoItem.parse(json: $0) }
        self.todoItemCollection = deserializedItems.reduce(into: [:]) { res, item in
            res[item.id] = item
        }
    }
    
    enum FileCacheErrors: Error {
        case cannotFindSystemDirectory
        case unparsableData
    }
}
