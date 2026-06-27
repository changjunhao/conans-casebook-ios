//
//  ReuseIdentifierTests.swift
//  conanTests
//

import XCTest
@testable import conan

final class ReuseIdentifierTests: XCTestCase {

    func testIncidentItemReuseIdentifier() {
        XCTAssertEqual(IncidentItem.reuseIdentifier, "IncidentItemCell")
    }

    func testNoticeHeaderReuseIdentifier() {
        XCTAssertEqual(NoticeCollectionReusableView.reuseIdentifier, "NoticeHeaderView")
    }

    func testReuseIdentifiersAreNotEmpty() {
        XCTAssertFalse(IncidentItem.reuseIdentifier.isEmpty)
        XCTAssertFalse(NoticeCollectionReusableView.reuseIdentifier.isEmpty)
    }

    func testReuseIdentifiersAreUnique() {
        XCTAssertNotEqual(IncidentItem.reuseIdentifier, NoticeCollectionReusableView.reuseIdentifier)
    }
}
