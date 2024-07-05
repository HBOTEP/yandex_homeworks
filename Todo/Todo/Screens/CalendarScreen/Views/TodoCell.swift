//
//  TodoCell.swift
//  Todo
//
//  Created by Анастасия on 05.07.2024.
//

import UIKit

final class TodoCell: UITableViewCell {
    // MARK: - Fields
    static let todoCellId: String = "TodoCellId"
    
    lazy var text: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    func configure(with model: TodoItem) {
        addSubview(text)
        text.text = model.text
        text.leftAnchor.constraint(equalTo: leftAnchor, constant: 18).isActive = true
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
