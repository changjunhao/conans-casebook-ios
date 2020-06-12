//
//  IncidentItem.swift
//  conan
//
//  Created by iFable on 2020/6/12.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit
import SnapKit

class IncidentItem: UIView {
    
    var item: IncidentSectionItem? {
        didSet {
            self.setData()
        }
    }
    var titleLable: UILabel
    var imageView: UIImageView?
    var descView: UIView?
    
    override init(frame: CGRect) {
        titleLable = UILabel()
        titleLable.backgroundColor = UIColor(red: 1, green: 1, blue: 255, alpha: 0.9)
        titleLable.textColor = UIColor(red: 0.05, green: 0.62, blue: 0.64, alpha: 1.00)
        titleLable.font = .systemFont(ofSize: 16)
        titleLable.textAlignment = .center
        super.init(frame: frame)
        self.addSubview(titleLable)
        titleLable.snp.makeConstraints {
            make in
            make.width.equalTo(frame.width * 0.9)
            make.height.equalTo(26)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData() {
        titleLable.text = item?.title
    }
}
