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
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var category: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        return view
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
        if model.done {
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: model.text)
            attributedString.addAttribute(
                NSAttributedString.Key.strikethroughStyle,
                value: 2,
                range: NSRange(
                    location: 0,
                    length: attributedString.length
                )
            )
            text.attributedText = attributedString
        } else {
            text.text = model.text
        }
        text.leftAnchor.constraint(equalTo: leftAnchor, constant: 18).isActive = true
        text.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        if model.category != .other {
            addSubview(category)
            category.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18).isActive = true
            category.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            category.widthAnchor.constraint(equalToConstant: 16).isActive = true
            category.heightAnchor.constraint(equalToConstant: 16).isActive = true
            category.backgroundColor = model.category.uiColor
            text.trailingAnchor.constraint(equalTo: category.leadingAnchor, constant: 1).isActive = true
        }
    }
}
