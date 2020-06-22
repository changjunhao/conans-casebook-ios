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
    var titleLable: UILabel
    var imageView: UIImageView
    var descLabel: UILabel
    var descView: UIView
    
    override init(frame: CGRect) {
        titleLable = UILabel()
        titleLable.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        titleLable.textColor = UIColor(red: 0.05, green: 0.62, blue: 0.64, alpha: 1.00)
        titleLable.font = .systemFont(ofSize: 16)
        titleLable.textAlignment = .center
        
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
        self.addSubview(titleLable)
        titleLable.snp.makeConstraints {
            make in
            make.width.equalTo(frame.width * 0.9)
            make.height.equalTo(26)
            make.centerX.equalToSuperview()
        }
        
        let caShapeLayer1 = CAShapeLayer()
        caShapeLayer1.path = UIBezierPath.init(roundedRect: CGRect(x: 0, y: 0, width: frame.width * 0.9, height: 26), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        titleLable.layer.mask = caShapeLayer1
        
        self.addSubview(imageView)
        imageView.snp.makeConstraints {
            make in
            make.width.equalTo(frame.width * 0.9)
            make.height.equalTo(frame.width * 0.54)
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLable.snp.bottom)
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
    
    func setData() {
        titleLable.text = item?.title
        imageView.kf.setImage(with: URL(string: item!.image), placeholder: R.image.caseIcon())
        descLabel.text = item?.desc
        //通过富文本来设置行间距
        let paraph = NSMutableParagraphStyle()
        //将行间距设置为28
        paraph.lineSpacing = 5
        //样式属性集合
        let attributes = [NSAttributedString.Key.paragraphStyle: paraph]
        descLabel.attributedText = NSAttributedString(string: item!.desc, attributes: attributes)
    }
}
