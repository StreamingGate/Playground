//
//  VideoListViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit
import Combine

class VideoListViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var type = 0
    let viewModel = MyHistoryViewModel()
    var navVC: MyPageNavigationController?
    private var cancellable: Set<AnyCancellable> = []
    
    private let footerView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    private let refreshControl = UIRefreshControl()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? MyPageNavigationController else { return }
        self.navVC = nav
        bindViewModel()
        setupUI()
    }
    
    // MARK: - Data Binding
    func bindViewModel() {
        self.viewModel.$myList.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] list in
                guard let self = self else { return }
                self.footerView.stopAnimating()
                self.collectionView.reloadData()
            }.store(in: &cancellable)
    }
    
    
    // MARK: - UI Setting
    func setupUI() {
        collectionView.register(CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.footerReferenceSize = CGSize(width: collectionView.bounds.width, height: 50)
        titleLabel.font = UIFont.SubTitle
        switch type {
        case 0:
            titleLabel.text = "시청한 동영상"
            viewModel.loadWachedList(vc: self, coordinator: navVC?.coordinator)
        case 1:
            titleLabel.text = "좋아요 표시한 동영상"
            viewModel.loadLikedList(vc: self, coordinator: navVC?.coordinator)
        default:
            titleLabel.text = "내 동영상"
            viewModel.loadUploadedist(vc: self, coordinator: navVC?.coordinator)
        }
    }
    
    // MARK: - Button Action
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

// TODO: 추가
extension VideoListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.myList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalVideoListCell", for: indexPath) as? HorizontalVideoListCell else {
            return UICollectionViewCell()
        }
        cell.setupUI()
        if type == 2 {
            cell.setupUploadedVideo(info: viewModel.myList[indexPath.item])
            return cell
        }
        if viewModel.myList[indexPath.item].uploaderNickname == nil {
            cell.setupLive(info: viewModel.myList[indexPath.item])
        } else {
            cell.setupVideo(info: viewModel.myList[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.viewModel.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath)
            footer.addSubview(footerView)
            footerView.frame = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 50)
            return footer
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.footerView.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.myList.count - 10 && !self.viewModel.isLoading {
            self.footerView.startAnimating()
            switch type {
            case 0:
                viewModel.loadWachedList(vc: self, coordinator: navVC?.coordinator)
            case 1:
                viewModel.loadLikedList(vc: self, coordinator: navVC?.coordinator)
            default:
                viewModel.loadUploadedist(vc: self, coordinator: navVC?.coordinator)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let navVC = self.navigationController as? MyPageNavigationController else{ return }
        navVC.coordinator?.showPlayer(info: self.viewModel.myList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 82)
    }
}

public class CollectionViewFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
