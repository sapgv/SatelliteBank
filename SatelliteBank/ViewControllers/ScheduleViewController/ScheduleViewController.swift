//
//  ScheduleViewController.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 15.10.2023.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    var office: IOffice?
    
    var date: Date = Date()
    
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
        self.tableView.register(UINib(nibName: "BankDescriptionCell", bundle: nil), forCellReuseIdentifier: BankDescriptionCell.id)
        self.tableView.register(UINib(nibName: "ScheduleTimeCell", bundle: nil), forCellReuseIdentifier: ScheduleTimeCell.id)
        self.tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: ButtonCell.id)
    }
    
}

extension ScheduleViewController {
    
    private func layout() {
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.tableView)
        
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
    }
    
}

extension ScheduleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let office = self.office else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "BankDescriptionCell", for: indexPath) as? BankDescriptionCell else { return UITableViewCell() }
            cell.setup(office: office)
            cell.closeButton.action = { [weak self] _ in
                self?.dismiss(animated: true)
            }
            return cell
            
        case 1:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTimeCell", for: indexPath) as? ScheduleTimeCell else { return UITableViewCell() }
            cell.datePicker.setDate(self.date, animated: false)
            return cell
            
        case 2:
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as? ButtonCell else { return UITableViewCell() }
            cell.button.action = { [weak self] _ in
                self?.addSchedule()
                
            }
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    private var dateDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        let text = dateFormatter.string(from: self.date)
        return text
    }
    
    private func addSchedule() {
        
        let alertController = UIAlertController()
        alertController.title = "Посещение"
        alertController.message = "Успешно записали вас на время \(dateDescription)"
        
        let action = UIAlertAction(title: "Готово", style: .default) { _ in
            self.dismiss(animated: true)
        }
        
        alertController.addAction(action)
        
        self.present(alertController, animated: true)
        
    }
    
}

extension ScheduleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
