//
//  AudioPlayerViewController.swift
//  conan
//
//  Created by iFable on 2020/5/31.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayerViewController: UIViewController, AudioPlayerDelegate {
    
    var audioPlayer: AudioPlayer
    var audioItem: AVPlayerItem?
    var avPlayer: AVPlayer?
    
    var audioUrl: String? {
        didSet {
            let asset: AVAsset = AVAsset(url: URL(string: audioUrl!)!)
            audioPlayer.duration = "/ \(self.timeFilter(seconds: CMTimeGetSeconds(asset.duration)))"
            audioItem = AVPlayerItem(asset: asset)
            
            avPlayer = AVPlayer(playerItem: audioItem)
            avPlayer?.seek(to: CMTime(seconds: 270, preferredTimescale: 1))
            avPlayer?.preventsDisplaySleepDuringVideoPlayback = true
            avPlayer?.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main, using: { time in
                self.audioPlayer.currentTime = self.timeFilter(seconds: CMTimeGetSeconds(time))
                self.audioPlayer.percent = Float(CMTimeGetSeconds(time) / CMTimeGetSeconds(asset.duration))
            })
       }
   }
    
    var playing: Bool = false {
        didSet {
            if playing {
                audioPlayer.playButton.image = R.image.pauseIcon()
                avPlayer?.play()
            } else {
                audioPlayer.playButton.image = R.image.playIcon()
                avPlayer?.pause()
            }
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        audioPlayer = AudioPlayer()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        audioPlayer.delegate = self
        self.view = audioPlayer
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        audioItem = nil
        avPlayer = nil
    }
    
    func play() {
        self.playing = !self.playing
    }
    
    @objc func handlePlayEnd() {
        avPlayer?.seek(to: CMTime(value: 0, timescale: 1))
        self.playing = false
    }
    
    private func timeFilter(seconds: Double) -> String {
        var str: String = ""
        let minute = Int((seconds / 60).truncatingRemainder(dividingBy: 60))
        let second = Int(seconds.truncatingRemainder(dividingBy: 60))
        str += "\(minute):"
        if second < 10 {
            str += "0\(second)"
        } else {
            str += "\(second)"
        }
        return str
    }
}
