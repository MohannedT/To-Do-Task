//
//  TasksList.swift
//  ToDoTaskApp
//
//  Created by Mohanned on 04/10/2020.
//  Copyright © 2020 Mohanned . All rights reserved.
//

import RealmSwift

class TasksList: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>() 
}
