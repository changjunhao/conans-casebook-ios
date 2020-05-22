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
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
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
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width * 0.8, height: self.view.bounds.size.width * 0.8 * 7 / 5)
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor]
        gradient.cornerRadius = 10
        gradient.masksToBounds = true
        cardView.layer.addSublayer(gradient)
        
        
    }

    @objc private func handleRotate() {
        UIView.animate(withDuration: 0.5, animations: {
            if self.select {
                self.select = false
                self.imageView.kf.setImage(with: URL(string: self.caseBook.url))
                UIView.setAnimationTransition(.flipFromLeft, for: self.cardView, cache: true)
            } else {
                self.select = true
                self.imageView.kf.setImage(with: URL(string: self.caseBook.urlh))
                UIView.setAnimationTransition(.flipFromLeft, for: self.cardView, cache: true)
            }
        })
    }
}
