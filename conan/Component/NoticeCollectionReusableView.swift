//
//  NoticeCollectionReusableView.swift
//  conan
//
//  Created by iFable on 2020/6/22.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit
import Kingfisher

class NoticeCollectionReusableView: UICollectionReusableView {
    private let noticeImage = UIImageView()
    private var hasSetupConstraints = false

    var noticeImageUrl: String? {
        didSet {
            guard let urlString = noticeImageUrl else { return }
            let placeholderImage = UIImage(named: "caseIcon") ?? UIImage()
            noticeImage.kf.setImage(with: URL(string: urlString), placeholder: placeholderImage)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(noticeImage)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard !hasSetupConstraints, bounds.size.width > 0 else { return }
        hasSetupConstraints = true
        noticeImage.snp.makeConstraints {
            make in
            make.width.equalTo(self.bounds.size.width * 0.9)
            make.height.equalTo(self.bounds.size.width * 0.9 * 0.64)
            make.centerX.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        noticeImage.kf.cancelDownloadTask()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
