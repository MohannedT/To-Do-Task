//
//  StorageManager.swift
//  ToDoTaskApp
//
//  Created by Mohanned on 04/10/2020.
//  Copyright © 2020 Mohanned . All rights reserved.
//

import RealmSwift

// Get the default Realm
let realm = try! Realm() // точка входа в базу данных

class StorageManager {
    
     // MARK: - Tasks Lists Methods
    
    static func saveTaskLists(_ tasksLists: [TasksList]) {
        // Persist your data easily
        try! realm.write {
            realm.add(tasksLists)
        }
    }
    
    static func saveTaskList(_ tasksList: TasksList) {
        // Persist your data easily
        try! realm.write {
            realm.add(tasksList)
        }
    }
    
    static func deleteTask(_ taskList: TasksList) {
        try! realm.write {
            let tasks = taskList.tasks
            realm.delete(tasks)
            realm.delete(taskList)
        }
    }
    
    static func editList( _ taskList: TasksList, newListName: String) {
        try! realm.write {
            taskList.name = newListName
        }
    }
    static func makeAllDone(_ taskList: TasksList) {
        try! realm.write {
            taskList.tasks.setValue(true, forKey: "isCompleted")
        }
    }
    
     // MARK: - Tasks Methods
    
    static func saveTask(_ tasksList: TasksList, task: Task) {
        try! realm.write {
            tasksList.tasks.append(task)
        }
    }
    
    static func editTask(_ task: Task, newTask: String, newNote: String) {
        try! realm.write {
            task.name = newTask
            task.note = newNote
        }
    }
    
    static func deleteTask(_ task: Task) {
        try! realm.write {
            realm.delete(task)
        }
    }
    
    static func makeDone(_ task: Task) {
        try! realm.write {
            task.isCompleted.toggle()
        }
    }
}
