//
//  AudioPlayerViewController.swift
//  conan
//
//  Created by iFable on 2020/5/31.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController, AudioPlayerViewDelegate {

    var audioPlayer: AudioPlayer
    private var audioItem: AVPlayerItem?
    private var avPlayer: AVPlayer?
    private var timeObserverToken: Any?
    private var loadTask: Task<Void, Never>?

    var audioUrl: String? {
        didSet {
            guard let audioUrl = audioUrl, let url = URL(string: audioUrl) else { return }
            let asset = AVURLAsset(url: url)

            loadTask?.cancel()
            loadTask = Task { [weak self] in
                guard let self = self else { return }
                do {
                    let duration = try await asset.load(.duration)
                    try Task.checkCancellation()
                    let durationInSeconds = CMTimeGetSeconds(duration)

                    await MainActor.run { [weak self] in
                        guard let self = self else { return }
                        try? Task.checkCancellation()
                        self.audioPlayer.duration = "/ \(self.timeFilter(seconds: durationInSeconds))"

                        // 移除旧观察器
                        if let token = self.timeObserverToken {
                            self.avPlayer?.removeTimeObserver(token)
                            self.timeObserverToken = nil
                        }

                        self.audioItem = AVPlayerItem(asset: asset)
                        self.avPlayer = AVPlayer(playerItem: self.audioItem)
                        self.avPlayer?.preventsDisplaySleepDuringVideoPlayback = true

                        // 重新注册通知（绑定具体 item）
                        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.handlePlayEnd), name: .AVPlayerItemDidPlayToEndTime, object: self.audioItem)

                        self.timeObserverToken = self.avPlayer?.addPeriodicTimeObserver(
                            forInterval: CMTime(value: 1, timescale: 1),
                            queue: .main,
                            using: { [weak self] time in
                                guard let self = self else { return }
                                let currentTime = CMTimeGetSeconds(time)
                                self.audioPlayer.currentTime = self.timeFilter(seconds: currentTime)
                                self.audioPlayer.percent = Float(currentTime / durationInSeconds)
                            }
                        )
                    }
                } catch is CancellationError {
                    // 任务已取消，忽略
                } catch {
                    print("Error loading asset duration: \(error.localizedDescription)")
                }
            }
       }
   }

    private var playing: Bool = false {
        didSet {
            if playing {
                audioPlayer.playButton.image = AudioPlayer.pauseIcon
                avPlayer?.play()
            } else {
                audioPlayer.playButton.image = AudioPlayer.playIcon
                avPlayer?.pause()
            }
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        audioPlayer = AudioPlayer()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        audioPlayer.delegate = self
        self.view = audioPlayer
        // 通知将在 audioItem 创建后注册，这里不再全局监听
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        avPlayer?.pause()
    }

    deinit {
        loadTask?.cancel()
        if let token = timeObserverToken {
            avPlayer?.removeTimeObserver(token)
        }
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: audioItem)
        avPlayer?.pause()
        audioItem = nil
        avPlayer = nil
    }

    // MARK: - AudioPlayerViewDelegate

    func audioPlayerDidRequestTogglePlayback() {
        self.playing = !self.playing
    }

    // MARK: - Private

    @objc private func handlePlayEnd() {
        avPlayer?.seek(to: CMTime(value: 0, timescale: 1))
        self.playing = false
    }

    func timeFilter(seconds: Double) -> String {
        let minute = Int((seconds / 60).truncatingRemainder(dividingBy: 60))
        let second = Int(seconds.truncatingRemainder(dividingBy: 60))
        let secondStr = second < 10 ? "0\(second)" : "\(second)"
        return "\(minute):\(secondStr)"
    }
}
