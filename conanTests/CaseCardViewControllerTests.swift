//
//  CaseCardViewControllerTests.swift
//  conanTests
//

import XCTest
import UIKit
@testable import conan

final class CaseCardViewControllerTests: XCTestCase {

    // MARK: - 初始化

    func testInitWithCaseBook() {
        let caseBook = CaseBook.create(index: 0)
        let vc = CaseCardViewController(caseBook: caseBook)
        XCTAssertNotNil(vc)
    }

    func testOnNavigateInitiallyNil() {
        let caseBook = CaseBook.create(index: 0)
        let vc = CaseCardViewController(caseBook: caseBook)
        XCTAssertNil(vc.onNavigate, "初始化时 onNavigate 应为 nil")
    }

    // MARK: - onNavigate 回调

    func testOnNavigateCallback() {
        let caseBook = CaseBook.create(index: 0)
        let vc = CaseCardViewController(caseBook: caseBook)

        var navigated = false
        vc.onNavigate = { navigated = true }
        vc.onNavigate?()
        XCTAssertTrue(navigated)
    }

    func testOnNavigateCanBeReplaced() {
        let caseBook = CaseBook.create(index: 0)
        let vc = CaseCardViewController(caseBook: caseBook)

        var firstCalled = false
        var secondCalled = false

        vc.onNavigate = { firstCalled = true }
        vc.onNavigate = { secondCalled = true }

        vc.onNavigate?()
        XCTAssertFalse(firstCalled, "第一个回调不应被调用")
        XCTAssertTrue(secondCalled, "第二个回调应被调用")
    }

    func testOnNavigateCanBeCleared() {
        let caseBook = CaseBook.create(index: 0)
        let vc = CaseCardViewController(caseBook: caseBook)

        vc.onNavigate = { }
        vc.onNavigate = nil
        XCTAssertNil(vc.onNavigate)
    }

    // MARK: - 多个 CaseBook

    func testInitWithDifferentCaseBooks() {
        for i in 0..<CaseBook.caseTitles.count {
            let caseBook = CaseBook.create(index: i)
            let vc = CaseCardViewController(caseBook: caseBook)
            XCTAssertNotNil(vc)
        }
    }

    func testInitWithWaitingCaseBook() {
        let caseBook = CaseBook(
            id: 99, title: "未来电影", url: "", urlh: "", logo: "", year: 2099, waiting: true
        )
        let vc = CaseCardViewController(caseBook: caseBook)
        XCTAssertNotNil(vc)
    }

    // MARK: - viewDidLayoutSubviews

    func testViewDidLoadDoesNotCrash() {
        let caseBook = CaseBook.create(index: 0)
        let vc = CaseCardViewController(caseBook: caseBook)
        vc.loadViewIfNeeded() // 触发 viewDidLoad + viewDidLayoutSubviews
        XCTAssertNotNil(vc.view)
    }
}
