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
    
    private var caseBook: CaseBook!
    private var cardView: UIView
    private var imageView: UIImageView
    private var logoImageView: UIImageView
    private var select: Bool = false
    
    init(caseBook: CaseBook) {
        cardView = UIView()
        // 阴影颜色
        cardView.layer.shadowColor = UIColor.black.cgColor
        // 阴影偏移，默认(0, -3)
        cardView.layer.shadowOffset = CGSize(width: 0,height: 2)
        // 阴影透明度，默认0
        cardView.layer.shadowOpacity = 0.6
        // 阴影半径，默认3
        cardView.layer.shadowRadius = 14
        
        imageView = UIImageView()
//        imageView.layer.cornerRadius = 10
//        imageView.layer.masksToBounds = true
        logoImageView = UIImageView()
        
        super.init(nibName: nil, bundle: nil)
        self.caseBook = caseBook
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(cardView)
        cardView.snp.makeConstraints {
            make in
            make.width.equalTo(self.view.bounds.size.width * 0.8)
            make.height.equalTo(self.view.bounds.size.width * 0.8 * 7 / 5)
            make.center.equalTo(self.view)
        }
        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRotate)))

        cardView.addSubview(imageView)
        imageView.snp.makeConstraints {
            make in
            make.width.equalTo(cardView)
            make.height.equalTo(cardView)
            make.center.equalTo(cardView)
        }
        imageView.kf.setImage(with: URL(string: self.caseBook.url))
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.path = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: self.view.bounds.size.width * 0.8, height: self.view.bounds.size.width * 0.8 * 7 / 5), byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 10, height: 10)).cgPath
        imageView.layer.mask = caShapeLayer
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width * 0.8, height: self.view.bounds.size.width * 0.8 * 7 / 5)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor]
        imageView.layer.addSublayer(gradientLayer)
        
        cardView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            make in
            make.width.equalTo(self.view.bounds.size.width * 0.72)
            make.height.equalTo(52)
            make.bottom.equalTo(-20)
            make.centerX.equalTo(cardView)
        }
        logoImageView.kf.setImage(with: URL(string: self.caseBook.logo))
        logoImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleNavigate))
        logoImageView.addGestureRecognizer(tapGestureRecognizer)
        
        let triangleView = TriangleView(caseBook: self.caseBook)
        imageView.addSubview(triangleView)
    }

    @objc private func handleRotate() {
        UIView.animate(withDuration: 0.5, animations: {
            if self.select {
                self.select = false
                self.imageView.kf.setImage(with: URL(string: self.caseBook.url))
                self.logoImageView.kf.setImage(with: URL(string: self.caseBook.logo))
            } else {
                self.select = true
                self.imageView.kf.setImage(with: URL(string: self.caseBook.urlh))
                if self.caseBook.waiting {
                    self.logoImageView.kf.setImage(with: URL(string: "https://oss-materials.ifable.cn/conan/mov-e.png"))
                } else {
                    self.logoImageView.kf.setImage(with: URL(string: "https://oss-materials.ifable.cn/conan/mov-d.png"))
                }
            }
            UIView.setAnimationTransition(.flipFromLeft, for: self.cardView, cache: true)
        })
    }
    
    @objc func handleNavigate() {
        if self.caseBook.waiting {
            let alert = UIAlertController(title: nil, message: "静候上线", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            self.present(alert, animated: true, completion: nil)
        } else {
            let viewController = IncidentViewController(id: self.caseBook.id)
            viewController.view.backgroundColor = .white
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
