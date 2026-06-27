//
//  CaseBookServiceTests.swift
//  conanTests
//

import XCTest
@testable import conan

final class CaseBookServiceTests: XCTestCase {

    // MARK: - Mock

    struct MockCaseBookProvider: CaseBookProviding {
        let books: [CaseBook]
        func fetchCaseBooks() -> [CaseBook] { books }
    }

    // MARK: - CaseBookService

    func testFetchCaseBooksCount() {
        let service = CaseBookService()
        let books = service.fetchCaseBooks()
        XCTAssertEqual(books.count, CaseBook.caseTitles.count)
    }

    func testFetchCaseBooksFirstItem() {
        let service = CaseBookService()
        let books = service.fetchCaseBooks()
        guard let first = books.first else {
            XCTFail("books 不应为空")
            return
        }
        XCTAssertEqual(first.id, 1)
        XCTAssertEqual(first.title, "计时引爆摩天楼")
        XCTAssertEqual(first.year, 1997)
    }

    func testFetchCaseBooksIDsAreSequential() {
        let service = CaseBookService()
        let books = service.fetchCaseBooks()
        for (index, book) in books.enumerated() {
            XCTAssertEqual(book.id, index + 1)
        }
    }

    func testFetchCaseBooksTitlesMatch() {
        let service = CaseBookService()
        let books = service.fetchCaseBooks()
        for (index, book) in books.enumerated() {
            XCTAssertEqual(book.title, CaseBook.caseTitles[index])
        }
    }

    // MARK: - Protocol Conformance (Mock)

    func testMockProviderReturnsEmptyList() {
        let provider = MockCaseBookProvider(books: [])
        XCTAssertTrue(provider.fetchCaseBooks().isEmpty)
    }

    func testMockProviderReturnsCustomList() {
        let customBooks = [
            CaseBook(id: 99, title: "自定义", url: "", urlh: "", logo: "", year: 2025, waiting: true)
        ]
        let provider = MockCaseBookProvider(books: customBooks)
        let result = provider.fetchCaseBooks()
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0].title, "自定义")
    }

    // MARK: - Protocol Type Erasure

    func testServiceConformsToProvider() {
        let provider: CaseBookProviding = CaseBookService()
        let books = provider.fetchCaseBooks()
        XCTAssertFalse(books.isEmpty)
    }
}
