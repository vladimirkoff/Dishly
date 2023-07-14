//
//  SettingsViewController.swift
//  Dishly
//
//  Created by Vladimir Kovalev on 12.07.2023.
//

import UIKit

class SettingsViewController: UIViewController {
    //MARK: - Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = lightGrey
        tableView.layer.cornerRadius = 10
        tableView.register(ProfileOptionCell.self, forCellReuseIdentifier: "ProfileOptionCell")
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = greyColor
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 5 * 50),
            tableView.widthAnchor.constraint(equalToConstant: view.bounds.width - 20)
        ])
    }
    
    func configureCell(cell: ProfileOptionCell, index: Int) {
        if index == 0 {
            cell.optionLabel.text = "Change appearance"
            cell.cellSymbol.image = UIImage(systemName: "paintbrush.fill")
            cell.mySwitch.isHidden = false
            cell.mySwitch.isOn = true // Установите нужное значение isOn
            cell.mySwitch.isUserInteractionEnabled = true
            cell.mySwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            cell.accessoryImage.isHidden = true
        } else if index == 1 {
            cell.optionLabel.text = "Delete account"
            cell.optionLabel.textColor = .red
        }
    }
    
    //MARK: - Selectors
    
    @objc func switchValueChanged(_ sender: UISwitch) {
          // Обработка изменения состояния UISwitch
          if sender.isOn {
              print("Switch is ON")
          } else {
              print("Switch is OFF")
          }
      }
    
}

//MARK: - UITableViewDelegate & UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileOptionCell", for: indexPath) as! ProfileOptionCell
        configureCell(cell: cell, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
}
