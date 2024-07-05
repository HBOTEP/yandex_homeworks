//
//  CalendarViewController.swift
//  Todo
//
//  Created by Анастасия on 05.07.2024.
//

import UIKit
import SwiftUI

final class CalendarViewController: UIViewController {
    // MARK: - Fields
    private var viewModel: CalendarViewModel
    
    private let plusButton: UIButton = UIButton()
    
    private lazy var calendar: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 70, height: 70)
        let calendar = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        calendar.register(CalendarCell.self, forCellWithReuseIdentifier: CalendarCell.calendarCellId)
        calendar.delegate = self
        calendar.dataSource = self
        calendar.backgroundColor = .clear
        calendar.showsHorizontalScrollIndicator = false
        return calendar
    }()
    
    private lazy var table: UITableView = {
        let table = UITableView(frame: self.view.frame, style: .insetGrouped)
        table.register(TodoCell.self, forCellReuseIdentifier: TodoCell.todoCellId)
        table.dataSource = self
        table.delegate = self
        table.separatorStyle = .singleLine
        return table
    }()
    
    // MARK: - Lifecycle
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Мои дела"
        self.navigationItem.hidesBackButton = false
        configureUI()
    }
    
    // MARK: - Configuration
    private func configureUI() {
        configureCalendar()
        configureTable()
        configurePlusButton()
    }
    
    private func configureCalendar() {
        view.addSubview(calendar)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        calendar.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 90).isActive = true
        calendar.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
    }
    
    private func configureTable() {
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: calendar.bottomAnchor).isActive = true
        table.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        table.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
    }
    
    private func configurePlusButton() {
        plusButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        plusButton.contentHorizontalAlignment = .fill
        plusButton.contentVerticalAlignment = .fill
        plusButton.tintColor = .systemBlue
        plusButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plusButton)
        plusButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        plusButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        plusButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        plusButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc
    private func plusButtonTapped() {
        
    }
}

// MARK: - UITableViewDelegate
extension CalendarViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // TODO
        return nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // TODO
        return nil
    }
}

// MARK: - UITableViewDataSource
extension CalendarViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.todoItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoItems[section].1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: TodoCell.todoCellId)
        guard let todoCell = cell as? TodoCell else { return UITableViewCell() }
        todoCell.configure(with: viewModel.todoItems[indexPath.section].1[indexPath.row])
        return todoCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.todoItems[section].0
    }
}

// MARK: - UICollectionViewDelegate
extension CalendarViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: CalendarCell.calendarCellId, for: indexPath)
        guard let calendarCell = cell as? CalendarCell else { return UICollectionViewCell() }
        calendarCell.configure(with: viewModel.dates[indexPath.item])
        calendarCell.layer.borderColor = UIColor.secondaryLabel.cgColor
        calendarCell.layer.borderWidth = 3
        calendarCell.layer.cornerRadius = 5
        return calendarCell
    }
}
