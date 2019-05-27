//
//  TodoListTableViewController.swift
//  PutAndPost
//
//  Created by Seschwan on 5/27/19.
//  Copyright © 2019 Seschwan. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private let todoController = TodoController()
    let pushMethod: PushMethod = .put
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var saveBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBtn.layer.cornerRadius = saveBtn.frame.height / 4
        fetchTodos()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoController.todos.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        
        // Get appropriate todo from datasource and configure cell
        let todo = todoController.todos[indexPath.row]
        cell.textLabel?.text = todo.title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let todo = todoController.todos[indexPath.row]
        // configure swipe action
        let title: String
        switch pushMethod {
            case .put:
                title = "PUT Again"
            case .post:
                title = "POST Again"
        }
        
        let againAction = UIContextualAction(style: .normal, title: title) { (action, view, handler) in
            self.todoController.push(todo: todo, using: self.pushMethod, completion: { (error) in
                if let error = error {
                    print("Error pushing todo to server again: \(error)")
                    handler(false)
                    return
                }
                self.fetchTodos()
                handler(true)
            })
        }
        
        againAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [againAction])
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // get todo text from textfield
        guard let title = textField.text else { return}
        
        // create todo
        let todo = todoController.createTodo(with: title)
        
        // Send todo to Firebase
        todoController.push(todo: todo, using: pushMethod) { (error) in
            if let error = error {
                print(error)
            }
            self.fetchTodos()
            
        }
        print("Save Button Pushed")
    }
    
    func fetchTodos() {
        // fetch todos from Firebase and display them
        todoController.fetchTodos { (error) in
            if let error = error {
                print(error)
                // Show an alert view or some other UI control to show error state
                
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}
