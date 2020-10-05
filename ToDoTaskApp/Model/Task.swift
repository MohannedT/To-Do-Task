//
//  Task.swift
//  ToDoTaskApp
//
//  Created by Mohanned on 04/10/2020.
//  Copyright © 2020 Mohanned . All rights reserved.
//

import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isCompleted = false
}
