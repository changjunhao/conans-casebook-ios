//
//  IncidentServiceTests.swift
//  conanTests
//

import XCTest
@testable import conan

final class IncidentServiceTests: XCTestCase {

    // MARK: - Mock

    struct MockIncidentProvider: IncidentProviding {
        let result: Result<Incident, Error>

        func loadIncident(id: Int) async throws -> Incident {
            switch result {
            case .success(let incident): return incident
            case .failure(let error): throw error
            }
        }
    }

    class CountingMockProvider: IncidentProviding {
        var callCount: Int = 0
        let incident: Incident

        init(incident: Incident) { self.incident = incident }

        func loadIncident(id: Int) async throws -> Incident {
            callCount += 1
            return incident
        }
    }

    // MARK: - Protocol Conformance

    func testMockProviderSuccess() async throws {
        let expected = Incident(title: "测试案件", section: [])
        let mock = MockIncidentProvider(result: .success(expected))
        let incident = try await mock.loadIncident(id: 1)
        XCTAssertEqual(incident.title, "测试案件")
    }

    func testMockProviderFailure() async {
        let mock = MockIncidentProvider(result: .failure(URLError(.notConnectedToInternet)))
        do {
            _ = try await mock.loadIncident(id: 1)
            XCTFail("应该抛出错误")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }

    // MARK: - IncidentService Initialization

    func testIncidentServiceInit() {
        // 验证默认初始化不崩溃
        let service = IncidentService()
        XCTAssertNotNil(service)
    }

    func testIncidentServiceConformsToProvider() {
        let provider: IncidentProviding = IncidentService()
        XCTAssertNotNil(provider)
    }

    // MARK: - 错误类型

    func testProviderThrowsBadURL() async {
        let mock = MockIncidentProvider(result: .failure(URLError(.badURL)))
        do {
            _ = try await mock.loadIncident(id: -1)
            XCTFail("应该抛出 badURL 错误")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .badURL)
        } catch {
            XCTFail("错误类型不匹配：\(error)")
        }
    }

    func testProviderThrowsTimeout() async {
        let mock = MockIncidentProvider(result: .failure(URLError(.timedOut)))
        do {
            _ = try await mock.loadIncident(id: 1)
            XCTFail("应该抛出超时错误")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .timedOut)
        } catch {
            XCTFail("错误类型不匹配：\(error)")
        }
    }
}
