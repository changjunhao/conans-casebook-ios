//
//  CardLayoutTests.swift
//  conanTests
//

import XCTest
import CoreGraphics
@testable import conan

final class CardLayoutTests: XCTestCase {

    // MARK: - 常量

    func testWidthRatio() {
        XCTAssertEqual(CardLayout.widthRatio, 0.8, accuracy: 0.001)
    }

    func testAspectRatio() {
        XCTAssertEqual(CardLayout.aspectRatio, 7.0 / 5.0, accuracy: 0.001)
    }

    func testCornerRadius() {
        XCTAssertEqual(CardLayout.cornerRadius, 10, accuracy: 0.001)
    }

    func testLogoHeight() {
        XCTAssertEqual(CardLayout.logoHeight, 52, accuracy: 0.001)
    }

    func testLogoWidthRatio() {
        XCTAssertEqual(CardLayout.logoWidthRatio, 0.72, accuracy: 0.001)
    }

    // MARK: - cardHeight

    func testCardHeightIPhoneSE() {
        // iPhone SE 宽度 375
        let viewWidth: CGFloat = 375
        let expected = viewWidth * 0.8 * (7.0 / 5.0)
        XCTAssertEqual(CardLayout.cardHeight(viewWidth: viewWidth), expected, accuracy: 0.01)
    }

    func testCardHeightIPhone15() {
        // iPhone 15 宽度 393
        let viewWidth: CGFloat = 393
        let expected = viewWidth * 0.8 * (7.0 / 5.0)
        XCTAssertEqual(CardLayout.cardHeight(viewWidth: viewWidth), expected, accuracy: 0.01)
    }

    func testCardHeightZero() {
        XCTAssertEqual(CardLayout.cardHeight(viewWidth: 0), 0, accuracy: 0.001)
    }

    // MARK: - bottomYOffset

    func testBottomYOffsetIPhoneSE() {
        let bounds = CGRect(x: 0, y: 0, width: 375, height: 667)
        let cardH = CardLayout.cardHeight(viewWidth: 375)
        let cardTopY = (667 - cardH) / 2
        let expected = cardTopY + cardH + 20
        XCTAssertEqual(CardLayout.bottomYOffset(viewBounds: bounds), expected, accuracy: 0.01)
    }

    func testBottomYOffsetLandscape() {
        let bounds = CGRect(x: 0, y: 0, width: 812, height: 375)
        let cardH = CardLayout.cardHeight(viewWidth: 812)
        let cardTopY = (375 - cardH) / 2
        let expected = cardTopY + cardH + 20
        XCTAssertEqual(CardLayout.bottomYOffset(viewBounds: bounds), expected, accuracy: 0.01)
    }

    func testBottomYOffsetAlwaysGreaterThanCardHeight() {
        let bounds = CGRect(x: 0, y: 0, width: 390, height: 844)
        let offset = CardLayout.bottomYOffset(viewBounds: bounds)
        let cardH = CardLayout.cardHeight(viewWidth: 390)
        XCTAssertGreaterThan(offset, cardH, "bottomYOffset 应大于卡片高度（包含间距）")
    }

    // MARK: - 计算一致性

    func testCardHeightConsistencyAcrossWidths() {
        for width in stride(from: CGFloat(320), through: 430, by: 10) {
            let h = CardLayout.cardHeight(viewWidth: width)
            XCTAssertGreaterThan(h, 0, "宽度 \(width) 时高度应大于 0")
            XCTAssertLessThan(h, width * 2, "高度不应超过宽度的 2 倍")
        }
    }
}
