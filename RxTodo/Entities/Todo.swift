//
//  Todo.swift
//  RxTodo
//
//  Created by Yurii Krupa on 11/9/18.
//  Copyright © 2018 Yurii Krupa. All rights reserved.
//

import Foundation

enum TodoStatus {
    case created
    case inProgress
    case done
}

class Todo {
    var title: String?
    var content: String?
    var tags: [String]
    var status: TodoStatus = .created
    
    init(title: String, content: String, tags: [String], status: TodoStatus = .created) {
        self.title = title
        self.content = content
        self.tags = tags
        self.status = status
    }
}
