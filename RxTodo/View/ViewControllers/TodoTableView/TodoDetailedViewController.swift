//
//  TodoDetailedViewController.swift
//  RxTodo
//
//  Created by Yurii Krupa on 11/12/18.
//  Copyright © 2018 Yurii Krupa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TodoDetailedViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    private let disposeBag = DisposeBag()
    
    var todoItem: Todo? = Todo(title: "", content: "", tags: []) {
        didSet {
            self.view.layoutIfNeeded()
            self.titleLabel.text = todoItem?.title
            self.contentTextView.text = todoItem?.content
        }
    }
    var todoModel: TodoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = saveButton
        
        self.contentTextView.layer.borderWidth = 1/8
        self.contentTextView.layer.borderColor = self.titleLabel.layer.borderColor
        self.contentTextView.layer.cornerRadius = 5
        
        self.titleLabel.rx
            .controlEvent([.editingDidEnd])
            .subscribe(onNext: {
                [unowned self] (_) in
                self.todoItem?.title = self.titleLabel.text
                
            }).disposed(by: disposeBag)
        
        self.contentTextView.rx
            .didEndEditing
            .subscribe(onNext: {
                [unowned self] _ in
                self.todoItem?.content = self.contentTextView.text
                self.todoItem?.tags = self.matches(for: "\\B(\\#[a-zA-Z]+\\b)(?!;)", in: self.contentTextView.text)
            }).disposed(by: disposeBag)
        
        saveButton.rx
            .tap
            .subscribe(onNext: {
                [unowned self] (_) in
                guard let todoModel = self.todoModel, let todoItem = self.todoItem else { return }
                todoModel.addNewTodo(todoItem)
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
    
    
    func matches(for regex: String, in text: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
//Changes ...
