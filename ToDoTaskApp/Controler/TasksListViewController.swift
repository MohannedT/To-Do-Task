//
//  TasksListViewController.swift
//  ToDoTaskApp
//
//  Created by Mohanned on 04/10/2020.
//  Copyright © 2020 Mohanned . All rights reserved.
//

import UIKit
import RealmSwift

class TasksListViewController: UITableViewController {
    
    var tasksLists: Results<TasksList>!
    
    @IBAction func editButtonPressed(_ sender: Any) {
    }
    
    @IBAction func  addButtonPressed(_ sender: Any) {
        alerForAddAndUpdateList()
    }
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            tasksLists = tasksLists.sorted(byKeyPath: "name")
        } else {
            tasksLists = tasksLists.sorted(byKeyPath: "date")
        }
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tasksLists = realm.objects(TasksList.self)
        
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.tableFooterView = UIView()

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksLists.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        
        
        let tasksList = tasksLists[indexPath.row]
        cell.configure(with: tasksList)
        
    
        return cell
    }
    
    // MARK: - Table view delegate


    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let currentList = tasksLists[indexPath.row]
        
        let deliteAction = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            StorageManager.deleteTask(currentList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (_, _) in
            self.alerForAddAndUpdateList(currentList, complition: {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            })
        }
        
        let doneAction = UITableViewRowAction(style: .normal, title: "Done") { (_, _) in
            StorageManager.makeAllDone(currentList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        return [deliteAction, doneAction, editAction]
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let tasksList = tasksLists[indexPath.row]
            let tasksVC = segue.destination as! TasksViewController
            tasksVC.currentTasksList = tasksList
        }
    }
}

private func load() {
    
    let shoppingList = TasksList()
    shoppingList.name = "Shopping List"
    
    let moviesList = TasksList(value: ["Movie List", Date(), [["John Wick"], ["Tor", "", Date(), true]]])
    
    let milk = Task()
    milk.name = "Milk"
    milk.note = "2L"
    
    let bread = Task(value: ["Bread", "", Date(), true])
    let apples = Task(value: ["name": "Apples", "note": "2Kg"])
    
    shoppingList.tasks.append(milk)
    shoppingList.tasks.insert(contentsOf: [bread, apples], at: 1)
    

    DispatchQueue.main.async {
        StorageManager.saveTaskLists([shoppingList, moviesList])
    }
}

extension TasksListViewController {
    

    private func alerForAddAndUpdateList(_ listName: TasksList? = nil, complition: (() -> Void)? = nil) {
        
        var title = "New List"
        var doneButton = "Save"
        
        if listName != nil {
            title = "Edit List"
            doneButton = "Update"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let newList = alertTextField.text , !newList.isEmpty else { return }
            
            if let listName = listName {
                StorageManager.editList(listName, newListName: newList)
                if complition != nil { complition!() }
            } else {
                let taskList = TasksList()
                taskList.name = newList
                
                StorageManager.saveTaskList(taskList)
                
                self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
                }
            }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "List Name"
        }
        
        if let listName = listName {
            alertTextField.text = listName.name
        }
        
        present(alert, animated: true)
    }
}
