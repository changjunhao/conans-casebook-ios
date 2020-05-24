//
//  ViewController.swift
//  conan
//
//  Created by iFable on 2020/5/18.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var currentIndex: Int = 0
    var caseCardViewControllers: [UIViewController] = []

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

        var caseBookList: [CaseBook] = []
        for i in 0..<21 {
            caseBookList.append(CaseBook(id: i + 1, url: "https://oss-materials.ifable.cn/conan/m\(i + 1).jpg?imageView2/0/interlace/1", urlh: "https://oss-materials.ifable.cn/conan/m\(i == 20 ? 1 : i + 1)h.jpg?imageView2/0/interlace/1", logo: "https://oss-materials.ifable.cn/conan/m\(i + 1)logo.png", year: 1997 + i, waiting: 1997 + i > 2009))
        }
        for (_, item) in caseBookList.enumerated() {
            self.caseCardViewControllers.append(CaseCardViewController(caseBook: item))
        }
        
        pageViewController.setViewControllers([caseCardViewControllers[currentIndex]], direction: .forward, animated: true, completion: nil)
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
    
}

