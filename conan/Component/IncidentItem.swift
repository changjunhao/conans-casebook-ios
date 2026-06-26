//
//  IncidentItem.swift
//  conan
//
//  Created by iFable on 2020/6/12.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class IncidentItem: UICollectionViewCell {
    
    var item: IncidentSectionItem? {
        didSet {
            self.setData()
        }
    }
    var titleLabel: UILabel
    var imageView: UIImageView
    var descLabel: UILabel
    var descView: UIView
    
    override init(frame: CGRect) {
        titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        titleLabel.textColor = .label
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        
        imageView = UIImageView()
        
        descView = UIView()
        descView.backgroundColor = UIColor(red: 0.05, green: 0.7, blue: 0.64, alpha: 1.00)
        descLabel = UILabel()
        descLabel.textColor = .white
        descLabel.font = .systemFont(ofSize: 15)
        descLabel.numberOfLines = 0
        descView.sizeToFit()
        descView.addSubview(descLabel)
    
        super.init(frame: frame)
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            make in
            make.width.equalTo(frame.width * 0.9)
            make.height.equalTo(26)
            make.centerX.equalToSuperview()
        }
        
        let caShapeLayer1 = CAShapeLayer()
        caShapeLayer1.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: frame.width * 0.9, height: 26), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        titleLabel.layer.mask = caShapeLayer1
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints {
            make in
            make.width.equalTo(frame.width * 0.9)
            make.height.equalTo(frame.width * 0.54)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        self.addSubview(descView)
        descView.snp.makeConstraints {
            make in
            make.width.equalTo(frame.width * 0.9)
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
        }
        
        descLabel.snp.makeConstraints {
            make in
            make.centerX.equalToSuperview()
            make.top.left.equalTo(10)
            make.right.bottom.equalTo(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.kf.cancelDownloadTask()
        titleLabel.text = nil
        descLabel.text = nil
        descLabel.attributedText = nil
    }
    
    func setData() {
        guard let item = item else { return }
        titleLabel.text = item.title
        // 使用 UIImage(named:) 直接加载图片
        let placeholderImage = UIImage(named: "caseIcon") ?? UIImage()
        imageView.kf.setImage(with: URL(string: item.image), placeholder: placeholderImage)
        descLabel.text = item.desc
        //通过富文本来设置行间距
        let paraph = NSMutableParagraphStyle()
        //将行间距设置为5
        paraph.lineSpacing = 5
        //样式属性集合
        let attributes = [NSAttributedString.Key.paragraphStyle: paraph]
        descLabel.attributedText = NSAttributedString(string: item.desc, attributes: attributes)
    }
}
