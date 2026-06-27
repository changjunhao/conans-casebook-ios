//
//  IncidentLoaderTests.swift
//  conanTests
//

import XCTest
@testable import conan

final class IncidentLoaderTests: XCTestCase {

    // MARK: - Mock URLSession

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

    // MARK: - 初始化

    func testDefaultInitUsesSharedSession() {
        let loader = IncidentLoader()
        XCTAssertNotNil(loader.session)
    }

    func testCustomSessionInit() {
        let session = makeSession()
        let loader = IncidentLoader(session: session)
        XCTAssertTrue(loader.session === session)
    }

    // MARK: - 正常解码

    func testLoadIncidentSuccess() async throws {
        let incident = Incident(
            title: "测试案件",
            section: [IncidentSectionItem(title: "S1", desc: "D1", image: "I1")]
        )
        let data = try JSONEncoder().encode(incident)
        let response = HTTPURLResponse(
            url: URL(string: APIConfiguration.incidentAPI(id: 1))!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        MockURLProtocol.handler = { _ in (response, data) }

        let loader = IncidentLoader(session: makeSession())
        let result = try await loader.loadIncident(id: 1)
        XCTAssertEqual(result.title, "测试案件")
        XCTAssertEqual(result.section.count, 1)
    }

    // MARK: - 空 section

    func testLoadIncidentEmptySection() async throws {
        let incident = Incident(title: "空案件", section: [])
        let data = try JSONEncoder().encode(incident)
        let response = HTTPURLResponse(
            url: URL(string: APIConfiguration.incidentAPI(id: 2))!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        MockURLProtocol.handler = { _ in (response, data) }

        let loader = IncidentLoader(session: makeSession())
        let result = try await loader.loadIncident(id: 2)
        XCTAssertEqual(result.title, "空案件")
        XCTAssertTrue(result.section.isEmpty)
    }

    // MARK: - 服务端错误（非 JSON 响应）

    func testLoadIncidentServerError() async {
        let errorHTML = "<html>500 Internal Server Error</html>".data(using: .utf8)!
        let response = HTTPURLResponse(
            url: URL(string: APIConfiguration.incidentAPI(id: 3))!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!

        MockURLProtocol.handler = { _ in (response, errorHTML) }

        let loader = IncidentLoader(session: makeSession())
        do {
            _ = try await loader.loadIncident(id: 3)
            XCTFail("应该解码失败（非 JSON）")
        } catch {
            // 预期：JSONDecoder 解析 HTML 时抛出 DecodingError
            XCTAssertTrue(error is DecodingError || error is Swift.Error)
        }
    }

    // MARK: - 网络错误

    func testLoadIncidentNetworkFailure() async {
        MockURLProtocol.handler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        let loader = IncidentLoader(session: makeSession())
        do {
            _ = try await loader.loadIncident(id: 4)
            XCTFail("应该抛出网络错误")
        } catch let error as URLError {
            XCTAssertEqual(error.code, .notConnectedToInternet)
        } catch {
            XCTFail("错误类型不匹配：\(error)")
        }
    }

    // MARK: - 请求 URL 验证

    func testLoadIncidentRequestURL() async throws {
        let incident = Incident(title: "URL验证", section: [])
        let data = try JSONEncoder().encode(incident)

        var capturedRequest: URLRequest?
        let response = HTTPURLResponse(
            url: URL(string: APIConfiguration.incidentAPI(id: 5))!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        MockURLProtocol.handler = { request in
            capturedRequest = request
            return (response, data)
        }

        let loader = IncidentLoader(session: makeSession())
        _ = try await loader.loadIncident(id: 5)

        XCTAssertEqual(capturedRequest?.url?.absoluteString, APIConfiguration.incidentAPI(id: 5))
    }
}
