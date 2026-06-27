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

    // MARK: - URLProtocol Mock

    private class MockURLProtocol: URLProtocol {
        static var handler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

        override class func canInit(with request: URLRequest) -> Bool { true }
        override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

        override func startLoading() {
            guard let handler = MockURLProtocol.handler else {
                client?.urlProtocolDidFinishLoading(self)
                return
            }
            do {
                let (response, data) = try handler(request)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }

        override func stopLoading() {}
    }

    private func makeSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
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

    // MARK: - IncidentService 端到端测试（URLProtocol Mock）

    func testServiceEndToEndSuccess() async throws {
        let incident = Incident(
            title: "端到端测试",
            section: [
                IncidentSectionItem(title: "第一节", desc: "描述", image: "img")
            ]
        )
        let data = try JSONEncoder().encode(incident)
        let response = HTTPURLResponse(
            url: URL(string: APIConfiguration.incidentAPI(id: 1))!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        MockURLProtocol.handler = { _ in (response, data) }

        let service = IncidentService(session: makeSession())
        let result = try await service.loadIncident(id: 1)
        XCTAssertEqual(result.title, "端到端测试")
        XCTAssertEqual(result.section.count, 1)
        XCTAssertEqual(result.section.first?.title, "第一节")
    }

    func testServiceEndToEndNetworkError() async {
        MockURLProtocol.handler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        let service = IncidentService(session: makeSession())
        do {
            _ = try await service.loadIncident(id: 1)
            XCTFail("应该抛出网络错误")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .notConnectedToInternet)
        } catch {
            XCTFail("错误类型不匹配：\(error)")
        }
    }

    func testServiceEndToEndDecodingError() async {
        let badData = "not json".data(using: .utf8)!
        let response = HTTPURLResponse(
            url: URL(string: APIConfiguration.incidentAPI(id: 1))!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        MockURLProtocol.handler = { _ in (response, badData) }

        let service = IncidentService(session: makeSession())
        do {
            _ = try await service.loadIncident(id: 1)
            XCTFail("应该抛出解码错误")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testServiceCustomSessionInit() {
        let session = makeSession()
        let service = IncidentService(session: session)
        XCTAssertNotNil(service)
    }
}
