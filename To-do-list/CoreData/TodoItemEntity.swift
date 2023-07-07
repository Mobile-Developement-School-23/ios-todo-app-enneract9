//
//  TodoListEntity+CoreDataProperties.swift
//  To-do-list
//
//  Created by @_@ on 13.07.2023.
//
//

import Foundation
import CoreData

@objc(TodoListEntity)
public class TodoListEntity: NSManagedObject {

}

extension TodoListEntity {
    //MARK: - Properties

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TodoListEntity> {
        return NSFetchRequest<TodoListEntity>(entityName: "TodoListEntity")
    }
    
    @NSManaged public var id: String
    @NSManaged public var text: String
    @NSManaged public var importance: String
    @NSManaged public var deadline: Date?
    @NSManaged public var isDone: Bool
    @NSManaged public var dateOfCreation: Date
    @NSManaged public var dateOfChange: Date?
    
    var todoItem: TodoItem {
        get {
            return TodoItem(
                id: id,
                text: text,
                importance: TodoItem.Importance(rawValue: importance) ?? .usual,
                deadline: deadline,
                isDone: isDone,
                dateOfChange: dateOfChange,
                dateOfCreation: dateOfCreation
            )
        }
        set {
            self.id = newValue.id
            self.text = newValue.text
            self.importance = newValue.importance.rawValue
            self.deadline = newValue.deadline
            self.isDone = newValue.isDone
            self.dateOfCreation = newValue.dateOfCreation
            self.dateOfChange = newValue.dateOfChange
        }
    }
}

extension TodoListEntity : Identifiable { }
