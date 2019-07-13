//
//  ChecklistViewController
//  Checklist
//
//  Created by e10a on 7/12/19.
//  Copyright © 2019 e10a. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    var todoList: TodoList
    
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoList()
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        if let label = cell.viewWithTag(1000) as? UILabel {
            label.text = todoList.todos[indexPath.row].text
        }
        configureCheckmarks(for: cell, indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            configureCheckmarks(for: cell, indexPath: indexPath)
        }
    }
    
    func configureCheckmarks(for cell: UITableViewCell, indexPath: IndexPath) {
        let isChecked = todoList.todos[indexPath.row].checked
        if isChecked {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        todoList.todos[indexPath.row].checked = !isChecked
        tableView.deselectRow(at: indexPath, animated: true)
    }


}

