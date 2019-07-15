//
//  TodoList.swift
//  Checklist
//
//  Created by e10a on 7/12/19.
//  Copyright © 2019 e10a. All rights reserved.
//

import Foundation

class TodoList {
     var todos: [ChecklistItem] = []
    
    enum Priority: Int, CaseIterable {
        case high, medium, low, no
    }
    
    private var highPriorityTodos: [ChecklistItem]
    private var mediumPriorityTodos: [ChecklistItem]
    private var lowPriorityTodos: [ChecklistItem]
    private var noPriorityTodos: [ChecklistItem]
    
    init() {
        highPriorityTodos = []
        mediumPriorityTodos = []
        lowPriorityTodos = []
        noPriorityTodos = []
        
        let row0Item = ChecklistItem()
        let row1Item = ChecklistItem()
        let row2Item = ChecklistItem()
        let row3Item = ChecklistItem()
        let row4Item = ChecklistItem()

        row0Item.text = "Take a jog"
        row1Item.text = "Watch a movie"
        row2Item.text = "Code an app"
        row3Item.text = "Walk the dog"
        row4Item.text = "Study design patterns"

        addTodo(row0Item, for: Priority.medium)
        addTodo(row1Item, for: Priority.medium)
        addTodo(row2Item, for: Priority.medium)
        addTodo(row3Item, for: Priority.medium)
        addTodo(row4Item, for: Priority.medium)
    }
    
    func newTodo() -> ChecklistItem {
        let item = ChecklistItem()
        item.text = randomTitle()
        item.checked = true
        mediumPriorityTodos.append(item)
        return item
    }
    
    private func randomTitle() -> String {
        var titles: [String] = [
            "New todo item",
            "Generic todo",
            "Fill me out",
            "I need something to do",
            "Much todo about nothing"
        ]
        let randomNumber = Int.random(in: 0...titles.count-1)
        return titles[randomNumber]
    }
    
    func move(item: ChecklistItem, to index: Int) {
        guard let currentIndex = todos.firstIndex(of: item) else {
            return
        }
        todos.remove(at: currentIndex)
        todos.insert(item, at: index)
    }
    
    func remove(_ item: ChecklistItem, from priority: Priority, at index: Int) {
        switch priority {
        case .high:
            highPriorityTodos.remove(at: index)
        case .medium:
            mediumPriorityTodos.remove(at: index)
        case .low:
            lowPriorityTodos.remove(at: index)
        case .no:
            noPriorityTodos.remove(at: index)
        }
    }
    
    func todoList(for priority: Priority) -> [ChecklistItem] {
        switch priority {
        case .high:
            return highPriorityTodos
        case .medium:
            return mediumPriorityTodos
        case .low:
            return lowPriorityTodos
        case .no:
            return noPriorityTodos
        }
    }
    
    func addTodo(_ item: ChecklistItem, for priority: Priority) {
        switch priority {
        case .high:
            return highPriorityTodos.append(item)
        case .medium:
            return mediumPriorityTodos.append(item)
        case .low:
            return lowPriorityTodos.append(item)
        case .no:
            return noPriorityTodos.append(item)
        }
    }
}
