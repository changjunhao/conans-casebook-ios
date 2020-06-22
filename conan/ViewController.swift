//
//  ViewController.swift
//  conan
//
//  Created by iFable on 2020/5/18.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var caseCardViewControllers: [UIViewController] = []
    var button: UIButton?
    var caseBookList: [CaseBook]?
    var currentIndex: Int = 0 {
        didSet {
            button?.setTitle(caseBookList![currentIndex].waiting ? "静候上线" : "精彩呈现", for: .normal)
        }
    }
    
    var nextIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backageImage = UIImageView(frame: self.view.bounds)
        backageImage.image = R.image.bgImage()
        backageImage.contentMode = .center
        self.view.addSubview(backageImage)
        
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        self.addChild(pageViewController)
        pageViewController.view.frame = self.view.frame
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        caseBookList = [CaseBook]()
        for i in 0..<21 {
            caseBookList!.append(CaseBook.create(index: i))
        }
        for (_, item) in caseBookList!.enumerated() {
            self.caseCardViewControllers.append(CaseCardViewController(caseBook: item))
        }
        
        pageViewController.setViewControllers([caseCardViewControllers[currentIndex]], direction: .forward, animated: true, completion: nil)
        
        button = UIButton(type: .system)
        button!.backgroundColor = UIColor(red: 22 / 255, green: 24 / 255, blue: 35 / 255, alpha: 1)
        button!.tintColor = UIColor(red: 233 / 255, green: 241 / 255, blue: 246 / 255, alpha: 1)
        button!.setTitle("精彩呈现", for: .normal)
        button!.layer.cornerRadius = 30
        button!.layer.masksToBounds = true
        self.view.addSubview(button!)
        let ch = self.view.bounds.size.width * 0.8 * 7 / 5
        let h = (self.view.bounds.size.height - ch) / 2 + ch
        button!.snp.makeConstraints {
            make in
            make.width.equalTo(120)
            make.height.equalTo(60)
            make.top.equalToSuperview().offset(h + 20)
            make.centerX.equalToSuperview()
        }
        button!.addTarget(self, action: #selector(handleNavigate), for: .touchUpInside)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 显示前一个页面，保证数组不越界
        let index = self.caseCardViewControllers.firstIndex(of: viewController)!
        if index != 0 {
            return self.caseCardViewControllers[index - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // 显示后一个视图页面
        let index = self.caseCardViewControllers.firstIndex(of: viewController)!
        if index + 1 < 21 {
            return self.caseCardViewControllers[index + 1]
        }
        return nil
    }
    
    @objc func handleNavigate() {
        if caseBookList![currentIndex].waiting {
            let alert = UIAlertController(title: nil, message: "静候上线", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(alert, animated: true, completion: nil)
        } else {
            let incidentViewController = IncidentViewController(id: caseBookList![currentIndex].id)
            incidentViewController.title = caseBookList![currentIndex].title
            self.present(UINavigationController(rootViewController: incidentViewController), animated: true, completion: nil)
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController,
                            willTransitionTo pendingViewControllers: [UIViewController]) {
        
        let index = self.caseCardViewControllers.firstIndex(of: pendingViewControllers.first!)!
        nextIndex = index
    }
    
    func pageViewController(_: UIPageViewController, didFinishAnimating: Bool, previousViewControllers: [UIViewController], transitionCompleted: Bool) {
        if (transitionCompleted) {
            currentIndex = nextIndex
        }
    }
    
}

