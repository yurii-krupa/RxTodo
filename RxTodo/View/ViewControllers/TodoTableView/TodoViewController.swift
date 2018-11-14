//
//  TodoTableViewController.swift
//  RxTodo
//
//  Created by Yurii Krupa on 11/9/18.
//  Copyright © 2018 Yurii Krupa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TodoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var todoModel: TodoModel = TodoModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = addBarButton
        
        //MARK: - ####### TEMP - remove ######
        let todoPool =
            [Todo.init(title: "first", content: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", tags: ["dev", "wiki"]),
            Todo.init(title: "Second", content: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", tags: ["Home", "wiki"]),
            Todo.init(title: "Third", content: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.", tags: ["Third", "dev"])]

        self.todoModel.setTodoModelTemo(todoPool)
        
        //MARK: ####### END ######
        
        self.todoModel.todoModelObservable.bind(to: tableView.rx.items(cellIdentifier: "TodoTableViewCell", cellType: TodoTableViewCell.self)) {
            row, todoItem, cell in
            cell.titleLabel.text = todoItem.title
            cell.contentLabel.text = todoItem.content
            cell.tagsLabel.text = String.stringOfTagsFromArray(todoItem.tags)
        }.disposed(by: disposeBag)


        tableView.rx.modelSelected(Todo.self)
            .subscribe(onNext: { [weak self] (todoItem) in
                guard let strongSelf = self else { return }
                guard let detailedTodoViewController = strongSelf.storyboard?.instantiateViewController(withIdentifier: "TodoDetailedViewController") as? TodoDetailedViewController else { return }
                
                detailedTodoViewController.todoItem = todoItem
                
                strongSelf.navigationController?.pushViewController(detailedTodoViewController, animated: true)
            }).disposed(by: disposeBag)
        
        
        addBarButton.rx.tap.subscribe(onNext: { [unowned self] (_) in
            
            guard let detailedTodoViewController = self.storyboard?.instantiateViewController(withIdentifier: "TodoDetailedViewController") as? TodoDetailedViewController else { return }
            detailedTodoViewController.todoModel = self.todoModel
            self.navigationController?.pushViewController(detailedTodoViewController, animated: true)
            print("TAPPPED")
            
            
        }).disposed(by: disposeBag)
        
    }

    private func bindTable() {
        //TODO: Bind Table
    }

    
}

extension String {
    static func stringOfTagsFromArray(_ array: [String]) -> String {
        var str = ""
        array.forEach({
            str += "\($0), "
        })
        return str
    }
}
