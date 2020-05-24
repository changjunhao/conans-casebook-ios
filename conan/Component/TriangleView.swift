//
//  TriangleView.swift
//  conan
//
//  Created by iFable on 2020/5/24.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit
import SnapKit

class TriangleView: UIView {

    init(caseBook: CaseBook) {
        super.init(frame: CGRect(x: 0, y: 0, width: 56, height: 56))

        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                
        let label = UILabel()
        label.text = String(caseBook.year)
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.baselineAdjustment = .alignCenters
        label.textAlignment = .center
        self.addSubview(label)
        label.snp.makeConstraints {
            make in
            make.width.equalTo(self)
            make.height.equalTo(self)
            make.top.equalTo(-8)
            make.left.equalTo(-8)
        }
        label.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 4))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setAllowsAntialiasing(true) //抗锯齿设置
        context.setFillColor(UIColor(red: 1, green: 0.8, blue: 0.18, alpha: 1).cgColor)
        let p1: CGMutablePath = CGMutablePath()
        p1.addLines(between: [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 56), CGPoint(x: 56, y: 0)])
        context.addPath(p1)
        context.fillPath()
        context.strokePath()
    }

}
