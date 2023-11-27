//
//  CreateToDoController.swift
//  DinLipi2
//
//  Created by IQBAL MAHAMUD on 25/11/23.
//

import UIKit

class CreateToDoController: UIViewController {
    
    //MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .systemBlue
        label.text = "Create a new to-do item"
        label.textAlignment = .center
        return label
    }()
    
    private let itemTextField: UITextField = {
        let tf = UITextField()
        tf.font = .systemFont(ofSize: 15)
        tf.textColor = .black
        tf.backgroundColor = .systemGray6
        return tf
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create item", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.backgroundColor = .systemTeal
        button.addTarget(self, action: #selector(createItemPressed), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    @objc func createItemPressed() {
        guard let todoText = itemTextField.text else { return }
        PostService.shared.uploadTodoItem(text: todoText) { (err, ref) in
            self.itemTextField.text = ""
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemGray6
        
        //title label
        view.addSubview(titleLabel)
        titleLabel.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(itemTextField)
        itemTextField.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 128, paddingLeft: 16, paddingRight: -16, height: 40)
        itemTextField.delegate = self
        
        //button
        view.addSubview(createButton)
        createButton.anchor(left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 25, paddingBottom: -15, paddingRight: -25, height: 50)
    }
    
}

extension CreateToDoController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
