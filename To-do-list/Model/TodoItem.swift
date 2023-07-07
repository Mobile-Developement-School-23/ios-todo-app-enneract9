//
//  TodoItem.swift
//  To-do-list
//
//  Created by @_@
//

import Foundation

struct TodoItem {
    
    let id: String
    let text: String
    let importance: Importance
    let deadline: Date?
    let isDone: Bool
    let dateOfCreation: Date
    let dateOfChange: Date?
    
    init(id: String = UUID().uuidString, text: String, importance: Importance, deadline: Date? = nil, isDone: Bool = false , dateOfChange: Date? = nil, dateOfCreation: Date = Date()) {
        self.id = id
        self.text = text
        self.importance = importance
        self.deadline = deadline
        self.isDone = isDone
        self.dateOfCreation = dateOfCreation
        self.dateOfChange = dateOfChange
    }
    
    init?(dict: [String:Any]) {
        
        guard let text = dict["text"] as? String, let timeIntervalOfCreation = dict["dateOfCreation"] as? TimeInterval else {
            return nil
        }
        
        self.id = dict["id"] as? String ?? UUID().uuidString
        self.text = text
        self.importance = Importance(rawValue: dict["importance"] as? String ?? "") ?? .usual
        self.isDone = dict["isDone"] as? Bool ?? false
        self.dateOfCreation =  Date(timeIntervalSince1970: timeIntervalOfCreation)
        
        if let timeIntervalOfChange = dict["dateOfChange"] as? TimeInterval {
            self.dateOfChange = Date(timeIntervalSince1970: timeIntervalOfChange)
        } else {
            self.dateOfChange = nil
        }
        
        if let timeIntervalDeadline = dict["deadline"] as? TimeInterval {
            self.deadline = Date(timeIntervalSince1970: timeIntervalDeadline)
        } else {
            self.deadline = nil
        }
    }
    
    enum Importance: String {
        case unimportant
        case usual
        case important
    }
}

extension TodoItem {
    var json: Any {
        get {
            /*
             Вычислимое свойство для формирования json'а
             Конвертация TodoItem в словарь, затем Data, полученная от JSONSerialization.data(), в Any
             
             [x] Не сохранять в json важность, если она "обычная"
             [x] Не сохранять в json сложные объекты (Date)
             [x] Сохранять deadline только если он задан
             */
            
            var dict: [String:Any] = [
                "id":self.id,
                "text":self.text,
                "isDone":self.isDone,
                "dateOfCreation":Int(self.dateOfCreation.timeIntervalSince1970)
            ]
            
            if self.importance != .usual {
                dict["importance"] = self.importance.rawValue
            }
            
            if let deadline = self.deadline {
                dict["deadline"] = Int(deadline.timeIntervalSince1970)
            }
            
            if let dateOfChange = self.dateOfChange {
                dict["dateOfChange"] = Int(dateOfChange.timeIntervalSince1970)
            }
            
            return dict
        }
    }
    
    static func parse(json: Any) -> TodoItem? {
        
        /*
         Функция для разбора json
         Вход: Any – результат работы JSONSerialization.jsonObject(with:options:)
         Выход: TodoItem
         "То есть, работу с JSONSerialization лучше вынести на уровень выше – туда, где используется метод parse"
         */
        
        let dict = json as? [String:Any] ?? [:]
        let todoItem = TodoItem(dict: dict)
        
        return todoItem
    }
}

//    var sqlReplaceStatement: String не понятно, где можно было бы использовать в CoreData 🤔
