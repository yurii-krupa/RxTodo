//
//  TodoModel.swift
//  RxTodo
//
//  Created by Yurii Krupa on 11/9/18.
//  Copyright © 2018 Yurii Krupa. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct TodoModel {
    private let todoBehavioeRelay = BehaviorRelay<[Todo]>(value: [])
    
    var todoModelObservable: Observable<[Todo]> {
        get {
            return self.todoBehavioeRelay.asObservable()
        }
    }

    func setTodoModelTemo(_ param: [Todo]) {
        self.todoBehavioeRelay.accept(param)
//        self.todoBehavioeRelay.subscribe(onNext: {
//          print($0.description)
//        }).disposed(by: DisposeBag())
    }
    
    func addNewTodo(_ todo: Todo) {
        var temp = self.todoBehavioeRelay.value
        temp.append(todo)
        self.setTodoModelTemo(temp)
    }
    
}
