//
//  PrepareRouteViewController.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import UIKit

final class PrepareRouteViewController: UIViewController {
    
    private lazy var scrollView = ContentScrollView()
    
    private var contentView: UIView {
        scrollView.wrapperView
    }
    
    var closeCompletion: (() -> Void)?
    
    private let labelFrom: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Мое местонахождение"
        return label
    }()
    
    private lazy var labelTo: UILabel = { [weak self] in
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = self?.office?.salePointName ?? "Банк"
        return label
    }()
    
    private let scheduleCarTypeView = ScheduleTypeView<ScheduleCarRouteButton>()
    
    private let scheduleWalkTypeView = ScheduleTypeView<ScheduleWalkRouteButton>()
    
    private let scheduleBusTypeView = ScheduleTypeView<ScheduleBusRouteButton>()
    
    let closseButton = CloseButton()
    
    var office: IOffice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelTo.text = self.office?.salePointName ?? "Банк"
        self.setupScrollView()
        self.layout()
        self.closseButton.action = { [weak self] _ in
            self?.dismiss(animated: true) {
                self?.closeCompletion?()
            }
        }
    }
    
    private func setupScrollView() {
        self.scrollView.bounces = true
        self.scrollView.alwaysBounceHorizontal = true
        self.scrollView.showsHorizontalScrollIndicator = false
    }
    
    private func layout() {
        
        self.layoutScrollView()
        self.layoutContent()
        
        
    }
    
    private let padding: CGFloat = 16
    
    private func layoutScrollView() {
        
        self.labelFrom.translatesAutoresizingMaskIntoConstraints = false
        self.labelTo.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.closseButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.scrollView)
        self.view.addSubview(self.labelFrom)
        self.view.addSubview(self.labelTo)
        self.view.addSubview(self.closseButton)
        
        self.closseButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.closseButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.closseButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        self.closseButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        self.labelFrom.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
        self.labelFrom.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: padding).isActive = true
        self.labelFrom.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -padding).isActive = true
        
        self.labelTo.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: padding).isActive = true
        self.labelTo.topAnchor.constraint(equalTo: self.labelFrom.bottomAnchor, constant: padding).isActive = true
        self.labelTo.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -padding).isActive = true
        
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.labelTo.bottomAnchor, constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.scrollViewHeightConstraint = self.scrollView.heightAnchor.constraint(equalToConstant: 100)
        self.scrollViewHeightConstraint?.isActive = true
        
    }
    
    private var scrollViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollViewHeightConstraint?.constant = self.contentView.bounds.height
    }
    
    private func layoutContent() {
        
        self.scheduleCarTypeView.translatesAutoresizingMaskIntoConstraints = false
        self.scheduleWalkTypeView.translatesAutoresizingMaskIntoConstraints = false
        self.scheduleBusTypeView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.scheduleCarTypeView)
        self.contentView.addSubview(self.scheduleWalkTypeView)
        self.contentView.addSubview(self.scheduleBusTypeView)
        
        self.scheduleCarTypeView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding).isActive = true
        self.scheduleCarTypeView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding).isActive = true
        self.scheduleCarTypeView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding).isActive = true
        self.scheduleCarTypeView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        self.scheduleCarTypeView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        self.scheduleWalkTypeView.leadingAnchor.constraint(equalTo: self.scheduleCarTypeView.trailingAnchor, constant: padding).isActive = true
        self.scheduleWalkTypeView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding).isActive = true
        self.scheduleWalkTypeView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding).isActive = true
        self.scheduleWalkTypeView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        self.scheduleWalkTypeView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        
        self.scheduleBusTypeView.leadingAnchor.constraint(equalTo: self.scheduleWalkTypeView.trailingAnchor, constant: padding).isActive = true
        self.scheduleBusTypeView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding).isActive = true
        self.scheduleBusTypeView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding).isActive = true
        self.scheduleBusTypeView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        self.scheduleBusTypeView.heightAnchor.constraint(equalToConstant: 64).isActive = true

    }
    
}
