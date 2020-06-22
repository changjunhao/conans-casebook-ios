//
//  noticeCollectionReusableView.swift
//  conan
//
//  Created by iFable on 2020/6/22.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit
import Kingfisher
import Rswift

class noticeCollectionReusableView: UICollectionReusableView {
    var noticeImageUrl: String? {
        didSet {
            initView()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func initView(){
        if noticeImageUrl != nil {
            let noticeImage = UIImageView()
            noticeImage.kf.setImage(with: URL(string: noticeImageUrl!), placeholder: R.image.caseIcon())
            self.addSubview(noticeImage)
            noticeImage.snp.makeConstraints {
                make in
                make.width.equalTo(self.bounds.size.width * 0.9)
                make.height.equalTo(self.bounds.size.width * 0.9 * 0.64)
                make.centerX.equalToSuperview()
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
