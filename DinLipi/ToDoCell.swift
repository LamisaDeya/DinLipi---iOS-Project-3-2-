//
//  ToDoCell.swift
//  DinLipi2
//
//  Created by IQBAL MAHAMUD on 24/11/23.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    //MARK: - Properties
    
    var todoItem: ToDoItem? {
        didSet {
            if let todoItem = todoItem {
                titleLabel.text = todoItem.title
                if todoItem.isComplete {
                    statusLabel.text = "Status: Completed"
                    statusLabel.textColor = .systemGreen
                } else {
                    statusLabel.text = "Status: Incomplete"
                    statusLabel.textColor = .systemRed
                }
            } else {
                // Handle the case where todoItem is nil, if needed.
                // You might want to set default values or do nothing based on your use case.
            }
        }
    }

    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.text = "Title Label"
        return label
    }()
    
    
    
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .black
        label.text = "Status: Incomplete"
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            
            backgroundColor = .systemGray6
            
            addSubview(titleLabel)
            titleLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 8)
            
            addSubview(statusLabel)
            statusLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 8)
            
            
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - Helpers
}
