//
//  AudioPlayer.swift
//  conan
//
//  Created by iFable on 2020/5/31.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit
import SnapKit

protocol AudioPlayerDelegate {
    func play()
}

class AudioPlayer: UIView {
    
    var delegate: AudioPlayerDelegate?
    
    var playButton: UIImageView
    var durationLable: UILabel
    var currentTimeLable: UILabel
    var progressView: UIProgressView
    
    var duration: String = "/ 0:00" {
        didSet {
            self.durationLable.text = duration
        }
    }
    var currentTime: String = "0:00" {
        didSet {
            self.currentTimeLable.text = currentTime
        }
    }
    var percent: Float = 0.0 {
        didSet {
            self.progressView.progress = percent
        }
    }
    
    
    override init(frame: CGRect) {
        
        playButton = UIImageView()
        playButton.image = R.image.playIcon()
        playButton.contentMode = .center
        
        durationLable = UILabel()
        durationLable.text = duration
        durationLable.font = UIFont.systemFont(ofSize: 14)
        durationLable.textColor = .black
        currentTimeLable = UILabel()
        currentTimeLable.text = currentTime
        currentTimeLable.font = UIFont.systemFont(ofSize: 14)
        currentTimeLable.textColor = .black
        
        progressView = UIProgressView()
        progressView.progress = percent
        
        super.init(frame: frame)
        
        self.backgroundColor = .white
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
        
        self.addSubview(currentTimeLable)
        currentTimeLable.snp.makeConstraints {
            make in
            make.width.equalTo(32)
            make.centerY.equalToSuperview()
            make.left.equalTo(playButton.snp.right)
        }
        self.addSubview(durationLable)
        durationLable.snp.makeConstraints {
            make in
            make.width.equalTo(40)
            make.centerY.equalToSuperview()
            make.left.equalTo(currentTimeLable.snp.right)
        }
        self.addSubview(progressView)
        progressView.snp.makeConstraints {
            make in
            make.left.equalTo(durationLable.snp.right).offset(5)
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePlay() {
        self.delegate?.play()
    }
}
