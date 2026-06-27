//
//  AudioPlayerTests.swift
//  conanTests
//

import XCTest
import UIKit
@testable import conan

final class AudioPlayerTests: XCTestCase {

    private var player: AudioPlayer!

    override func setUp() {
        super.setUp()
        player = AudioPlayer(frame: CGRect(x: 0, y: 0, width: 300, height: 56))
    }

    override func tearDown() {
        player = nil
        super.tearDown()
    }

    // MARK: - 初始化

    func testInit() {
        XCTAssertNotNil(player)
    }

    func testInitialDuration() {
        XCTAssertEqual(player.duration, "/ 0:00")
        XCTAssertEqual(player.durationLabel.text, "/ 0:00")
    }

    func testInitialCurrentTime() {
        XCTAssertEqual(player.currentTime, "0:00")
        XCTAssertEqual(player.currentTimeLabel.text, "0:00")
    }

    func testInitialPercent() {
        XCTAssertEqual(player.percent, 0.0, accuracy: 0.001)
        XCTAssertEqual(player.progressView.progress, 0.0, accuracy: 0.001)
    }

    func testBackgroundColor() {
        XCTAssertEqual(player.backgroundColor, .systemBackground)
    }

    func testCornerRadius() {
        XCTAssertEqual(player.layer.cornerRadius, 28, accuracy: 0.001)
    }

    // MARK: - 属性观察器

    func testDurationUpdatesLabel() {
        player.duration = "/ 3:45"
        XCTAssertEqual(player.durationLabel.text, "/ 3:45")
    }

    func testCurrentTimeUpdatesLabel() {
        player.currentTime = "1:23"
        XCTAssertEqual(player.currentTimeLabel.text, "1:23")
    }

    func testPercentUpdatesProgressView() {
        player.percent = 0.5
        XCTAssertEqual(player.progressView.progress, 0.5, accuracy: 0.001)
    }

    func testPercentFullProgress() {
        player.percent = 1.0
        XCTAssertEqual(player.progressView.progress, 1.0, accuracy: 0.001)
    }

    func testMultipleDurationUpdates() {
        player.duration = "/ 1:00"
        XCTAssertEqual(player.durationLabel.text, "/ 1:00")
        player.duration = "/ 5:30"
        XCTAssertEqual(player.durationLabel.text, "/ 5:30")
    }

    func testMultipleCurrentTimeUpdates() {
        for seconds in 0..<5 {
            let timeStr = "0:0\(seconds)"
            player.currentTime = timeStr
            XCTAssertEqual(player.currentTimeLabel.text, timeStr)
        }
    }

    // MARK: - Delegate

    func testDelegateInitiallyNil() {
        XCTAssertNil(player.delegate)
    }

    func testHandlePlayCallsDelegate() {
        class MockDelegate: AudioPlayerViewDelegate {
            var called = false
            func audioPlayerDidRequestTogglePlayback() { called = true }
        }

        let mock = MockDelegate()
        player.delegate = mock
        player.handlePlay()
        XCTAssertTrue(mock.called)
    }

    func testHandlePlayWithoutDelegateDoesNotCrash() {
        player.delegate = nil
        player.handlePlay() // 不应崩溃
    }

    // MARK: - 子视图

    func testSubviewsExist() {
        XCTAssertTrue(player.subviews.contains(player.playButton))
        XCTAssertTrue(player.subviews.contains(player.currentTimeLabel))
        XCTAssertTrue(player.subviews.contains(player.durationLabel))
        XCTAssertTrue(player.subviews.contains(player.progressView))
    }

    func testPlayButtonIsUserInteractionEnabled() {
        XCTAssertTrue(player.playButton.isUserInteractionEnabled)
    }

    func testPlayButtonHasGestureRecognizers() {
        XCTAssertNotNil(player.playButton.gestureRecognizers)
        XCTAssertFalse(player.playButton.gestureRecognizers!.isEmpty)
    }

    // MARK: - 视图层级

    func testMasksToBounds() {
        XCTAssertTrue(player.layer.masksToBounds, "AudioPlayer 应开启 masksToBounds")
    }

    func testPlayButtonInitialImage() {
        XCTAssertNotNil(player.playButton.image, "播放按钮应有初始图标")
    }

    func testProgressViewInitialValue() {
        XCTAssertEqual(player.progressView.progress, 0.0, accuracy: 0.001)
    }

    // MARK: - 边界值

    func testPercentZero() {
        player.percent = 0.0
        XCTAssertEqual(player.progressView.progress, 0.0, accuracy: 0.001)
    }

    func testDurationEmptyString() {
        player.duration = ""
        XCTAssertEqual(player.durationLabel.text, "")
    }

    func testCurrentTimeEmptyString() {
        player.currentTime = ""
        XCTAssertEqual(player.currentTimeLabel.text, "")
    }

    // MARK: - 静态图标常量

    func testPlayIconIsAccessible() {
        let icon = AudioPlayer.playIcon
        XCTAssertNotNil(icon, "playIcon 应可访问")
    }

    func testPauseIconIsAccessible() {
        let icon = AudioPlayer.pauseIcon
        XCTAssertNotNil(icon, "pauseIcon 应可访问")
    }

    func testPlayAndPauseIconsAreDifferent() {
        // 两个图标不应是同一个对象
        XCTAssertFalse(AudioPlayer.playIcon === AudioPlayer.pauseIcon)
    }
}
