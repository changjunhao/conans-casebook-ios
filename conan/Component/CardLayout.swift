//
//  CardLayout.swift
//  conan
//
//  Created by iFable on 2025/6/26.
//  Copyright © 2025 iFable. All rights reserved.
//

import CoreGraphics

/// 卡片布局常量，供 CaseCardViewController 和 CaseBookListViewController 共享使用
enum CardLayout {
    /// 卡片宽度占屏幕宽度的比例
    static let widthRatio: CGFloat = 0.8

    /// 卡片高宽比（高 / 宽）
    static let aspectRatio: CGFloat = 7.0 / 5.0

    /// 卡片圆角半径
    static let cornerRadius: CGFloat = 10

    /// Logo 高度
    static let logoHeight: CGFloat = 52

    /// Logo 宽度占屏幕宽度的比例
    static let logoWidthRatio: CGFloat = 0.72

    /// 根据视图宽度计算卡片高度
    static func cardHeight(viewWidth: CGFloat) -> CGFloat {
        viewWidth * widthRatio * aspectRatio
    }

    /// 计算卡片底部距视图顶部的偏移量（含 20pt 间距，用于按钮定位）
    static func bottomYOffset(viewBounds: CGRect) -> CGFloat {
        let cardH = cardHeight(viewWidth: viewBounds.size.width)
        let cardTopY = (viewBounds.size.height - cardH) / 2
        return cardTopY + cardH + 20
    }
}
