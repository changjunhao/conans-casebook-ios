//
//  CaseBookListViewController.swift
//  conan
//
//  Created by iFable on 2020/5/18.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit
import SnapKit

class CaseBookListViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    private let caseBookService: CaseBookProviding
    private let coordinator: AppCoordinator

    private var caseCardViewControllers: [UIViewController] = []
    private let button = UIButton(type: .system)
    private var caseBookList: [CaseBook] = []
    private var nextIndex: Int = 0
    private var pageViewController: UIPageViewController!
    private var buttonTopConstraint: Constraint?

    var currentIndex: Int = 0 {
        didSet {
            guard caseBookList.indices.contains(currentIndex) else { return }
            button.setTitle(
                caseBookList[currentIndex].waiting
                    ? String(localized: "静候上线")
                    : String(localized: "精彩呈现"),
                for: .normal
            )
        }
    }

    init(caseBookService: CaseBookProviding, coordinator: AppCoordinator) {
        self.caseBookService = caseBookService
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBackground()
        setupPageViewController()
        loadCaseBooks()
        setupButton()
    }

    // MARK: - UI Setup

    private func setupBackground() {
        let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "bgImage")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            make in
            make.edges.equalToSuperview()
        }
    }

    private func setupPageViewController() {
        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.delegate = self
        pageViewController.dataSource = self

        self.addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        pageViewController.didMove(toParent: self)
    }

    private func loadCaseBooks() {
        caseBookList = caseBookService.fetchCaseBooks()
        guard !caseBookList.isEmpty else {
            showEmptyState()
            return
        }
        caseCardViewControllers = caseBookList.map { caseBook in
            let vc = CaseCardViewController(caseBook: caseBook)
            vc.onNavigate = { [weak self] in
                guard let self = self else { return }
                self.coordinator.navigate(from: self, caseBook: caseBook)
            }
            return vc
        }
        pageViewController.setViewControllers(
            [caseCardViewControllers[currentIndex]],
            direction: .forward,
            animated: true
        )
    }

    private func showEmptyState() {
        let label = UILabel()
        label.text = String(localized: "暂无数据")
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 17)
        self.view.addSubview(label)
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }

    private func setupButton() {
        button.backgroundColor = UIColor.secondarySystemBackground
        button.tintColor = .label
        button.setTitle(String(localized: "精彩呈现"), for: .normal)
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        self.view.addSubview(button)

        button.snp.makeConstraints {
            make in
            make.width.equalTo(120)
            make.height.equalTo(60)
            buttonTopConstraint = make.top.equalToSuperview().offset(0).constraint
            make.centerX.equalToSuperview()
        }
        button.addTarget(self, action: #selector(handleNavigate), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let cardBottom = CardLayout.bottomYOffset(viewBounds: self.view.bounds)
        buttonTopConstraint?.update(offset: cardBottom)
    }

    // MARK: - Actions

    @objc private func handleNavigate() {
        guard caseBookList.indices.contains(currentIndex) else { return }
        coordinator.navigate(from: self, caseBook: caseBookList[currentIndex])
    }

    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.caseCardViewControllers.firstIndex(of: viewController) else { return nil }
        if index != 0 {
            return self.caseCardViewControllers[index - 1]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.caseCardViewControllers.firstIndex(of: viewController) else { return nil }
        if index + 1 < caseBookList.count {
            return self.caseCardViewControllers[index + 1]
        }
        return nil
    }

    // MARK: - UIPageViewControllerDelegate

    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let viewController = pendingViewControllers.first,
              let index = self.caseCardViewControllers.firstIndex(of: viewController) else { return }
        nextIndex = index
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed {
            currentIndex = nextIndex
        }
    }
}
