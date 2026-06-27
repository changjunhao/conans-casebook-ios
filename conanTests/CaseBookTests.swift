//
//  CaseBookTests.swift
//  conanTests
//

import XCTest
@testable import conan

final class CaseBookTests: XCTestCase {

    // MARK: - caseTitles

    func testCaseTitlesCount() {
        XCTAssertEqual(CaseBook.caseTitles.count, 21, "应包含 21 部电影标题")
    }

    func testCaseTitlesFirstAndLast() {
        XCTAssertEqual(CaseBook.caseTitles.first, "计时引爆摩天楼")
        XCTAssertEqual(CaseBook.caseTitles.last, "枫红的恋歌")
    }

    func testCaseTitlesNotEmpty() {
        for title in CaseBook.caseTitles {
            XCTAssertFalse(title.isEmpty, "标题不应为空")
        }
    }

    // MARK: - create(index:)

    func testCreateIndexZero() {
        let caseBook = CaseBook.create(index: 0)
        XCTAssertEqual(caseBook.id, 1)
        XCTAssertEqual(caseBook.title, "计时引爆摩天楼")
        XCTAssertEqual(caseBook.year, 1997)
        XCTAssertFalse(caseBook.waiting, "1997 年不应为 waiting")
    }

    func testCreateIndexLast() {
        let lastIndex = CaseBook.caseTitles.count - 1
        let caseBook = CaseBook.create(index: lastIndex)
        XCTAssertEqual(caseBook.id, lastIndex + 1)
        XCTAssertEqual(caseBook.title, CaseBook.caseTitles.last)
        XCTAssertEqual(caseBook.year, 1997 + lastIndex)
    }

    func testCreateWaitingFlag() {
        // year > 2009 时 waiting 为 true
        // 2009 - 1997 = 12，index 12 对应 year=2009，waiting=false
        let caseBook2009 = CaseBook.create(index: 12)
        XCTAssertEqual(caseBook2009.year, 2009)
        XCTAssertFalse(caseBook2009.waiting)

        // index 13 对应 year=2010，waiting=true
        let caseBook2010 = CaseBook.create(index: 13)
        XCTAssertEqual(caseBook2010.year, 2010)
        XCTAssertTrue(caseBook2010.waiting)
    }

    func testCreateURLsContainIndex() {
        let caseBook = CaseBook.create(index: 4)
        XCTAssertTrue(caseBook.url.contains("m5"), "url 应包含 m5（index+1）")
        XCTAssertTrue(caseBook.urlh.contains("5"), "urlh 应包含 5")
        XCTAssertTrue(caseBook.logo.contains("m5"), "logo 应包含 m5")
    }

    // MARK: - Equatable / Hashable (Struct 默认)

    func testCaseBookEquality() {
        let a = CaseBook.create(index: 0)
        let b = CaseBook.create(index: 0)
        XCTAssertEqual(a.id, b.id)
        XCTAssertEqual(a.title, b.title)
        XCTAssertEqual(a.year, b.year)
    }

    func testCaseBookDifference() {
        let a = CaseBook.create(index: 0)
        let b = CaseBook.create(index: 1)
        XCTAssertNotEqual(a.id, b.id)
        XCTAssertNotEqual(a.title, b.title)
    }

    // MARK: - 边界测试

    func testCreateAllIndices() {
        for i in 0..<CaseBook.caseTitles.count {
            let caseBook = CaseBook.create(index: i)
            XCTAssertEqual(caseBook.id, i + 1)
            XCTAssertEqual(caseBook.title, CaseBook.caseTitles[i])
            XCTAssertEqual(caseBook.year, 1997 + i)
        }
    }
}
