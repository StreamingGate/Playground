//
//  PlayViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2021/12/29.
//

import Foundation
import UIKit
import Combine
import AVFoundation

class PlayViewController: UIViewController {
    @IBOutlet weak var playView: PlayerView!
    @IBOutlet weak var playViewWidth: NSLayoutConstraint!
    @IBOutlet weak var playControllView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var backwardImageView: UIImageView!
    @IBOutlet weak var forwardImageView: UIImageView!
    var playControllTimer = Timer()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleBackView: UIView!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var channelProfileImageView: UIImageView!
    @IBOutlet weak var channelNicknameLabel: UILabel!
    @IBOutlet weak var stretchButton: UIButton!
    @IBOutlet weak var channelView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var chatSendButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatPlaceHolderLabel: UILabel!
    @IBOutlet weak var chatProfileImageView: UIImageView!
    @IBOutlet weak var chatSeparatorView: UIView!
    @IBOutlet weak var chatViewBottom: NSLayoutConstraint!
    @IBOutlet weak var playViewTop: NSLayoutConstraint!
    @IBOutlet weak var playViewCenterX: NSLayoutConstraint!

    @IBOutlet weak var explainContainerView: UIView!
    @IBOutlet weak var chatContainerViewTop: NSLayoutConstraint!
    @IBOutlet weak var chatContainerView: UIView!
    @IBOutlet weak var chatContainerViewLeading: NSLayoutConstraint!
    @IBOutlet weak var chatContainerViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var previewImage: UIImageView!
    
    var portraitLayout: [NSLayoutConstraint] = []
    var landscapeLayout: [NSLayoutConstraint] = []
    
    @IBOutlet weak var seekbar: CustomSlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet var playControlPanGesture: UIPanGestureRecognizer!
    @IBOutlet var playPanGesture: UIPanGestureRecognizer!
    
    @Published var isMinimized: Bool = false
    private var cancellable: Set<AnyCancellable> = []
    var isMaximizing: Bool = true
    var lastTranslation: CGFloat = 0
    
    @IBOutlet weak var miniBackView: UIView!
    let miniTitleLabel = UILabel()
    let miniChannelNameLabel = UILabel()
    let miniPlayPauseButton = UIButton()
    let miniCloseButton = UIButton()
    var miniTapGesture = UITapGestureRecognizer()
    
    var safeTop: CGFloat = 0
    var safeBottom: CGFloat = 0
    
