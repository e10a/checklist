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
    var tableData: [[ChecklistItem?]?]
    
    @IBAction func addItem(_ sender: Any) {
        let newRowIndex = todoList.todoList(for: .medium).count
        _ = todoList.newTodo()
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    @IBAction func deleteItems(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if let priority = priorityForSectionIndex(indexPath.section) {
                    let todos = todoList.todoList(for: priority)
                    let rowToDelete = indexPath.row > todos.count - 1 ? todos.count - 1 : indexPath.row
                    let item = todoList.todoList(for: priority)[rowToDelete]
                    todoList.remove(item, from: priority, at: rowToDelete)
                }
            }
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        todoList = TodoList()
        tableData = [[]]
        super.init(coder: aDecoder)
    }
    
    private func priorityForSectionIndex(_ index: Int) -> TodoList.Priority? {
        return TodoList.Priority(rawValue: index)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        tableView.allowsMultipleSelectionDuringEditing = true
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section) {
            return todoList.todoList(for: priority).count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        if let priority = priorityForSectionIndex(indexPath.section) {
            let item = todoList.todoList(for: priority)[indexPath.row]
            configureText(for: cell, with: item)
            configureCheckmark(for: cell, with: item)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        if let cell = tableView.cellForRow(at: indexPath) {
            if let priority = priorityForSectionIndex(indexPath.section) {
                let item = todoList.todoList(for: priority)[indexPath.row]
                item.toggleChecked()
                configureCheckmark(for: cell, with: item)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if let priority = priorityForSectionIndex(indexPath.section) {
            let item = todoList.todoList(for: priority)[indexPath.row]
            todoList.remove(item, from: priority, at: indexPath.row)
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
    
    override func tableView(
        _ tableView: UITableView,
        moveRowAt sourceIndexPath: IndexPath,
        to destinationIndexPath: IndexPath
    ) {
        if let sourcePriority = priorityForSectionIndex(sourceIndexPath.section),
        let destinationPriority = priorityForSectionIndex(destinationIndexPath.section) {
            let item = todoList.todoList(for: sourcePriority)[sourceIndexPath.row]
            todoList.move(
                item: item,
                from: sourcePriority,
                at: sourceIndexPath.row,
                to: destinationPriority,
                at: destinationIndexPath.row
            )
        }
        tableView.reloadData()
    }

    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        if let checkmarkCell = cell as? ChecklistTableViewCell {
            checkmarkCell.todoTextLabel.text = item.text
        }
    }
    
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        guard let checkmarkCell = cell as? ChecklistTableViewCell else {
            return
        }
        if item.checked {
            checkmarkCell.checkmarkLabel.text = "✅"
        } else {
            checkmarkCell.checkmarkLabel.text = ""
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue" {
            if let itenDetailViewController = segue.destination as? ItemDetailViewController
            {
                itenDetailViewController.delegate = self
                itenDetailViewController.todoList = todoList
            }
        } else if segue.identifier == "EditItemSegue" {
            // first need destination view controller
            if let itenDetailViewController = segue.destination as? ItemDetailViewController
            {
                // figuring out where the user tapped...
                // get cell that is being editted
                // get index path from the actual table view
                itenDetailViewController.delegate = self
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let priority = priorityForSectionIndex(indexPath.section)
                {
                    let item = todoList.todoList(for: priority)[indexPath.row]
                    itenDetailViewController.itemToEdit = item
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TodoList.Priority.allCases.count
    }
    
    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int) -> String?
    {
        var title: String? = nil
        
        if let priority = priorityForSectionIndex(section) {
            switch priority {
            case .high:
                title = "High Priorities"
            case .medium:
                title = "Medium Priorities"
            case .low:
                title = "Low Priorities"
            case .no:
                title = "No Priority"
            }
        }
        return title
    }
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func itemDetailViewControllerDidCancel(
        _ controller: ItemDetailViewController
    ) {
        navigationController?.popViewController(animated: true)
    }

    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishAdding item: ChecklistItem
    ) {
        navigationController?.popViewController(animated: true)
        let rowIndex = todoList.todoList(for: .medium).count - 1
        let indexPath = IndexPath(row: rowIndex, section: TodoList.Priority.medium.rawValue)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func itemDetailViewController(
        _ controller: ItemDetailViewController,
        didFinishEditing item: ChecklistItem
    ) {
        for priority in TodoList.Priority.allCases {
            let currentList = todoList.todoList(for: priority)
            if let index = currentList.firstIndex(of: item) {
                let indexPath = IndexPath(row: index, section: priority.rawValue)
                if let cell = tableView.cellForRow(at: indexPath) {
                    configureText(for: cell, with: item)
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
}
