//
//  PrepareRouteViewController.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import UIKit

protocol PrepareRouteViewControllerDelegate: AnyObject {
    
    func showRoutes(forType type: PrepareRouteViewController.RouteType)
    
}

final class PrepareRouteViewController: UIViewController {
    
    private lazy var scrollView = VerticalContentScrollView()
    
    private var contentView: UIView {
        scrollView.wrapperView
    }
    
    var closeCompletion: (() -> Void)?
    
    weak var delegate: PrepareRouteViewControllerDelegate?
    
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
    
    let closseButton = CloseButton()
    
    var office: IOffice!
    
    weak var mapViewModel: IMapViewModel?
    
    private let padding: CGFloat = 16
    
    private var scrollViewHeightConstraint: NSLayoutConstraint?
    
    enum RouteType {
        case drive
        case pedastrian
    }
    
    private(set) var activeRouteType: RouteType? {
        didSet {
            self.updateButtons()
            guard let activeRouteType = activeRouteType else { return }
            self.delegate?.showRoutes(forType: activeRouteType)
        }
    }
    
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
        
        self.scheduleCarTypeView.button.action = { [weak self] _ in
            self?.activeRouteType = .drive
        }
        
        self.scheduleCarTypeView.action = { [weak self] in
            self?.activeRouteType = .drive
        }
        
        self.scheduleWalkTypeView.action = { [weak self] in
            self?.activeRouteType = .pedastrian
        }
        
        self.scheduleWalkTypeView.button.action = { [weak self] _ in
            self?.activeRouteType = .pedastrian
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateTitle()
        self.activeRouteType = .drive
    }
    
    private func setupScrollView() {
        self.scrollView.bounces = true
        self.scrollView.alwaysBounceHorizontal = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.alwaysBounceVertical = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollViewHeightConstraint?.constant = self.contentView.bounds.height
    }
    
    func updateTitle() {
        self.scheduleCarTypeView.title.text = self.mapViewModel?.driverRouteService.summary?.weight.timeWithTraffic.text
        self.scheduleWalkTypeView.title.text = self.mapViewModel?.pedastrinaRouteService.summary?.weight.time.text
    }
    
    private func updateButtons() {
        self.scheduleCarTypeView.layer.borderColor = self.activeRouteType == .drive ? AppColor.primary.cgColor : nil
        self.scheduleCarTypeView.layer.borderWidth = self.activeRouteType == .drive ? 1 : 0
        self.scheduleWalkTypeView.layer.borderColor = self.activeRouteType == .pedastrian ? AppColor.primary.cgColor : nil
        self.scheduleWalkTypeView.layer.borderWidth = self.activeRouteType == .pedastrian ? 1 : 0
    }
    
}

//MARK: - layout

extension PrepareRouteViewController {
    
    private func layout() {
        self.layoutScrollView()
        self.layoutContent()
    }
    
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
    
    private func layoutContent() {
        
        self.scheduleCarTypeView.translatesAutoresizingMaskIntoConstraints = false
        self.scheduleWalkTypeView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.scheduleCarTypeView)
        self.contentView.addSubview(self.scheduleWalkTypeView)
        
        self.scheduleCarTypeView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: padding).isActive = true
        self.scheduleCarTypeView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding).isActive = true
        self.scheduleCarTypeView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding).isActive = true
        self.scheduleCarTypeView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        self.scheduleWalkTypeView.leadingAnchor.constraint(equalTo: self.scheduleCarTypeView.trailingAnchor, constant: padding).isActive = true
        self.scheduleWalkTypeView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: padding).isActive = true
        self.scheduleWalkTypeView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -padding).isActive = true
        self.scheduleWalkTypeView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
    }
    
}