    var coordinator: PlayerCoordinator?
    let player = AVPlayer()
    @IBOutlet var playViewSingleTap: UITapGestureRecognizer!
    @IBOutlet var playControlViewSingleTap: UITapGestureRecognizer!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAnimation()
        showAnimation()
        playViewWidth.constant = UIScreen.main.bounds.width
        portraitLayout = [chatContainerViewLeading, chatContainerViewCenterX, chatContainerViewTop, playViewTop, playViewCenterX, playViewWidth]
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        setPlayer()
        setupUI()
        setMiniPlayerlayout()
        setMiniPlayerAction()
        bindingData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        titleLabel.isHidden = UIDevice.current.orientation.isLandscape
        viewLabel.isHidden = UIDevice.current.orientation.isLandscape
        categoryLabel.isHidden = UIDevice.current.orientation.isLandscape
        stackView.isHidden = UIDevice.current.orientation.isLandscape
        titleBackView.isHidden = UIDevice.current.orientation.isLandscape
        stretchButton.isHidden = UIDevice.current.orientation.isLandscape
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            self.coordinator?.dismissExplain(vc: self)
            self.view.backgroundColor = UIColor.black
            NSLayoutConstraint.deactivate(portraitLayout)
            NSLayoutConstraint.deactivate(landscapeLayout)
            landscapeLayout = [chatContainerView.topAnchor.constraint(equalTo: self.view.topAnchor),
               playView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
               playView.trailingAnchor.constraint(equalTo: self.chatContainerView.leadingAnchor),
               chatContainerView.widthAnchor.constraint(equalToConstant: 350)
            ]
            NSLayoutConstraint.activate(landscapeLayout)
        } else {
            print("Portrait")
            NSLayoutConstraint.deactivate(landscapeLayout)
            NSLayoutConstraint.deactivate(portraitLayout)
            NSLayoutConstraint.activate(portraitLayout)
        }
    }
    
    // MARK: - UI Setting
    func setupUI() {
        self.view.backgroundColor = UIColor.black
        titleLabel.font = UIFont.Component
        viewLabel.font = UIFont.caption
        viewLabel.textColor = UIColor.customDarkGray
        timeLabel.font = UIFont.caption
        categoryLabel.font = UIFont.highlightCaption
        channelNicknameLabel.font = UIFont.Content
        channelProfileImageView.backgroundColor = UIColor.placeHolder
        channelProfileImageView.layer.cornerRadius = 33 / 2
        chatSendButton.layer.cornerRadius = 15
        chatPlaceHolderLabel.font = UIFont.Content
        chatProfileImageView.backgroundColor = UIColor.placeHolder
        chatTextView.font = UIFont.Content
        chatProfileImageView.layer.cornerRadius = 25 / 2
        miniBackView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        miniTitleLabel.font = UIFont.Component
        miniTitleLabel.text = "title"
        miniChannelNameLabel.font = UIFont.caption
        miniChannelNameLabel.text = "channel"
        miniChannelNameLabel.textColor = UIColor.customDarkGray
        miniCloseButton.setImage(UIImage(named: "xMark_black"), for: .normal)
        miniPlayPauseButton.setImage(UIImage(named: "pause_black"), for: .normal)
        chatContainerView.translatesAutoresizingMaskIntoConstraints = false
        playView.translatesAutoresizingMaskIntoConstraints = false
        miniBackView.translatesAutoresizingMaskIntoConstraints = false
        miniTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        miniChannelNameLabel.translatesAutoresizingMaskIntoConstraints = false
        miniPlayPauseButton.translatesAutoresizingMaskIntoConstraints = false
        miniCloseButton.translatesAutoresizingMaskIntoConstraints = false
        connectChatView()
    }
    
    
    // MARK: - Player, SeekBar, Gesture setting
    func setPlayer() {
        //player
        let url = URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!
        let avAsset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: avAsset)
        self.player.replaceCurrentItem(with: item)
        playView.player = self.player
        playView.player?.play()
        
        let doubleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(gestureRecognizer:)))
        doubleTap.numberOfTapsRequired = 2
        self.playView.addGestureRecognizer(doubleTap)
        playViewSingleTap.require(toFail: doubleTap)
        playViewSingleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
        
        let doubleTap2: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(gestureRecognizer:)))
        doubleTap2.numberOfTapsRequired = 2
        self.playControllView.addGestureRecognizer(doubleTap2)
        playControlViewSingleTap.require(toFail: doubleTap2)
        playControlViewSingleTap.delaysTouchesBegan = true
        doubleTap.delaysTouchesBegan = true
        
        //slider
        seekbar.minimumValue = 0
        seekbar.maximumValue = Float(CMTimeGetSeconds(avAsset.duration))
        seekbar.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(sliderTapped(gestureRecognizer:)))
        seekbar.addGestureRecognizer(tapGestureRecognizer)
        
        // Set Seekbar Interval
        let interval: Double = Double(0.1 * seekbar.maximumValue) / Double(seekbar.bounds.maxX)
        let time : CMTime = CMTimeMakeWithSeconds(interval, preferredTimescale: Int32(NSEC_PER_SEC))
        playView.player?.addPeriodicTimeObserver(forInterval: time, queue: nil, using: {time in
            // seekbar update
            let duration = CMTimeGetSeconds(self.playView.player!.currentItem!.duration)
            let time = CMTimeGetSeconds(self.playView.player!.currentTime())
            let value = Float(self.seekbar.maximumValue - self.seekbar.minimumValue) * Float(time) / Float(duration) + Float(self.seekbar.minimumValue)
            self.seekbar.value = value
            guard let currentTime = self.playView.player?.currentTime() else { return }
            self.updateVideoPlayerState(currentTime: currentTime)
        })
    }
    
    // Player timeLabel change
    func updateVideoPlayerState(currentTime: CMTime) {
        let currentTimeInSeconds = CMTimeGetSeconds(currentTime)
        if let currentItem = playView.player?.currentItem {
            let duration = currentItem.duration
            if (CMTIME_IS_INVALID(duration)) {
                return;
            }
            let totalTimeInSeconds = CMTimeGetSeconds(duration)
            let curMins = currentTimeInSeconds / 60
            let curSecs = currentTimeInSeconds.truncatingRemainder(dividingBy: 60)
            let endMins = totalTimeInSeconds / 60
            let endSecs = totalTimeInSeconds.truncatingRemainder(dividingBy: 60)
            let timeformatter = NumberFormatter()
            timeformatter.minimumIntegerDigits = 2
            timeformatter.minimumFractionDigits = 0
            timeformatter.roundingMode = .down

            guard let curMinsStr = timeformatter.string(from: NSNumber(value: curMins)),
                  let curSecsStr = timeformatter.string(from: NSNumber(value: curSecs)), let endMinsStr = timeformatter.string(from: NSNumber(value: endMins)),
                  let endSecsStr = timeformatter.string(from: NSNumber(value: endSecs)) else {
                return
            }
            timeLabel.text = "\(curMinsStr):\(curSecsStr) / \(endMinsStr):\(endSecsStr)"
        }
    }
    
    // Player size change
    func setMiniPlayerlayout() {
        self.view.addSubview(miniBackView)
        self.miniBackView.addSubview(miniTitleLabel)
        self.miniBackView.addSubview(miniChannelNameLabel)
        self.miniBackView.addSubview(miniPlayPauseButton)
        self.miniBackView.addSubview(miniCloseButton)
        let miniTitleTrailing = miniTitleLabel.trailingAnchor.constraint(equalTo: self.miniBackView.trailingAnchor, constant: -90)
        miniTitleTrailing.priority = UILayoutPriority(250)
        NSLayoutConstraint.activate([
            miniBackView.leadingAnchor.constraint(equalTo: self.playView.trailingAnchor),
            miniBackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            miniBackView.topAnchor.constraint(equalTo: self.playView.topAnchor),
            miniBackView.bottomAnchor.constraint(equalTo: self.playView.bottomAnchor),
            miniTitleLabel.leadingAnchor.constraint(equalTo: self.miniBackView.leadingAnchor, constant: 15),
            miniTitleTrailing,
            miniTitleLabel.centerYAnchor.constraint(equalTo: self.miniBackView.centerYAnchor, constant: -12),
            miniChannelNameLabel.leadingAnchor.constraint(equalTo: self.miniBackView.leadingAnchor, constant: 15),
            miniChannelNameLabel.topAnchor.constraint(equalTo: self.miniTitleLabel.bottomAnchor, constant: 1),
            miniCloseButton.centerYAnchor.constraint(equalTo: self.miniBackView.centerYAnchor),
            miniCloseButton.trailingAnchor.constraint(equalTo: self.miniBackView.trailingAnchor, constant: -15),
            miniCloseButton.widthAnchor.constraint(equalToConstant: 24),
            miniCloseButton.heightAnchor.constraint(equalToConstant: 24),
            miniPlayPauseButton.trailingAnchor.constraint(equalTo: self.miniCloseButton.leadingAnchor, constant: -20),
            miniPlayPauseButton.centerYAnchor.constraint(equalTo: self.miniBackView.centerYAnchor),
            miniPlayPauseButton.widthAnchor.constraint(equalToConstant: 24),
            miniPlayPauseButton.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    func connectChatView() {
        guard let chattingVC = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChattingViewController") as? ChattingViewController else { return }
        self.addChild(chattingVC)
        self.chatContainerView.addSubview((chattingVC.view)!)
        chattingVC.view.frame = self.chatContainerView.bounds
        chattingVC.didMove(toParent: self)
    }
    
    // MARK: - Data Binding
    func bindingData() {
        $isMinimized.receive(on: RunLoop.main)
            .sink { [weak self] tf in
                guard let self = self  else { return }
                self.miniBackView.isHidden = !tf
                if tf {
                    let targetWidth =  80 / 9 * 16
                    self.playViewWidth.constant = CGFloat(targetWidth)
                    AppUtility.lockOrientation(.portrait)
                } else {
                    self.playViewWidth.constant = UIScreen.main.bounds.width
                    AppUtility.lockOrientation(.all)
                }
            }.store(in: &cancellable)
    }
    
    // MARK: - Animation Setting
    func prepareAnimation(){
        self.view.transform = CGAffineTransform.init(translationX: 0, y: UIScreen.main.bounds.height)
     }
    
    func showAnimation(){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: .showHideTransitionViews, animations: {
            self.view.transform = CGAffineTransform.identity
            self.parent?.view.backgroundColor = UIColor.black
        }, completion: nil)
    }
    
    // MARK: - Button Action
    func setMiniPlayerAction() {
        miniCloseButton.addTarget(self, action: #selector(miniCLoseButtonDidTap), for: .touchUpInside)
        miniPlayPauseButton.addTarget(self, action: #selector(miniPlayPauseButtonDidTap), for: .touchUpInside)
    }
    
    @objc func miniCLoseButtonDidTap() {
        coordinator?.closeMiniPlayer(vc: self)
    }
    
    @objc func miniPlayPauseButtonDidTap() {
        togglePlay()
    }
    
    @IBAction func playPauseButtonDidTap(_ sender: Any) {
        togglePlay()
    }
    
    func togglePlay() {
        guard let play = playView.player else { return }
        if (play.isPlaying) {
            miniPlayPauseButton.setImage(UIImage(named: "play_black"), for: .normal)
            playPauseButton.setImage(UIImage(named: "play_white"), for: .normal)
            play.pause()
        } else {
            miniPlayPauseButton.setImage(UIImage(named: "pause_black"), for: .normal)
            playPauseButton.setImage(UIImage(named: "pause_white"), for: .normal)
            play.play()
        }
    }
    
    @IBAction func explainStretchButtonDidTap(_ sender: Any) {
        coordinator?.showExplain(vc: self)
    }
    
    @IBAction func minimizeButtonDidTap(_ sender: Any) {
        AppUtility.lockOrientation(.portrait)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.playControllTimer.invalidate()
        self.setPlayViewMinimizing()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.playControllView.alpha = 0
        }
    }
    
    @IBAction func enlargeButtonDidTap(_ sender: Any) {
        if UIDevice.current.value(forKey: "orientation") as? Int == UIInterfaceOrientation.landscapeRight.rawValue {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        } else {
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    // MARK: - Gesture recognizing
    @IBAction func backTapped(_ sender: Any) {
        chatTextView.resignFirstResponder()
    }
    
    @IBAction func playViewTapped(_ sender: Any) {
        chatTextView.resignFirstResponder()
        if isMinimized {
            self.setPlayViewOriginalSize()
        } else {
            self.playControllTimer.invalidate()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.playControllView.alpha = 1
            } completion: { _ in
                self.playControllTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { timer in
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                        self.playControllView.alpha = 0
                    }
                })
            }
        }
    }
    
    @IBAction func playControllerViewTapped(_ sender: Any) {
        self.playControllTimer.invalidate()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.playControllView.alpha = 0
        }
    }
    
    @IBAction func playViewDidPan(_ sender: Any) {
        guard let pan = sender as? UIPanGestureRecognizer, let parent = self.parent as? CustomTabViewController else { return }
        if UIDevice.current.value(forKey: "orientation") as? Int == UIInterfaceOrientation.portrait.rawValue {
            self.view.backgroundColor = UIColor.white
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.playControllView.alpha = 0
            }
            self.playControllTimer.invalidate()
            let targetY = UIScreen.main.bounds.height - safeTop - safeBottom - 160
            let percentage = 1 - (pan.location(in: self.parent?.view).y / targetY)
            switch pan.state {
            case .began, .changed:
                self.lastTranslation = pan.translation(in: view).y
                let height = UIScreen.main.bounds.width / 16 * 9
                let maxHeight = UIScreen.main.bounds.height - safeTop - safeBottom - 150
                if pan.location(in: self.parent?.view).y <= height / 2 {
                    self.setPlayViewOriginalSize()
                } else if pan.location(in: self.parent?.view).y >= maxHeight + 40 {
                    self.setPlayViewMinimizing()
                } else {
                    parent.playViewTopMargin.constant = pan.location(in: self.parent?.view).y - (height / 2)
                }
            case .ended:
                let height = UIScreen.main.bounds.width / 16 * 9
                if lastTranslation == 0 {
                    if pan.location(in: self.parent?.view).y <= self.view.frame.height / 2 {
                        self.setPlayViewOriginalSize()
                    } else {
                        self.setPlayViewMinimizing()
                    }
                } else if lastTranslation < 0 {
                    if pan.location(in: self.parent?.view).y < (height / 2) {
                        let value = UIInterfaceOrientation.landscapeRight.rawValue
                        UIDevice.current.setValue(value, forKey: "orientation")
                    } else {
                        self.setPlayViewOriginalSize()
                    }
                } else {
                    self.setPlayViewMinimizing()
                }
            default:
                break
            }
        } else {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    @objc func handleDoubleTap(gestureRecognizer: UITapGestureRecognizer) {
        if isMinimized { return }
        let point = gestureRecognizer.location(in: self.playView)
        let halfPosition = playView.frame.width / 2
        if point.x < (halfPosition - 30) {
            let duration = CMTimeGetSeconds(self.playView.player!.currentItem!.duration)
            let time = CMTimeGetSeconds(self.playView.player!.currentTime()) - 10
            let value = Float(self.seekbar.maximumValue - self.seekbar.minimumValue) * Float(time) / Float(duration) + Float(self.seekbar.minimumValue)
            self.seekbar.setValue(Float(value), animated: true)
            let currentTime = CMTimeMakeWithSeconds(Float64(seekbar.value), preferredTimescale: Int32(NSEC_PER_SEC))
            playView.player?.seek(to: currentTime)
            guard let currentTime = self.playView.player?.currentTime() else { return }
            self.updateVideoPlayerState(currentTime: currentTime)
            self.backwardImageView.alpha = 1
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: .showHideTransitionViews, animations: {
                self.backwardImageView.alpha = 0
            }, completion: nil)
        } else if point.x > (halfPosition + 30) {
            let duration = CMTimeGetSeconds(self.playView.player!.currentItem!.duration)
            let time = CMTimeGetSeconds(self.playView.player!.currentTime()) + 10
            let value = Float(self.seekbar.maximumValue - self.seekbar.minimumValue) * Float(time) / Float(duration) + Float(self.seekbar.minimumValue)
            self.seekbar.setValue(Float(value), animated: true)
            let currentTime = CMTimeMakeWithSeconds(Float64(seekbar.value), preferredTimescale: Int32(NSEC_PER_SEC))
            playView.player?.seek(to: currentTime)
            guard let currentTime = self.playView.player?.currentTime() else { return }
            self.updateVideoPlayerState(currentTime: currentTime)
            self.forwardImageView.alpha = 1
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: .showHideTransitionViews, animations: {
                self.forwardImageView.alpha = 0
            }, completion: nil)
        }
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began, .moved:
                self.playControllTimer.invalidate()
                self.playView.player?.pause()
                let currentTime = CMTimeMakeWithSeconds(Float64(seekbar.value), preferredTimescale: Int32(NSEC_PER_SEC))
                self.updateVideoPlayerState(currentTime: currentTime)
            case .ended:
                self.playControllTimer.invalidate()
                playView.player?.seek(to: CMTimeMakeWithSeconds(Float64(seekbar.value), preferredTimescale: Int32(NSEC_PER_SEC)))
                self.playView.player?.play()
                self.playControllTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                        self.playControllView.alpha = 0
                    }
                })
            default:
                break
            }
        }
    }
    
    @objc func sliderTapped(gestureRecognizer: UIGestureRecognizer) {
        let pointTapped: CGPoint = gestureRecognizer.location(in: self.view)
        let positionOfSlider: CGPoint = seekbar.frame.origin
        let widthOfSlider: CGFloat = seekbar.frame.size.width
        let newValue = ((pointTapped.x - positionOfSlider.x) * CGFloat(seekbar.maximumValue) / widthOfSlider)
        seekbar.setValue(Float(newValue), animated: true)
        let currentTime = CMTimeMakeWithSeconds(Float64(seekbar.value), preferredTimescale: Int32(NSEC_PER_SEC))
        playView.player?.seek(to: currentTime)
        updateVideoPlayerState(currentTime: currentTime)
    }
    
    // MARK: - PlayView layout change
    func setPlayViewOriginalSize() {
        coordinator?.setPlayViewOriginalSize(vc: self)
    }
    
    func setPlayViewMinimizing() {
        coordinator?.setPlayMinimizing(vc: self)
    }
}

// MARK: - Chattign Input
extension PlayViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        chatPlaceHolderLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        chatPlaceHolderLabel.isHidden = !(textView.text.count == 0)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        chatPlaceHolderLabel.isHidden = !(textView.text.count == 0)
    }
}

// MARK: - Keyboard up/down adjustment
extension PlayViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            chatViewBottom.constant = adjustmentHeight
            self.view.layoutIfNeeded()
        } else {
            chatViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}


