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
}
