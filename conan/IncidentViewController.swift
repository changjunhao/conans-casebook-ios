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

class IncidentViewController: UIViewController, IncidentLoaderDelegate {
    
    var id: Int
    var incident: Incident?
    var scrollView: UIScrollView?
    var stackView: UIStackView?
    
    init(id: Int) {
        self.id = id
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemBackground
        } else {
            self.view.backgroundColor = .white
        }
        
        let loader = IncidentLoader()
        loader.delegate = self
        loader.loadListData(id: self.id)
        
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
        
        scrollView = UIScrollView()
        scrollView!.isUserInteractionEnabled = true
        self.view.addSubview(scrollView!)
        scrollView!.snp.makeConstraints {
            make in
            make.width.equalToSuperview()
            make.top.equalTo(audioPlayerController.view.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        let noticeImage = UIImageView()
        noticeImage.kf.setImage(with: URL(string: "https://oss-materials.ifable.cn/conan/m\(id)-pic-2.png"))
        scrollView!.addSubview(noticeImage)
        noticeImage.snp.makeConstraints {
            make in
            make.width.equalTo(self.view.bounds.size.width * 0.9)
            make.height.equalTo(self.view.bounds.size.width * 0.9 * 0.64)
            make.centerX.equalToSuperview()
        }
        
        stackView = UIStackView()
        stackView!.spacing = 10
        stackView!.axis = .vertical
        stackView!.distribution = .fillEqually
        stackView!.alignment = .center
        self.scrollView!.addSubview(stackView!)
        stackView!.snp.makeConstraints {
            make in
            make.width.equalTo(self.view.bounds.size.width)
            make.height.equalTo(3410)
            make.top.equalTo(noticeImage.snp.bottom)
        }
    }
    
    func successLoader(incident: Incident) {
        self.incident = incident
        self.scrollView?.contentSize = CGSize(width: self.view.bounds.size.width, height: 3410)
        for (_, item) in self.incident!.section.enumerated() {
            let incidentItemView = IncidentItem(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
            incidentItemView.item = item
            stackView!.addArrangedSubview(incidentItemView)
        }
    }
    
    func failureLoader(failure: Error) {
        print(failure)
    }

}
