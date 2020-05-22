//
//  CaseCardViewController.swift
//  conan
//
//  Created by iFable on 2020/5/22.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit
import Kingfisher
import SnapKit

class CaseCardViewController: UIViewController {
    
    var caseBook: CaseBook!
    var imageView: UIImageView?
    
    init(caseBook: CaseBook) {
        super.init(nibName: nil, bundle: nil)
        self.caseBook = caseBook
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let uiView = UIView()
        // 阴影颜色
        uiView.layer.shadowColor = UIColor.black.cgColor
        // 阴影偏移，默认(0, -3)
        uiView.layer.shadowOffset = CGSize(width: 0,height: 2)
        // 阴影透明度，默认0
        uiView.layer.shadowOpacity = 0.6
        // 阴影半径，默认3
        uiView.layer.shadowRadius = 14

        self.view.addSubview(uiView)
        uiView.snp.makeConstraints {
            make in
            make.width.equalTo(self.view.bounds.size.width * 0.8)
            make.height.equalTo(self.view.bounds.size.width * 0.8 * 7 / 5)
            make.center.equalTo(self.view)
        }

        imageView = UIImageView()
        imageView?.layer.cornerRadius = 10
        imageView?.layer.masksToBounds = true
        uiView.addSubview(imageView!)
        imageView?.snp.makeConstraints {
            make in
            make.width.equalTo(uiView)
            make.height.equalTo(uiView)
            make.center.equalTo(uiView)
        }
        imageView?.kf.setImage(with: URL(string: self.caseBook.url))
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width * 0.8, height: self.view.bounds.size.width * 0.8 * 7 / 5)
        uiView.layer.addSublayer(gradient)
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor]
        gradient.locations = [0.2, 1]
        gradient.cornerRadius = 10
        gradient.masksToBounds = true
    }

}
