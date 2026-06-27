//
//  TriangleViewTests.swift
//  conanTests
//

import XCTest
import UIKit
@testable import conan

final class TriangleViewTests: XCTestCase {

    // MARK: - 初始化

    func testInitWithCaseBook() {
        let caseBook = CaseBook.create(index: 0) // year=1997
        let view = TriangleView(caseBook: caseBook)
        XCTAssertEqual(view.frame, CGRect(x: 0, y: 0, width: 56, height: 56))
    }

    func testBackgroundColorIsClear() {
        let caseBook = CaseBook.create(index: 0)
        let view = TriangleView(caseBook: caseBook)
        XCTAssertEqual(view.backgroundColor, .clear)
    }

    func testHasYearLabel() {
        let caseBook = CaseBook.create(index: 0) // year=1997
        let view = TriangleView(caseBook: caseBook)
        let labels = view.subviews.compactMap { $0 as? UILabel }
        XCTAssertFalse(labels.isEmpty, "应至少包含一个 UILabel")
    }

    func testYearLabelText() {
        let caseBook = CaseBook.create(index: 0) // year=1997
        let view = TriangleView(caseBook: caseBook)
        let labels = view.subviews.compactMap { $0 as? UILabel }
        let yearLabel = labels.first { $0.text == "1997" }
        XCTAssertNotNil(yearLabel, "应包含年份标签 1997")
    }

    func testYearLabelTextForDifferentYears() {
        for i in 0..<CaseBook.caseTitles.count {
            let caseBook = CaseBook.create(index: i)
            let view = TriangleView(caseBook: caseBook)
            let labels = view.subviews.compactMap { $0 as? UILabel }
            let yearLabel = labels.first { $0.text == String(caseBook.year) }
            XCTAssertNotNil(yearLabel, "应包含年份 \(caseBook.year)")
        }
    }

    func testYearLabelFont() {
        let caseBook = CaseBook.create(index: 0)
        let view = TriangleView(caseBook: caseBook)
        let labels = view.subviews.compactMap { $0 as? UILabel }
        if let label = labels.first {
            XCTAssertEqual(label.font.pointSize, 16, accuracy: 0.01)
        }
    }

    func testYearLabelAlignment() {
        let caseBook = CaseBook.create(index: 0)
        let view = TriangleView(caseBook: caseBook)
        let labels = view.subviews.compactMap { $0 as? UILabel }
        if let label = labels.first {
            XCTAssertEqual(label.textAlignment, .center)
        }
    }

    func testFrameIs56x56() {
        let caseBook = CaseBook.create(index: 5)
        let view = TriangleView(caseBook: caseBook)
        XCTAssertEqual(view.bounds.width, 56, accuracy: 0.01)
        XCTAssertEqual(view.bounds.height, 56, accuracy: 0.01)
    }
}
