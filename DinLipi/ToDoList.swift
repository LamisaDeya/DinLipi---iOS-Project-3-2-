//
//  ViewController.swift
//  DinLipi2
//
//  Created by IQBAL MAHAMUD on 11/11/23.
//

import UIKit

class ToDoList: UITableViewController {
    
    //MARK: - Properties
    
    var todoItems = [ToDoItem]() {
        didSet {
            print("to-do items were set")
            tableView.reloadData()
        }
    }
    
    let reuseIdentifier = "ToDoCell"
    
    lazy var createNewButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.backgroundColor = .systemTeal
        button.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        button.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        
        button.addTarget(self, action: #selector(createNewToDo), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Lifecycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        // Do any additional setup after loading the view.
        
        configureTableView()
        
        fetchItems()
        
        
    }
    func setupNavigationBar() {
        let homeButton = UIBarButtonItem(title: "Home", style: .plain, target: self, action: #selector(homeButtonTapped))
        navigationItem.leftBarButtonItem = homeButton

        
    }

    @objc func homeButtonTapped() {
        print("Home button tapped!")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home") as! Home
        self.navigationController?.pushViewController(vc, animated: true)
        // Add your code to navigate to the home screen
    }
    
    //MARK: - API
    
    
    fileprivate func fetchItems() {
        PostService.shared.fetchAllItems { (allItems) in
            self.todoItems = allItems
        }
    }
    
    // MARK: - Selectors
    
    @objc func createNewToDo() {
        let vc = CreateToDoController()
        present(vc, animated: true, completion: nil)
    }
    
    // MARK: - Helper Functions
    
    func configureTableView (){
        tableView.backgroundColor = .white
        
        tableView.register(ToDoCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 75
        tableView.separatorColor = .black
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        tableView.tableFooterView = UIView()
        
        //create new todo button
        
        tableView.addSubview(createNewButton)
        createNewButton.anchor(bottom: tableView.safeAreaLayoutGuide.bottomAnchor, right: tableView.safeAreaLayoutGuide.rightAnchor, paddingBottom: 0, paddingRight: -15, width: 56, height: 56)
        createNewButton.layer.cornerRadius = 56/2
        createNewButton.alpha = 1
            
    }
    
}

//MARK: - UITableViewDelegate/UITableViewDataSource

extension ToDoList {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ToDoCell else { return UITableViewCell() }
        
        cell.todoItem = todoItems[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
        // Update status of the cell
        // Incomplete -> Finished
        let todoItem = todoItems[indexPath.row]
        if let userID = UserDataManager.shared.currentUserID {
            
            // Convert the date to a string using the same format as used for uploading
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: todoItem.date)
            
            PostService.shared.updateItemStatus(
                userID: userID,
                date: dateString,
                taskID: todoItem.id,
                isComplete: true
            ) { (err, ref) in
                if let error = err {
                    print("Error updating item status:", error)
                } else {
                    print("Item status updated successfully for todoId:", todoItem.id)
                }
                self.tableView.deselectRow(at: indexPath, animated: true)
                self.fetchItems()
            }
        }
        else {
            // Handle the case where userID is not available
        }
    }
}



