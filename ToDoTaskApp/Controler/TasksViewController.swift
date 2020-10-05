//
//  TasksViewController.swift
//  ToDoTaskApp
//
//  Created by Mohanned on 04/10/2020.
//  Copyright © 2020 Mohanned . All rights reserved.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {
    
    var currentTasksList: TasksList!
    
    private var currentTasks: Results<Task>!
    private var completedTasks: Results<Task>!
    
    private var isEditingMode = false
    
    @IBAction func editButtonPressed(_ sender: Any) {
        isEditingMode.toggle()
        tableView.setEditing(isEditingMode, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        alertForAddAndUpdateList()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       title = currentTasksList.name
        filteringTasks()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == 0 ? currentTasks.count : completedTasks.count
    }
    // заголовок секции
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)

        var task: Task!
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note

        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var task: Task!
        
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTasks[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
            StorageManager.deleteTask(task)
            self.filteringTasks()
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (_, _) in
            self.alertForAddAndUpdateList(task)
            self.filteringTasks()
        }
        
        let doneAction = UITableViewRowAction(style: .normal, title: "Done") { (_, _) in
            StorageManager.makeDone(task)
            self.filteringTasks()
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        return [deleteAction, doneAction, editAction]
    }
    
    
    // заполняем массивы
    private func filteringTasks() {
        currentTasks = currentTasksList.tasks.filter("isCompleted = false")
        completedTasks = currentTasksList.tasks.filter("isCompleted = true")
        
        tableView.reloadData()
    }
}

extension TasksViewController {
    
    private func alertForAddAndUpdateList(_ taskName: Task? = nil) {
        
        var title = "New Task"
        var doneButton = "Save"
        
        if taskName != nil {
            title = "Edit Task"
            doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert task value", preferredStyle: .alert)
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newTask = taskTextField.text , !newTask.isEmpty else { return }
            
            if let taskName = taskName {
                if let newNote = noteTextField.text, !newNote.isEmpty {
                    StorageManager.editTask(taskName, newTask: newTask, newNote: newNote)
                } else {
                    StorageManager.editTask(taskName, newTask: newTask, newNote: "")
                }
                
                self.filteringTasks()
                
            } else {
                
                let task = Task()
                task.name = newTask
                
                if let note = noteTextField.text, !note.isEmpty {
                    task.note = note
                }
                
                StorageManager.saveTask(self.currentTasksList, task: task)
                self.filteringTasks()
            }
        }
        
     
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            taskTextField = textField
            taskTextField.placeholder = "New task"
            
            if let taskName = taskName {
                taskTextField.text = taskName.name
            }
        }
        
        alert.addTextField { textField in
            noteTextField = textField
            noteTextField.placeholder = "Note"
            
            if let taskName = taskName {
                noteTextField.text = taskName.note
            }
        }
        
        present(alert, animated: true)
    }
}

