//
//  AudioPlayer.swift
//  conan
//
//  Created by iFable on 2020/5/31.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit
import SnapKit

protocol AudioPlayerViewDelegate: AnyObject {
    func audioPlayerDidRequestTogglePlayback()
}

class AudioPlayer: UIView {

    // 图标资源
    private static let playIcon = UIImage(named: "playIcon") ?? UIImage()
    private static let pauseIcon = UIImage(named: "pauseIcon") ?? UIImage()

    weak var delegate: AudioPlayerViewDelegate?

    var playButton: UIImageView
    var durationLabel: UILabel
    var currentTimeLabel: UILabel
    var progressView: UIProgressView

    var duration: String = "/ 0:00" {
        didSet {
            self.durationLabel.text = duration
        }
    }
    var currentTime: String = "0:00" {
        didSet {
            self.currentTimeLabel.text = currentTime
        }
    }
    var percent: Float = 0.0 {
        didSet {
            self.progressView.progress = percent
        }
    }


    override init(frame: CGRect) {

        playButton = UIImageView()
        playButton.image = .playIcon
        playButton.contentMode = .center

        durationLabel = UILabel()
        durationLabel.text = duration
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.textColor = .label
        currentTimeLabel = UILabel()
        currentTimeLabel.text = currentTime
        currentTimeLabel.font = UIFont.systemFont(ofSize: 14)
        currentTimeLabel.textColor = .label

        progressView = UIProgressView()
        progressView.progress = percent

        super.init(frame: frame)

        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 28
        self.layer.masksToBounds = true

        self.addSubview(playButton)
        playButton.snp.makeConstraints{
            make in
            make.width.equalTo(32)
            make.height.equalTo(48)
            make.centerY.equalToSuperview()
            make.left.equalTo(10)
        }
        playButton.isUserInteractionEnabled = true
        playButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePlay)))

        self.addSubview(currentTimeLabel)
        currentTimeLabel.snp.makeConstraints {
            make in
            make.width.equalTo(32)
            make.centerY.equalToSuperview()
            make.left.equalTo(playButton.snp.right)
        }
        self.addSubview(durationLabel)
        durationLabel.snp.makeConstraints {
            make in
            make.width.equalTo(40)
            make.centerY.equalToSuperview()
            make.left.equalTo(currentTimeLabel.snp.right)
        }
        self.addSubview(progressView)
        progressView.snp.makeConstraints {
            make in
            make.left.equalTo(durationLabel.snp.right).offset(5)
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func handlePlay() {
        self.delegate?.audioPlayerDidRequestTogglePlayback()
    }
}
