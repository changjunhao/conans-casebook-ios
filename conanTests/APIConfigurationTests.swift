//
//  APIConfigurationTests.swift
//  conanTests
//

import XCTest
@testable import conan

final class APIConfigurationTests: XCTestCase {

    // MARK: - Base URLs

    func testBaseURL() {
        XCTAssertEqual(APIConfiguration.baseURL, "https://oss-materials.ifable.cn/conan")
    }

    func testAPIBaseURL() {
        XCTAssertEqual(APIConfiguration.apiBaseURL, "https://conan.ifable.cn/api")
    }

    // MARK: - movieImage

    func testMovieImage() {
        let url = APIConfiguration.movieImage(index: 1)
        XCTAssertEqual(url, "https://oss-materials.ifable.cn/conan/m1.jpg?imageView2/0/interlace/1")
    }

    func testMovieImageIndex10() {
        let url = APIConfiguration.movieImage(index: 10)
        XCTAssertTrue(url.contains("m10.jpg"))
    }

    // MARK: - movieImageHorizontal

    func testMovieImageHorizontalNormal() {
        let url = APIConfiguration.movieImageHorizontal(index: 5)
        XCTAssertEqual(url, "https://oss-materials.ifable.cn/conan/m5h.jpg?imageView2/0/interlace/1")
    }

    func testMovieImageHorizontalIndex20() {
        // index 20 不是最后一部（共21部），应返回 m20h
        let url = APIConfiguration.movieImageHorizontal(index: 20)
        XCTAssertEqual(url, "https://oss-materials.ifable.cn/conan/m20h.jpg?imageView2/0/interlace/1")
    }

    func testMovieImageHorizontalLastMovieFallsBack() {
        // 最后一部电影（index == caseTitles.count）回退到 m1h
        let lastIndex = CaseBook.caseTitles.count
        let url = APIConfiguration.movieImageHorizontal(index: lastIndex)
        XCTAssertEqual(url, "https://oss-materials.ifable.cn/conan/m1h.jpg?imageView2/0/interlace/1")
    }

    func testMovieImageHorizontalNon20() {
        let url = APIConfiguration.movieImageHorizontal(index: 19)
        XCTAssertTrue(url.contains("m19h.jpg"))
    }

    // MARK: - movieLogo

    func testMovieLogo() {
        let url = APIConfiguration.movieLogo(index: 3)
        XCTAssertEqual(url, "https://oss-materials.ifable.cn/conan/m3logo.png")
    }

    // MARK: - movieBackground

    func testMovieBackground() {
        let url = APIConfiguration.movieBackground(id: 7)
        XCTAssertEqual(url, "https://oss-materials.ifable.cn/conan/m7-bg.jpg")
    }

    // MARK: - movieAudio

    func testMovieAudio() {
        let url = APIConfiguration.movieAudio(id: 12)
        XCTAssertEqual(url, "https://oss-materials.ifable.cn/conan/m12.mp3")
    }

    // MARK: - moviePicture

    func testMoviePicture() {
        let url = APIConfiguration.moviePicture(id: 4)
        XCTAssertEqual(url, "https://oss-materials.ifable.cn/conan/m4-pic-2.png")
    }

    // MARK: - incidentAPI

    func testIncidentAPI() {
        let url = APIConfiguration.incidentAPI(id: 8)
        XCTAssertEqual(url, "https://conan.ifable.cn/api/getIncident?id=8")
    }

    func testIncidentAPIContainsID() {
        for id in [1, 10, 21] {
            let url = APIConfiguration.incidentAPI(id: id)
            XCTAssertTrue(url.contains("id=\(id)"))
        }
    }

    // MARK: - Static Properties

    func testWaitingLogo() {
        XCTAssertEqual(APIConfiguration.waitingLogo, "https://oss-materials.ifable.cn/conan/mov-e.png")
    }

    func testAvailableLogo() {
        XCTAssertEqual(APIConfiguration.availableLogo, "https://oss-materials.ifable.cn/conan/mov-d.png")
    }
}
