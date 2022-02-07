//
//  UploadViewController.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/04.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation
import Combine

class UploadViewController: UIViewController {
    let imagePicker = UIImagePickerController()
    let videoPicker = UIImagePickerController()
    @IBOutlet weak var videoPickerButton: UIButton!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var titlePlaceHolderLabel: UILabel!
    @IBOutlet weak var titleCountLabel: UILabel!
    @IBOutlet weak var explainTextView: UITextView!
    @IBOutlet weak var explainCountLabel: UILabel!
    @IBOutlet weak var explainPlaceHolderLabel: UILabel!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryContentLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var thumbnailImageTitleLabel: UILabel!
    @IBOutlet weak var thumbnailImageExplainLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var playerView: PlayerView!
    @IBOutlet weak var seekbar: CustomSlider!
    @IBOutlet weak var playPauseButton: UIButton!
    @Published var isPlay = false
    private var cancellable: Set<AnyCancellable> = []
    let player = AVPlayer()
    var navVC: CreateNavigationController?
    @Published var videoInfo: NSURL?
    var imageInfo: UIImage?
    var timeObserver: Any?
    var playControllTimer = Timer()
    var didEndPlay = false
    var categoryList: [String] = []
    @Published var selectedCategory: String?
    let categoryDic = ["ALL": "전체", "EDU": "교육", "SPORTS": "스포츠", "KPOP": "K-POP"]
    let toastLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? CreateNavigationController else { return }
        navVC = nav
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        videoPicker.delegate = self
        videoPicker.sourceType = .photoLibrary
        videoPicker.mediaTypes = [kUTTypeMovie as String]
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        MainServiceAPI.shared.getAllList(lastVideoId: -1, lastLiveId: -1, category: "ALL", size: 1) { result in
            if result["result"] as? String == "success" {
                guard let data = result["data"] as? HomeList else { return }
//                self.categoryList = data.categories.compactMap({ self.categoryDic[$0] ?? "기타" }).filter({ $0 != "전체" && $0 != "기타" })
                self.categoryList = data.categories.filter({ $0 != "ALL" })
            }
        }
        bindData()
        setupUI()
    }
    
    @objc func playerDidFinishPlaying() {
        self.didEndPlay = true
        self.isPlay = false
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let observer = timeObserver {
            self.playerView.player?.removeTimeObserver(observer)
        }
        self.playerView.player?.replaceCurrentItem(with: nil)
    }
    
    func setupUI() {
        videoPickerButton.setTitle("", for: .normal)
        
        closeButton.setTitle("", for: .normal)
        
        detailTitleLabel.font = UIFont.Content
        detailTitleLabel.textColor = UIColor.background
        
        titleTextView.textColor = UIColor.background
        titleTextView.font = UIFont.caption
        titleTextView.layer.borderColor = UIColor.placeHolder.cgColor
        titleTextView.layer.borderWidth = 1
        titleTextView.layer.cornerRadius = 10
        
        titlePlaceHolderLabel.textColor = UIColor.placeHolder
        titlePlaceHolderLabel.font = UIFont.caption
        titleCountLabel.font = UIFont.caption
        titleCountLabel.textColor = UIColor.placeHolder
        
        explainTextView.textColor = UIColor.background
        explainTextView.font = UIFont.caption
        explainTextView.layer.borderColor = UIColor.placeHolder.cgColor
        explainTextView.layer.borderWidth = 1
        explainTextView.layer.cornerRadius = 10
        
        explainPlaceHolderLabel.textColor = UIColor.placeHolder
        explainPlaceHolderLabel.font = UIFont.caption
        explainCountLabel.font = UIFont.caption
        explainCountLabel.textColor = UIColor.placeHolder
        
        categoryButton.layer.borderColor = UIColor.placeHolder.cgColor
        categoryButton.layer.borderWidth = 1
        categoryButton.layer.cornerRadius = 10
        
        thumbnailButton.layer.borderColor = UIColor.placeHolder.cgColor
        thumbnailButton.layer.borderWidth = 1
        thumbnailButton.layer.cornerRadius = 10
        
        categoryTitleLabel.font = UIFont.Content
        categoryTitleLabel.textColor = UIColor.background
        categoryContentLabel.font = UIFont.caption
        categoryContentLabel.textColor = UIColor.background
        
        thumbnailImageTitleLabel.font = UIFont.Content
        thumbnailImageTitleLabel.textColor = UIColor.background
        thumbnailImageExplainLabel.font = UIFont.caption
        thumbnailImageExplainLabel.textColor = UIColor.placeHolder
        
        uploadButton.backgroundColor = UIColor.PGOrange
        uploadButton.titleLabel?.font = UIFont.SubTitle
        uploadButton.layer.cornerRadius = 20
        
        playerView.layer.cornerRadius = 10
        playerView.layer.borderColor = UIColor.placeHolder.cgColor
        playerView.layer.borderWidth = 1
        
        titleTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        explainTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        playPauseButton.setTitle("", for: .normal)
    }
    
    func bindData() {
        self.$isPlay.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] tf in
                guard let self = self else { return }
                if tf {
                    if self.didEndPlay { self.isPlay = false }
                    self.playerView.player?.play()
                    self.playPauseButton.setImage(UIImage(named: "pause_white"), for: .normal)
                } else {
                    self.playerView.player?.pause()
                    self.playPauseButton.setImage(UIImage(named: "play_white"), for: .normal)
                }
            }.store(in: &cancellable)
        self.$videoInfo.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] url in
                guard let self = self else { return }
                guard let urlInfo = url as URL? else {
                    self.seekbar.isHidden = true
                    self.playPauseButton.isHidden = true
                    return
                }
                self.seekbar.isHidden = false
                self.playPauseButton.isHidden = false
                self.setSeekBar(url: urlInfo)
            }.store(in: &cancellable)
        self.$selectedCategory.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] selected in
                guard let self = self else { return }
                guard let info = selected, let categoryString = self.categoryDic[info] else {
                    self.categoryContentLabel.text = "카테고리를 선택해주세요"
                    return
                }
                self.categoryContentLabel.text = categoryString
            }.store(in: &cancellable)
        UploadProgress.shared.$isFinished.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] progress in
                guard let self = self else { return }
                switch progress {
                case .inProgress:
                    self.toastLabel.text = "비디오 업로드 중입니다..."
                case .fail:
                    self.toastLabel.text = "비디오 업로드에 실패했습니다"
                default:
                    self.toastLabel.text = "비디오 업로드 완료했습니다"
                    UIView.animate(withDuration: 2, delay: 0.3, options: .curveEaseOut) {
                        self.toastLabel.alpha = 0.0
                    } completion: { _ in
                        self.toastLabel.removeFromSuperview()
                    }
                }
            }.store(in: &cancellable)
    }
    
    func setSeekBar(url: URL) {
        let avAsset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: avAsset)
        self.player.replaceCurrentItem(with: item)
        playerView.player = self.player
        isPlay = true
        
        seekbar.minimumValue = 0
        seekbar.maximumValue = Float(CMTimeGetSeconds(avAsset.duration))
        seekbar.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        seekbar.addGestureRecognizer(tapGestureRecognizer)
        
        // Set Seekbar Interval
        let interval: Double = Double(0.1 * seekbar.maximumValue) / Double(seekbar.bounds.maxX)
        let time : CMTime = CMTimeMakeWithSeconds(interval, preferredTimescale: Int32(NSEC_PER_SEC))
        self.timeObserver = playerView.player?.addPeriodicTimeObserver(forInterval: time, queue: nil, using: {time in
            // seekbar update
            let duration = CMTimeGetSeconds(item.duration)
            let time = CMTimeGetSeconds(self.playerView.player!.currentTime())
            let value = Float(self.seekbar.maximumValue - self.seekbar.minimumValue) * Float(time) / Float(duration) + Float(self.seekbar.minimumValue)
            self.seekbar.value = value
        })
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began, .moved:
                self.playControllTimer.invalidate()
                self.isPlay = false
            case .ended:
                self.didEndPlay = false
                self.playControllTimer.invalidate()
                playerView.player?.seek(to: CMTimeMakeWithSeconds(Float64(seekbar.value), preferredTimescale: Int32(NSEC_PER_SEC)))
                self.isPlay = true
            default:
                break
            }
        }
    }
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        self.didEndPlay = false
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)
        let positionOfSlider: CGPoint = seekbar.frame.origin
        let widthOfSlider: CGFloat = seekbar.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(seekbar.maximumValue) / widthOfSlider)
        seekbar.setValue(Float(newValue), animated: true)
        let currentTime = CMTimeMakeWithSeconds(Float64(seekbar.value), preferredTimescale: Int32(NSEC_PER_SEC))
        playerView.player?.seek(to: currentTime)
    }
    
    @IBAction func playPauseButtonDidTap(_ sender: Any) {
        isPlay = !isPlay
    }
    
    @IBAction func videoPickerButtonDidTap(_ sender: Any) {
        self.present(videoPicker, animated: true, completion: nil)
    }
    
    @IBAction func thumbnailButtonDidTap(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.navVC?.coordinator?.dismiss()
    }
    
    @IBAction func backgroundDidTap(_ sender: Any) {
        titleTextView.resignFirstResponder()
        explainTextView.resignFirstResponder()
    }
    
    @IBAction func categoryButtonDidTap(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "카테고리를 선택해주세요", preferredStyle: .actionSheet)
        for i in categoryList {
            guard let categoryInfo = categoryDic[i] else { return }
            alert.addAction(UIAlertAction(title: categoryInfo, style: .default, handler: { _ in
                self.selectedCategory = i
            }))
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonDidTap(_ sender: Any) {
        guard let video = self.videoInfo as URL?, let titleInfo = titleTextView.text, titleInfo != "", let contentInfo = explainTextView.text, contentInfo != "", let categoryInfo = self.selectedCategory else {
            self.simpleAlert(message: "실시간 스트리밍에 필요한 모든 정보를 입력해주세요")
            return
        }
        uploadButton.isEnabled = false
        do {
            let videoData = try Data(contentsOf: video)
            let imageData = self.imageInfo?.pngData()
            self.navVC?.coordinator?.dismiss()
            UploadProgress.shared.isFinished = .inProgress
            UploadViewController.showToastMessage(toastLabel: toastLabel, font: UIFont.Component)
            DispatchQueue.global().sync {
                UploadServiceAPI.shared.post(video: videoData, image: imageData, title: titleInfo, content: contentInfo, category: categoryInfo) { result in
                    print("result : \(result)")
                    UploadProgress.shared.isFinished = .success
                    DispatchQueue.main.async {
                        self.uploadButton.isEnabled = false
                    }
                }
            }
         } catch let error {
             self.simpleAlert(message: "동영상 데이터를 가져오는 데 실패했습니다. 동영상을 다시 업로드해주세요")
             UploadProgress.shared.isFinished = .fail
             uploadButton.isEnabled = true
             print(error)
         }
    }
}

extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker == videoPicker {
            let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? NSURL
            self.videoInfo = videoURL
            videoPicker.dismiss(animated: true, completion: nil)
        } else {
            let imageInfo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            self.imageInfo = imageInfo
            thumbnailImageView.image = imageInfo
            imagePicker.dismiss(animated: true, completion: nil)
        }
    }
}

extension UploadViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleTextView {
            guard let textInfo = textView.text, textInfo != "" else {
                titlePlaceHolderLabel.isHidden = false
                titleCountLabel.text = "0/100"
                return
            }
            if textInfo.count <= 100 {
                titlePlaceHolderLabel.isHidden = true
                titleCountLabel.textColor = UIColor.placeHolder
                titleCountLabel.text = "\(textInfo.count)/100"
            } else {
                textView.deleteBackward()
                titleCountLabel.textColor = UIColor.systemRed
                titleCountLabel.text = "100/100"
            }
        } else {
            guard let textInfo = textView.text, textInfo != "" else {
                explainPlaceHolderLabel.isHidden = false
                explainCountLabel.text = "0/5000"
                return
            }
            if textInfo.count <= 5000 {
                explainPlaceHolderLabel.isHidden = true
                explainCountLabel.textColor = UIColor.placeHolder
                explainCountLabel.text = "\(textInfo.count)/5000"
            } else {
                textView.deleteBackward()
                explainCountLabel.textColor = UIColor.systemRed
                explainCountLabel.text = "5000/5000"
            }
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == titleTextView {
            titlePlaceHolderLabel.isHidden = true
        } else {
            explainPlaceHolderLabel.isHidden = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            if textView == titleTextView {
                titlePlaceHolderLabel.isHidden = false
            } else {
                explainPlaceHolderLabel.isHidden = false
            }
        }
    }
}
