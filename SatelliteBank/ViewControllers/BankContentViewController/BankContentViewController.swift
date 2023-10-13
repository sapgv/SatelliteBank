//
//  BankContentViewController.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

final class BankContentViewController: UIViewController {
    
    var viewModel: IBankContentViewModel?
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.layout()
    }
    
    private func setupTableView() {
        
        self.tableView = UITableView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "BankContentDescriptionCell", bundle: nil), forCellReuseIdentifier: BankContentDescriptionCell.id)
        self.tableView.register(UINib(nibName: "WorkTimeCell", bundle: nil), forCellReuseIdentifier: WorkTimeCell.id)
        self.tableView.register(UINib(nibName: "ChartCell", bundle: nil), forCellReuseIdentifier: ChartCell.id)
        self.tableView.register(UINib(nibName: "AddRouteCell", bundle: nil), forCellReuseIdentifier: AddRouteCell.id)
    }
    
    
}

extension BankContentViewController {
    
    private func layout() {
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.tableView)
        
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    
}

extension BankContentViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let bank = self.viewModel?.bank else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BankContentDescriptionCell", for: indexPath) as? BankContentDescriptionCell else { return UITableViewCell() }
            cell.setup(bank: bank)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkTimeCell", for: indexPath) as? WorkTimeCell else { return UITableViewCell() }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as? ChartCell else { return UITableViewCell() }
            cell.setup()
            return cell
            
        case 3:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddRouteCell", for: indexPath) as? AddRouteCell else { return UITableViewCell() }
            cell.addRouteButton.action = { [weak self] _ in
                
                
            }
            return cell
            
            
        default:
            return UITableViewCell()
        }
        
    }
    
}

extension BankContentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return 300
        default:
            return UITableView.automaticDimension
        }
    }
    
}


