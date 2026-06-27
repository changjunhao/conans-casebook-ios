//
//  IncidentTests.swift
//  conanTests
//

import XCTest
@testable import conan

final class IncidentTests: XCTestCase {

    // MARK: - IncidentSectionItem Codable

    func testIncidentSectionItemDecoding() throws {
        let json = """
        {
            "title": "事件标题",
            "desc": "事件描述",
            "image": "https://example.com/image.jpg"
        }
        """.data(using: .utf8)!

        let item = try JSONDecoder().decode(IncidentSectionItem.self, from: json)
        XCTAssertEqual(item.title, "事件标题")
        XCTAssertEqual(item.desc, "事件描述")
        XCTAssertEqual(item.image, "https://example.com/image.jpg")
    }

    func testIncidentSectionItemEncoding() throws {
        let item = IncidentSectionItem(title: "Test", desc: "Description", image: "img.png")
        let data = try JSONEncoder().encode(item)
        let decoded = try JSONDecoder().decode(IncidentSectionItem.self, from: data)
        XCTAssertEqual(decoded.title, item.title)
        XCTAssertEqual(decoded.desc, item.desc)
        XCTAssertEqual(decoded.image, item.image)
    }

    func testIncidentSectionItemRoundTrip() throws {
        let original = IncidentSectionItem(
            title: "密室杀人事件",
            desc: "柯南发现了一个密室杀人案",
            image: "https://example.com/case1.jpg"
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(IncidentSectionItem.self, from: data)
        XCTAssertEqual(original.title, decoded.title)
        XCTAssertEqual(original.desc, decoded.desc)
        XCTAssertEqual(original.image, decoded.image)
    }

    // MARK: - Incident Codable

    func testIncidentDecoding() throws {
        let json = """
        {
            "title": "案件标题",
            "section": [
                {
                    "title": "第一节",
                    "desc": "第一节描述",
                    "image": "https://example.com/1.jpg"
                },
                {
                    "title": "第二节",
                    "desc": "第二节描述",
                    "image": "https://example.com/2.jpg"
                }
            ]
        }
        """.data(using: .utf8)!

        let incident = try JSONDecoder().decode(Incident.self, from: json)
        XCTAssertEqual(incident.title, "案件标题")
        XCTAssertEqual(incident.section.count, 2)
        XCTAssertEqual(incident.section[0].title, "第一节")
        XCTAssertEqual(incident.section[1].title, "第二节")
    }

    func testIncidentEmptySection() throws {
        let json = """
        {
            "title": "空案件",
            "section": []
        }
        """.data(using: .utf8)!

        let incident = try JSONDecoder().decode(Incident.self, from: json)
        XCTAssertEqual(incident.title, "空案件")
        XCTAssertTrue(incident.section.isEmpty)
    }

    func testIncidentRoundTrip() throws {
        let original = Incident(
            title: "完整的案件",
            section: [
                IncidentSectionItem(title: "S1", desc: "D1", image: "I1"),
                IncidentSectionItem(title: "S2", desc: "D2", image: "I2"),
            ]
        )
        let data = try JSONEncoder().encode(original)
        let decoded = try JSONDecoder().decode(Incident.self, from: data)
        XCTAssertEqual(decoded.title, original.title)
        XCTAssertEqual(decoded.section.count, original.section.count)
    }

    // MARK: - 解码失败

    func testIncidentDecodingMissingTitle() {
        let json = """
        {
            "section": []
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Incident.self, from: json))
    }

    func testIncidentDecodingMissingSection() {
        let json = """
        {
            "title": "无 section 字段"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(Incident.self, from: json))
    }

    func testIncidentSectionItemDecodingMissingField() {
        let json = """
        {
            "title": "缺少 desc 和 image"
        }
        """.data(using: .utf8)!

        XCTAssertThrowsError(try JSONDecoder().decode(IncidentSectionItem.self, from: json))
    }
}
