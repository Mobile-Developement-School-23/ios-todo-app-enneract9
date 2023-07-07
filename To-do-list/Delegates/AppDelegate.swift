//
//  AppDelegate.swift
//  To-do-list
//
//  Created by @_@ 
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
        
//        CoreDataManager.shared.createTodoItemEntity(todoItem: TodoItem(id: "bbb", text: "bbb", importance: .unimportant))
//        CoreDataManager.shared.createTodoItemEntity(todoItem: TodoItem(id: "ccc", text: "ccc", importance: .usual, deadline: Date.now, isDone: true))
//        CoreDataManager.shared.deleteTodoItem(id: "bbb")
//        CoreDataManager.shared.deleteAllTodoItems()
//        CoreDataManager.shared.updateTodoItem(todoItem: TodoItem(id: "ccc", text: "aaaa", importance: .usual, deadline: Date.now, isDone: false))
        
//        let todoItem = TodoItem(id: "sss", text: "AAAA", importance: .important)
//        let todoItem2 = TodoItem(id: "ggg", text: "ggg", importance: .usual)
//        let todoItem3 = TodoItem(id: "hhh", text: "GGG", importance: .unimportant)
//        let todoItem4 = TodoItem(id: "yyy", text: "iiiii", importance: .usual)
//        let todoItem5 = TodoItem(id: "ayyy", text: "ayyyy", importance: .usual)
//
//        CoreDataManager.shared.updateOrInsertTodoItems(todoItems: [todoItem, todoItem2, todoItem3, todoItem4, todoItem5])
        
//        let fileCacheSome = FileCache()
//        
//        let todoItems = CoreDataManager.shared.fetchAllTodoItems()
//        todoItems?.forEach( { print("\n", $0, "\n") } )
//        print("-------------------------")
//        print("-------------------------")
//        print("-------------------------")
//        
//        do {
//            try fileCacheSome.loadFromCoreData()
//        } catch {
//            print(error.localizedDescription)
//        }
//        
//        fileCacheSome.todoItemCollection.forEach( { print("\n", $0, "\n") } )
//        print("-------------------------")
//        print("-------------------------")
//        
//        fileCacheSome.addTodoItem(todoItem: TodoItem(id: "lllll", text: "lllll", importance: .important))
//        
//        fileCacheSome.todoItemCollection.forEach( { print("\n", $0, "\n") } )
//        print("-------------------------")
//        print("-------------------------")
//        
//        fileCacheSome.saveAllToCoreData()
//        
//        
//        let todoItems2 = CoreDataManager.shared.fetchAllTodoItems()
//        todoItems2?.forEach( { print("\n", $0, "\n") } )
//        print("-------------------------")
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo), \n\(error.localizedDescription)")
            } else {
                print("Database URL: \(storeDescription.url?.absoluteString)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo), \n\(error.localizedDescription)")
            }
        }
    }

}

