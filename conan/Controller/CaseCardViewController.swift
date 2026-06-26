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

    private let caseBook: CaseBook
    private var cardView: UIView
    private var imageView: UIImageView
    private var logoImageView: UIImageView
    private var isFlipped: Bool = false

    /// 由外部注入的导航回调，替代内联的导航逻辑
    var onNavigate: (() -> Void)?

    init(caseBook: CaseBook) {
        cardView = UIView()
        // 阴影颜色
        cardView.layer.shadowColor = UIColor.black.cgColor
        // 阴影偏移，默认(0, -3)
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        // 阴影透明度，默认0
        cardView.layer.shadowOpacity = 0.6
        // 阴影半径，默认3
        cardView.layer.shadowRadius = 14

        imageView = UIImageView()
        logoImageView = UIImageView()

        self.caseBook = caseBook
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let cardWidth = self.view.bounds.size.width * CardLayout.widthRatio
        let cardHeight = cardWidth * CardLayout.aspectRatio

        self.view.addSubview(cardView)
        cardView.snp.makeConstraints {
            make in
            make.width.equalTo(cardWidth)
            make.height.equalTo(cardHeight)
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
        caShapeLayer.path = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight),
            byRoundingCorners: .allCorners,
            cornerRadii: CGSize(width: CardLayout.cornerRadius, height: CardLayout.cornerRadius)
        ).cgPath
        imageView.layer.mask = caShapeLayer

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: cardWidth, height: cardHeight)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor]
        imageView.layer.addSublayer(gradientLayer)

        cardView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            make in
            make.width.equalTo(self.view.bounds.size.width * CardLayout.logoWidthRatio)
            make.height.equalTo(CardLayout.logoHeight)
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
        UIView.transition(with: cardView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            if self.isFlipped {
                self.isFlipped = false
                self.imageView.kf.setImage(with: URL(string: self.caseBook.url))
                self.logoImageView.kf.setImage(with: URL(string: self.caseBook.logo))
            } else {
                self.isFlipped = true
                self.imageView.kf.setImage(with: URL(string: self.caseBook.urlh))
                let flippedLogoUrl = self.caseBook.waiting
                    ? APIConfiguration.waitingLogo
                    : APIConfiguration.availableLogo
                self.logoImageView.kf.setImage(with: URL(string: flippedLogoUrl))
            }
        }, completion: nil)
    }

    @objc private func handleNavigate() {
        onNavigate?()
    }
}
