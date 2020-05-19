//
//  ViewController.swift
//  conan
//
//  Created by iFable on 2020/5/18.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

struct casebook {
    var id: Int
    var url: String
    var logo: String
    var year: Int
    var waiting: Bool
}

class ViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var currentIndex: Int = 0
    var viewControllers: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backageImage = UIImageView(frame: self.view.bounds)
        let imageData = try? Data(contentsOf: URL(string: "https://www.aptx.cn/incident/images/indexbg.jpg")!)
        backageImage.image = UIImage(data: imageData!)
        backageImage.contentMode = .center
        self.view.addSubview(backageImage)
        
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        self.addChild(pageViewController)
        pageViewController.view.frame = self.view.frame
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        var caseBookList: [casebook] = []
        for i in 0..<21 {
            caseBookList.append(casebook(id: i + 1, url: "https://oss-materials.ifable.cn/conan/m\(i + 1).jpg?imageView2/0/interlace/1", logo: "https://oss-materials.ifable.cn/conan/m\(i + 1)logo.png", year: 1997 + i, waiting: 1997 + i > 2009))
        }
        for (_, item) in caseBookList.enumerated() {
            let viewCon = UIViewController()
            let uiView = UIView()
            // 阴影颜色
            uiView.layer.shadowColor = UIColor.black.cgColor
            // 阴影偏移，默认(0, -3)
            uiView.layer.shadowOffset = CGSize(width: 0,height: 2)
            // 阴影透明度，默认0
            uiView.layer.shadowOpacity = 0.6
            // 阴影半径，默认3
            uiView.layer.shadowRadius = 14

            viewCon.view.addSubview(uiView)
            uiView.snp.makeConstraints {
                make in
                make.width.equalTo(viewCon.view.bounds.size.width * 0.8)
                make.height.equalTo(viewCon.view.bounds.size.width * 0.8 * 7 / 5)
                make.center.equalTo(viewCon.view)
            }

            let imageView = UIImageView()
            imageView.layer.cornerRadius = 10
            imageView.layer.masksToBounds = true
            uiView.addSubview(imageView)
            imageView.snp.makeConstraints {
                make in
                make.width.equalTo(uiView)
                make.height.equalTo(uiView)
                make.center.equalTo(uiView)
            }
            imageView.kf.setImage(with: URL(string: item.url))
            
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: 0, y: 0, width: viewCon.view.bounds.size.width * 0.8, height: viewCon.view.bounds.size.width * 0.8 * 7 / 5)
            uiView.layer.addSublayer(gradient)
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0, y: 1)
            gradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.9).cgColor]
            
            self.viewControllers.append(viewCon)
        }
        
        pageViewController.setViewControllers([viewControllers[currentIndex]],
                                                     direction: .forward,
                                                     animated: true,
                                                     completion: nil)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // 显示前一个页面，保证数组不越界
        let index = self.viewControllers.firstIndex(of: viewController)!
        if index != 0 {
            return self.viewControllers[index - 1]
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // 显示后一个视图页面
        let index = self.viewControllers.firstIndex(of: viewController)!
        if index + 1 < 21 {
            return self.viewControllers[index + 1]
        }
        return nil
    }
    
}

