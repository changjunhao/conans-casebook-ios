//
//  AppCoordinatorTests.swift
//  conanTests
//

import XCTest
@testable import conan

final class AppCoordinatorTests: XCTestCase {

    // MARK: - 初始化

    func testCoordinatorInit() {
        let coordinator = AppCoordinator()
        XCTAssertNotNil(coordinator)
    }

    // MARK: - navigate 逻辑

    func testNavigateWithWaitingCaseBook() {
        // waiting=true 应弹出"静候上线"提示（UIAlertController）
        let coordinator = AppCoordinator()
        let presenter = UIViewController()

        // 在测试环境无法完整展示 UIAlertController，但调用不应崩溃
        let waitingBook = CaseBook(
            id: 99, title: "未上线电影", url: "", urlh: "", logo: "", year: 2099, waiting: true
        )

        // 由于 present 需要完整的 window 层级，此处验证调用不会崩溃
        // 在 headless 测试环境中 present 可能静默失败，这是预期的
        coordinator.navigate(from: presenter, caseBook: waitingBook)
    }

    func testNavigateWithAvailableCaseBook() {
        // waiting=false 应弹出详情页
        let coordinator = AppCoordinator()
        let presenter = UIViewController()

        let availableBook = CaseBook(
            id: 1, title: "计时引爆摩天楼", url: "", urlh: "", logo: "", year: 1997, waiting: false
        )

        // 验证调用不会崩溃
        coordinator.navigate(from: presenter, caseBook: availableBook)
    }

    // MARK: - CaseBook waiting 状态与导航对应关系

    func testAllNonWaitingBooksAreBefore2010() {
        let service = CaseBookService()
        let books = service.fetchCaseBooks()
        let nonWaiting = books.filter { !$0.waiting }
        for book in nonWaiting {
            XCTAssertLessThanOrEqual(book.year, 2009, "\(book.title)(\(book.year)) 不应等待")
        }
    }

    func testAllWaitingBooksAre2010OrLater() {
        let service = CaseBookService()
        let books = service.fetchCaseBooks()
        let waiting = books.filter { $0.waiting }
        for book in waiting {
            XCTAssertGreaterThan(book.year, 2009, "\(book.title)(\(book.year)) 应该等待")
        }
    }
}
