//
//  BankContentViewController.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

final class BankContentViewController: UIViewController {
    
    var viewModel: IBankContentViewModel?
    
    var addRouteCompletion: ((IOffice) -> Void)?
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
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
        
        guard let office = self.viewModel?.office else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BankContentDescriptionCell", for: indexPath) as? BankContentDescriptionCell else { return UITableViewCell() }
            cell.setup(office: office)
            cell.button.action = { [weak self] _ in
                self?.showSchedule(office: office)
            }
            cell.closeButton.action = { [weak self] _ in
                self?.dismiss(animated: true)
            }
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WorkTimeCell", for: indexPath) as? WorkTimeCell else { return UITableViewCell() }
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as? ChartCell else { return UITableViewCell() }
            cell.setup(office: office)
            return cell
            
        case 3:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddRouteCell", for: indexPath) as? AddRouteCell else { return UITableViewCell() }
            cell.addRouteButton.action = { [weak self] _ in
                guard let office = self?.viewModel?.office else { return }
                self?.dismiss(animated: true, completion: {
                    self?.addRouteCompletion?(office)
                })
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

//MARK: - Schdule

extension BankContentViewController {
    
    private func showSchedule(office: IOffice) {
        
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.office = office
        
        self.present(scheduleViewController, animated: true)
        
    }
    
}
