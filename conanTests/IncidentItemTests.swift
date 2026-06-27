//
//  IncidentItemTests.swift
//  conanTests
//

import XCTest
import UIKit
@testable import conan

final class IncidentItemTests: XCTestCase {

    private var item: IncidentItem!

    override func setUp() {
        super.setUp()
        item = IncidentItem(frame: CGRect(x: 0, y: 0, width: 375, height: 400))
    }

    override func tearDown() {
        item = nil
        super.tearDown()
    }

    // MARK: - 初始化

    func testInit() {
        XCTAssertNotNil(item)
    }

    func testSubviewsExist() {
        XCTAssertNotNil(item.titleLabel)
        XCTAssertNotNil(item.imageView)
        XCTAssertNotNil(item.descLabel)
        XCTAssertNotNil(item.descView)
    }

    func testTitleLabelInitiallyEmpty() {
        XCTAssertNil(item.titleLabel.text)
    }

    func testDescLabelInitiallyEmpty() {
        XCTAssertNil(item.descLabel.text)
    }

    func testItemInitiallyNil() {
        XCTAssertNil(item.item)
    }

    // MARK: - setData

    func testSetDataPopulatesTitle() {
        let sectionItem = IncidentSectionItem(title: "案件标题", desc: "描述", image: "https://example.com/img.jpg")
        item.item = sectionItem
        XCTAssertEqual(item.titleLabel.text, "案件标题")
    }

    func testSetDataPopulatesDescLabel() {
        let sectionItem = IncidentSectionItem(title: "T", desc: "详细描述文字", image: "https://example.com/img.jpg")
        item.item = sectionItem
        // descLabel.attributedText is set, text might be the same
        XCTAssertNotNil(item.descLabel.attributedText)
        XCTAssertTrue(item.descLabel.attributedText!.string.contains("详细描述文字"))
    }

    func testSetDataWithNilItemDoesNotCrash() {
        item.item = nil // guard should return early
        XCTAssertNil(item.titleLabel.text)
    }

    func testSetDataAppliesLineSpacing() {
        let sectionItem = IncidentSectionItem(title: "T", desc: "多行文字\n第二行", image: "https://example.com/img.jpg")
        item.item = sectionItem
        guard let attributedText = item.descLabel.attributedText else {
            XCTFail("attributedText 不应为 nil")
            return
        }
        // 验证有 paragraphStyle 属性
        var effectiveRange = NSRange()
        let attrs = attributedText.attributes(at: 0, effectiveRange: &effectiveRange)
        XCTAssertNotNil(attrs[.paragraphStyle], "应包含 paragraphStyle 属性")
    }

    // MARK: - prepareForReuse

    func testPrepareForReuseClearsLabels() {
        let sectionItem = IncidentSectionItem(title: "标题", desc: "描述", image: "https://example.com/img.jpg")
        item.item = sectionItem
        XCTAssertEqual(item.titleLabel.text, "标题")

        item.prepareForReuse()
        XCTAssertNil(item.titleLabel.text)
        XCTAssertNil(item.descLabel.text)
        XCTAssertNil(item.descLabel.attributedText)
    }

    // MARK: - item 属性观察器

    func testItemPropertyObserverTriggersSetData() {
        let sectionItem = IncidentSectionItem(title: "自动触发", desc: "D", image: "I")
        item.item = sectionItem
        // didSet 应自动调用 setData()
        XCTAssertEqual(item.titleLabel.text, "自动触发")
    }

    func testReplacingItemUpdatesLabels() {
        item.item = IncidentSectionItem(title: "第一个", desc: "D1", image: "I1")
        XCTAssertEqual(item.titleLabel.text, "第一个")

        item.item = IncidentSectionItem(title: "第二个", desc: "D2", image: "I2")
        XCTAssertEqual(item.titleLabel.text, "第二个")
    }
}
