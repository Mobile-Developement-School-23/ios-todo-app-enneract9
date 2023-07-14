//
//  CoreDataManager.swift
//  To-do-list
//
//  Created by @_@ on 13.07.2023.
//

import CoreData
import UIKit

final class CoreDataManager: NSObject {
    
    // MARK: - Properties
    public static let shared = CoreDataManager()
    private override init() {}
    
    private var appDelegate: AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - CRUD
    
    // create
    func createTodoItemEntity(todoItem: TodoItem) {
        guard let todoListEntityDescription = NSEntityDescription.entity(
            forEntityName: "TodoListEntity" ,
            in: context)
        else {
            return
        }
        
        let todoListEntity = TodoListEntity(
            entity: todoListEntityDescription,
            insertInto: context)
        
        todoListEntity.todoItem = todoItem
        appDelegate.saveContext()
    }
    
    // read
    func fetchAllTodoItems() -> [TodoItem]? {
        do {
            return try context.fetch(TodoListEntity.fetchRequest()).compactMap( { $0.todoItem } )
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func fetchTodoItem(id: String) -> TodoItem? {
        let fetchRequest = TodoListEntity.fetchRequest()
        // SQL features in CoreData
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            return try context.fetch(fetchRequest).first?.todoItem
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    // updates if exsists or inserts if not
    func updateOrInsertTodoItem(todoItem: TodoItem) {
        
        /*
         Используется в FileCache.addTodoItem(todoItem: TodoItem)
         
         == Первая звездочка
         Заменить save()  на единичные запросы (как в network) - insert/update/delete, которые работают по одному элементу, load() оставить как есть.
         */
        
        let fetchRequest = TodoListEntity.fetchRequest()
        // SQL features in CoreData
        fetchRequest.predicate = NSPredicate(format: "id == %@", todoItem.id)
        
        if let fetchResult = try? context.fetch(fetchRequest).first {
            fetchResult.todoItem = todoItem
        } else {
            createTodoItemEntity(todoItem: todoItem)
        }
        
        appDelegate.saveContext()
    }
    
    func updateOrInsertTodoItems(todoItems: [TodoItem]) {
        
        todoItems.forEach { todoItem in
            let fetchRequest = TodoListEntity.fetchRequest()
            // SQL features in CoreData
            fetchRequest.predicate = NSPredicate(format: "id == %@", todoItem.id)
            
            if let fetchResult = try? context.fetch(fetchRequest).first {
                fetchResult.todoItem = todoItem
            } else {
                createTodoItemEntity(todoItem: todoItem)
            }
        }
        
        appDelegate.saveContext()
    }
    
    // delete
    func deleteAllTodoItems() {
        do {
            let todoItems = try context.fetch(TodoListEntity.fetchRequest()) as? [TodoListEntity]
            todoItems?.forEach( { context.delete($0) } )
        } catch {
            print(error.localizedDescription)
        }
        
        appDelegate.saveContext()
    }
    
    func deleteTodoItem(id: String) {
        
        /*
         Используется в FileCache.removeTodoItem(id: String) -> TodoItem?
         
         == Первая звездочка
         Заменить save()  на единичные запросы (как в network) - insert/update/delete, которые работают по одному элементу, load() оставить как есть.
         */
        
        let fetchRequest = TodoListEntity.fetchRequest()
        // SQL features in CoreData
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        guard let fetchResult = try? context.fetch(fetchRequest).first else { return }
        
        context.delete(fetchResult)
        
        appDelegate.saveContext()
    }
}
