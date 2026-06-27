//
//  CaseBookListViewControllerTests.swift
//  conanTests
//

import XCTest
import UIKit
@testable import conan

final class CaseBookListViewControllerTests: XCTestCase {

    // MARK: - Mock

    struct MockCaseBookProvider: CaseBookProviding {
        let books: [CaseBook]
        func fetchCaseBooks() -> [CaseBook] { books }
    }

    private func makeVC(bookCount: Int = 21) -> CaseBookListViewController {
        let books = (0..<min(bookCount, CaseBook.caseTitles.count)).map { CaseBook.create(index: $0) }
        let provider = MockCaseBookProvider(books: books)
        let coordinator = AppCoordinator()
        return CaseBookListViewController(caseBookService: provider, coordinator: coordinator)
    }

    // MARK: - 初始化

    func testInit() {
        let vc = makeVC()
        XCTAssertNotNil(vc)
    }

    func testInitialCurrentIndex() {
        let vc = makeVC()
        XCTAssertEqual(vc.currentIndex, 0)
    }

    // MARK: - currentIndex

    func testCurrentIndexCanBeSet() {
        let vc = makeVC()
        // 需要先触发 viewDidLoad 以加载数据
        _ = vc.view
        vc.currentIndex = 5
        XCTAssertEqual(vc.currentIndex, 5)
    }

    func testCurrentIndexLastItem() {
        let vc = makeVC()
        _ = vc.view
        let lastIndex = CaseBook.caseTitles.count - 1
        vc.currentIndex = lastIndex
        XCTAssertEqual(vc.currentIndex, lastIndex)
    }

    // MARK: - initWithEmptyProvider

    func testInitWithEmptyProvider() {
        let provider = MockCaseBookProvider(books: [])
        let coordinator = AppCoordinator()
        let vc = CaseBookListViewController(caseBookService: provider, coordinator: coordinator)
        XCTAssertNotNil(vc)
    }

    // MARK: - initWithSingleBook

    func testInitWithSingleBook() {
        let provider = MockCaseBookProvider(books: [CaseBook.create(index: 0)])
        let coordinator = AppCoordinator()
        let vc = CaseBookListViewController(caseBookService: provider, coordinator: coordinator)
        XCTAssertNotNil(vc)
        _ = vc.view // trigger viewDidLoad
    }
}
