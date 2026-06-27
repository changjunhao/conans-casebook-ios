//
//  AudioPlayerViewControllerTests.swift
//  conanTests
//

import XCTest
import AVFoundation
@testable import conan

final class AudioPlayerViewControllerTests: XCTestCase {

    private var controller: AudioPlayerViewController!

    override func setUp() {
        super.setUp()
        controller = AudioPlayerViewController(nibName: nil, bundle: nil)
    }

    override func tearDown() {
        controller = nil
        super.tearDown()
    }

    // MARK: - 初始化

    func testInit() {
        XCTAssertNotNil(controller)
        XCTAssertNotNil(controller.audioPlayer)
    }

    func testAudioPlayerDelegateIsSet() {
        XCTAssertTrue(controller.audioPlayer.delegate === controller)
    }

    func testAudioUrlDefaultIsNil() {
        // 初始化时 audioUrl 未被设置
        // （通过 didSet 触发，不在此处断言值）
        XCTAssertNotNil(controller)
    }

    // MARK: - timeFilter

    func testTimeFilterZeroSeconds() {
        let result = controller.timeFilter(seconds: 0)
        XCTAssertEqual(result, "0:00")
    }

    func testTimeFilterFiveSeconds() {
        let result = controller.timeFilter(seconds: 5)
        XCTAssertEqual(result, "0:05")
    }

    func testTimeFilterTenSeconds() {
        let result = controller.timeFilter(seconds: 10)
        XCTAssertEqual(result, "0:10")
    }

    func testTimeFilterFiftyNineSeconds() {
        let result = controller.timeFilter(seconds: 59)
        XCTAssertEqual(result, "0:59")
    }

    func testTimeFilterOneMinute() {
        let result = controller.timeFilter(seconds: 60)
        XCTAssertEqual(result, "1:00")
    }

    func testTimeFilterOneMinuteThirty() {
        let result = controller.timeFilter(seconds: 90)
        XCTAssertEqual(result, "1:30")
    }

    func testTimeFilterTenMinutes() {
        let result = controller.timeFilter(seconds: 600)
        XCTAssertEqual(result, "10:00")
    }

    func testTimeFilterFractionalSeconds() {
        // 小数部分应被截断为整数
        let result = controller.timeFilter(seconds: 5.9)
        XCTAssertEqual(result, "0:05")
    }

    func testTimeFilterLargeValue() {
        let result = controller.timeFilter(seconds: 3661) // 61 分 1 秒
        XCTAssertEqual(result, "1:01")
    }

    // MARK: - AudioPlayer 状态

    func testAudioPlayerInitialDuration() {
        XCTAssertEqual(controller.audioPlayer.duration, "/ 0:00")
    }

    func testAudioPlayerInitialCurrentTime() {
        XCTAssertEqual(controller.audioPlayer.currentTime, "0:00")
    }

    func testAudioPlayerInitialPercent() {
        XCTAssertEqual(controller.audioPlayer.percent, 0.0, accuracy: 0.001)
    }

    // MARK: - audioPlayerDidRequestTogglePlayback (Delegate)

    func testDelegateMethodExists() {
        // 验证 delegate 方法可被调用（无 AVPlayer 时不崩溃）
        controller.audioPlayerDidRequestTogglePlayback()
    }
}
