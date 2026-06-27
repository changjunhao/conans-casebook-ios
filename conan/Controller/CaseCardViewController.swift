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
    private var gradientLayer = CAGradientLayer()
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
        imageView.layer.masksToBounds = true
        logoImageView = UIImageView()

        self.caseBook = caseBook
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(cardView)
        cardView.snp.makeConstraints {
            make in
            make.width.equalTo(self.view.snp.width).multipliedBy(CardLayout.widthRatio)
            make.height.equalTo(cardView.snp.width).multipliedBy(CardLayout.aspectRatio)
            make.center.equalTo(self.view)
        }
        cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleRotate)))

        cardView.addSubview(imageView)
        imageView.snp.makeConstraints {
            make in
            make.edges.equalToSuperview()
        }
        let imgOptions: KingfisherOptionsInfo? = caseBook.waiting
            ? [.processor(BlackWhiteProcessor())]
            : nil
        imageView.kf.setImage(
            with: URL(string: self.caseBook.url),
            placeholder: UIImage(named: "caseIcon"),
            options: imgOptions
        )
        imageView.layer.cornerRadius = CardLayout.cornerRadius

        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor]
        imageView.layer.addSublayer(gradientLayer)

        cardView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints {
            make in
            make.width.equalTo(self.view.snp.width).multipliedBy(CardLayout.logoWidthRatio)
            make.height.equalTo(CardLayout.logoHeight)
            make.bottom.equalTo(-20)
            make.centerX.equalTo(cardView)
        }
        let logoOptions: KingfisherOptionsInfo? = caseBook.waiting
            ? [.processor(BlackWhiteProcessor())]
            : nil
        logoImageView.kf.setImage(
            with: URL(string: self.caseBook.logo),
            placeholder: UIImage(named: "caseIcon"),
            options: logoOptions
        )
        logoImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleNavigate))
        logoImageView.addGestureRecognizer(tapGestureRecognizer)

        let triangleView = TriangleView(caseBook: self.caseBook)
        imageView.addSubview(triangleView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = imageView.bounds
    }

    @objc private func handleRotate() {
        let imgOptions: KingfisherOptionsInfo? = caseBook.waiting
            ? [.processor(BlackWhiteProcessor())]
            : nil

        UIView.transition(with: cardView, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            if self.isFlipped {
                self.isFlipped = false
                self.imageView.kf.setImage(with: URL(string: self.caseBook.url), options: imgOptions)
                self.logoImageView.kf.setImage(with: URL(string: self.caseBook.logo), options: imgOptions)
            } else {
                self.isFlipped = true
                self.imageView.kf.setImage(with: URL(string: self.caseBook.urlh), options: imgOptions)
                let flippedLogoUrl = self.caseBook.waiting
                    ? APIConfiguration.waitingLogo
                    : APIConfiguration.availableLogo
                self.logoImageView.kf.setImage(with: URL(string: flippedLogoUrl), options: imgOptions)
            }
        }, completion: nil)
    }

    @objc private func handleNavigate() {
        onNavigate?()
    }
}
