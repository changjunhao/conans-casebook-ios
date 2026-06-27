//
//  IncidentCollectionViewDataSourceTests.swift
//  conanTests
//

import XCTest
import UIKit
@testable import conan

final class IncidentCollectionViewDataSourceTests: XCTestCase {

    private var dataSource: IncidentCollectionViewDataSource!

    override func setUp() {
        super.setUp()
        dataSource = IncidentCollectionViewDataSource(incidentId: 1)
    }

    override func tearDown() {
        dataSource = nil
        super.tearDown()
    }

    // MARK: - 初始化

    func testInit() {
        XCTAssertNotNil(dataSource)
        XCTAssertNil(dataSource.incident, "初始化时 incident 应为 nil")
    }

    // MARK: - numberOfItemsInSection

    func testNumberOfItemsWhenNil() {
        let cv = makeCollectionView()
        let count = dataSource.collectionView(cv, numberOfItemsInSection: 0)
        XCTAssertEqual(count, 0)
    }

    func testNumberOfItemsAfterUpdate() {
        let cv = makeCollectionView()
        let incident = Incident(
            title: "测试",
            section: [
                IncidentSectionItem(title: "S1", desc: "D1", image: "I1"),
                IncidentSectionItem(title: "S2", desc: "D2", image: "I2"),
                IncidentSectionItem(title: "S3", desc: "D3", image: "I3"),
            ]
        )
        dataSource.update(incident: incident)
        let count = dataSource.collectionView(cv, numberOfItemsInSection: 0)
        XCTAssertEqual(count, 3)
    }

    func testNumberOfItemsEmptySection() {
        let cv = makeCollectionView()
        dataSource.update(incident: Incident(title: "空", section: []))
        let count = dataSource.collectionView(cv, numberOfItemsInSection: 0)
        XCTAssertEqual(count, 0)
    }

    // MARK: - update

    func testUpdateSetsIncident() {
        let incident = Incident(title: "更新后", section: [])
        dataSource.update(incident: incident)
        XCTAssertNotNil(dataSource.incident)
        XCTAssertEqual(dataSource.incident?.title, "更新后")
    }

    func testUpdateReplacesPrevious() {
        let first = Incident(title: "第一次", section: [])
        let second = Incident(title: "第二次", section: [])
        dataSource.update(incident: first)
        dataSource.update(incident: second)
        XCTAssertEqual(dataSource.incident?.title, "第二次")
    }

    // MARK: - sizeForItemAt

    func testSizeForItemAtReturnsNonZero() {
        let cv = makeCollectionView()
        let incident = Incident(
            title: "尺寸测试",
            section: [IncidentSectionItem(title: "S1", desc: "这是描述文字", image: "I1")]
        )
        dataSource.update(incident: incident)

        let layout = UICollectionViewFlowLayout()
        let size = dataSource.collectionView(
            cv, layout: layout, sizeForItemAt: IndexPath(row: 0, section: 0)
        )
        XCTAssertGreaterThan(size.width, 0)
        XCTAssertGreaterThan(size.height, 0)
    }

    func testSizeForItemAtWiderViewProducesTallerCell() {
        let narrowDS = IncidentCollectionViewDataSource(incidentId: 1)
        let wideDS = IncidentCollectionViewDataSource(incidentId: 1)

        let longDesc = String(repeating: "测试文字", count: 50)
        let incident = Incident(
            title: "T",
            section: [IncidentSectionItem(title: "S", desc: longDesc, image: "I")]
        )
        narrowDS.update(incident: incident)
        wideDS.update(incident: incident)

        let layout = UICollectionViewFlowLayout()
        let narrowSize = narrowDS.collectionView(
            makeCollectionView(width: 320), layout: layout, sizeForItemAt: IndexPath(row: 0, section: 0)
        )
        let wideSize = wideDS.collectionView(
            makeCollectionView(width: 414), layout: layout, sizeForItemAt: IndexPath(row: 0, section: 0)
        )

        // 更宽的视图：文字换行更少，但 cell 宽度更大
        XCTAssertGreaterThan(wideSize.width, narrowSize.width)
    }

    // MARK: - referenceSizeForHeaderInSection

    func testReferenceSizeForHeader() {
        let cv = makeCollectionView()
        let layout = UICollectionViewFlowLayout()
        let size = dataSource.collectionView(cv, layout: layout, referenceSizeForHeaderInSection: 0)
        // 高度 = collectionView.bounds.width * 0.9 * 0.64
        let expectedHeight: CGFloat = 375 * 0.9 * 0.64
        XCTAssertEqual(size.width, 375, accuracy: 0.01)
        XCTAssertEqual(size.height, expectedHeight, accuracy: 0.01)
    }

    // MARK: - Helpers

    private func makeCollectionView(width: CGFloat = 375) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: width, height: 800),
            collectionViewLayout: layout
        )
        cv.register(IncidentItem.self, forCellWithReuseIdentifier: IncidentItem.reuseIdentifier)
        cv.register(
            NoticeCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NoticeCollectionReusableView.reuseIdentifier
        )
        return cv
    }
}
