//
//  IncidentViewController.swift
//  conan
//
//  Created by iFable on 2020/5/31.
//  Copyright © 2020 iFable. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class IncidentViewController: UIViewController {
    
    var id: Int
    var audioPlayer: AudioPlayer?
    var incident: Incident?
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loader = IncidentLoader()
        loader.loadListData(id: self.id) {
            [weak self] succcess, incident in
            if (succcess) {
                self?.incident = incident
            }
        }
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemBackground
        } else {
            self.view.backgroundColor = .white
        }
        let backageImage = UIImageView(frame: self.view.bounds)
        backageImage.kf.setImage(with: URL(string: "https://oss-materials.ifable.cn/conan/m\(id)-bg.jpg"), options: [.processor(BlurImageProcessor(blurRadius: 5.0))])
        backageImage.contentMode = .center
        self.view.addSubview(backageImage)
        
        let audioPlayerController = AudioPlayerViewController()
        audioPlayerController.audioUrl = "https://oss-materials.ifable.cn/conan/m\(id).mp3"
        self.addChild(audioPlayerController)
        self.view.addSubview(audioPlayerController.view)
        
        audioPlayerController.view.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(56)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }

        let noticeImage = UIImageView()
        noticeImage.kf.setImage(with: URL(string: "https://oss-materials.ifable.cn/conan/m\(id)-pic-2.png"))
        self.view.addSubview(noticeImage)
        noticeImage.snp.makeConstraints {
            make in
            make.width.equalTo(self.view.bounds.size.width * 0.9)
            make.height.equalTo(self.view.bounds.size.width * 0.9 * 0.64)
            make.top.equalTo(audioPlayerController.view.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }

}
