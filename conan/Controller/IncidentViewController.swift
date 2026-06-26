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

// MARK: - IncidentCollectionViewDataSource

final class IncidentCollectionViewDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private(set) var incident: Incident?
    private let viewWidth: CGFloat
    private let incidentId: Int

    init(incidentId: Int, viewWidth: CGFloat) {
        self.incidentId = incidentId
        self.viewWidth = viewWidth
    }

    func update(incident: Incident) {
        self.incident = incident
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        incident?.section.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: IncidentItem.reuseIdentifier,
            for: indexPath
        ) as? IncidentItem else {
            return UICollectionViewCell()
        }
        cell.item = incident?.section[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                  ofKind: kind,
                  withReuseIdentifier: NoticeCollectionReusableView.reuseIdentifier,
                  for: indexPath
              ) as? NoticeCollectionReusableView
        else {
            return UICollectionReusableView()
        }
        header.noticeImageUrl = APIConfiguration.moviePicture(id: incidentId)
        return header
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let font = UIFont.systemFont(ofSize: 15)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 5
        guard let desc = incident?.section[indexPath.row].desc else { return .zero }
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraph
        ]
        let rect = NSString(string: desc).boundingRect(
            with: CGSize(width: viewWidth * 0.9 - 20, height: CGFloat(MAXFLOAT)),
            options: .usesLineFragmentOrigin,
            attributes: attributes,
            context: nil
        )
        return CGSize(width: viewWidth, height: 46 + viewWidth * 0.54 + rect.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: viewWidth, height: viewWidth * 0.9 * 0.64)
    }
}

// MARK: - IncidentViewController

class IncidentViewController: UIViewController {

    private let incidentId: Int
    private let incidentService: IncidentProviding
    private var dataSource: IncidentCollectionViewDataSource!
    private var collectionView: UICollectionView?

    init(id: Int, incidentService: IncidentProviding) {
        self.incidentId = id
        self.incidentService = incidentService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        setupBackground()
        setupAudioPlayer()
        setupCollectionView()
        loadIncident()
    }

    // MARK: - Setup

    private func setupBackground() {
        let backgroundImage = UIImageView()
        backgroundImage.kf.setImage(
            with: URL(string: APIConfiguration.movieBackground(id: incidentId)),
            options: [.processor(BlurImageProcessor(blurRadius: 5.0))]
        )
        backgroundImage.contentMode = .scaleAspectFill
        self.view.addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints {
            make in
            make.edges.equalToSuperview()
        }
    }

    private func setupAudioPlayer() {
        let audioPlayerController = AudioPlayerViewController()
        audioPlayerController.audioUrl = APIConfiguration.movieAudio(id: incidentId)
        self.addChild(audioPlayerController)
        self.view.addSubview(audioPlayerController.view)

        audioPlayerController.view.snp.makeConstraints {
            make in
            make.width.equalTo(300)
            make.height.equalTo(56)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }
    }

    private func setupCollectionView() {
        dataSource = IncidentCollectionViewDataSource(
            incidentId: incidentId,
            viewWidth: self.view.frame.width
        )

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 40
        layout.itemSize = CGSize(width: self.view.frame.width, height: 0)

        let cv = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 0),
            collectionViewLayout: layout
        )
        cv.backgroundColor = .clear
        cv.delegate = dataSource
        cv.dataSource = dataSource
        cv.register(IncidentItem.self, forCellWithReuseIdentifier: IncidentItem.reuseIdentifier)
        cv.register(
            NoticeCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: NoticeCollectionReusableView.reuseIdentifier
        )

        self.view.addSubview(cv)
        cv.snp.makeConstraints {
            make in
            make.width.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(96)
            make.bottom.equalToSuperview()
        }
        self.collectionView = cv
    }

    // MARK: - Data Loading

    private func loadIncident() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let incident = try await self.incidentService.loadIncident(id: self.incidentId)
                await MainActor.run {
                    self.dataSource.update(incident: incident)
                    self.collectionView?.reloadData()
                }
            } catch {
                print("加载案件详情失败: \(error.localizedDescription)")
            }
        }
    }
}
