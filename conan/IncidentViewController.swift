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

class IncidentViewController: UIViewController, IncidentLoaderDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var id: Int
    var incident: Incident?
    var collectionView: UICollectionView?
    
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
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 40
        layout.itemSize = CGSize(width: self.view.frame.width, height: 0)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 0), collectionViewLayout: layout)
        collectionView?.backgroundColor = .clear
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.register(IncidentItem.self, forCellWithReuseIdentifier: "itemId")
        //注册header
        collectionView?.register(noticeCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "notice-image")
                
        
        self.view.addSubview(collectionView!)
        collectionView!.snp.makeConstraints {
            make in
            make.width.equalToSuperview()
            make.top.equalTo(audioPlayerController.view.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func successLoader(incident: Incident) {
        self.incident = incident
        collectionView?.reloadData()
    }
    
    func failureLoader(failure: Error) {
        print(failure)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = self.incident?.section.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: IncidentItem = collectionView.dequeueReusableCell(withReuseIdentifier: "itemId", for: indexPath) as! IncidentItem
        
        cell.item = self.incident?.section[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let font = UIFont.systemFont(ofSize: 15)
        //通过富文本来设置行间距
        let paraph = NSMutableParagraphStyle()
        //将行间距设置为28
        paraph.lineSpacing = 5
        let rect = NSString(string: (self.incident?.section[indexPath.row].desc)!).boundingRect(with: CGSize(width: self.view.frame.width * 0.9 - 20, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paraph], context: nil)
        
        return CGSize(width: self.view.frame.width, height: 46 + self.view.frame.width * 0.54 + rect.height )
    }
    
    //设置HeadView的宽高
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.width * 0.9 * 0.64)
    }
    
    //返回自定义HeadView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var v = noticeCollectionReusableView()
        if kind == UICollectionView.elementKindSectionHeader {
            v = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "notice-image", for: indexPath) as! noticeCollectionReusableView
            v.noticeImageUrl = "https://oss-materials.ifable.cn/conan/m\(id)-pic-2.png"
        }
        return v
    }

}
