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
import SwiftKeychainWrapper
import WebRTC
import SwiftyJSON

class PlayViewController: UIViewController {
    // MARK: - Properties
    private var socket: EchoSocket?
    private var client: RoomClient?
    var videoTrack: RTCVideoTrack?
    private var delegate: RoomListener?
    var roomId = ""
    
    // player
    @IBOutlet weak var playView: PlayerView!
    @IBOutlet weak var playViewWidth: NSLayoutConstraint!
    @IBOutlet weak var playControllView: UIView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var backwardImageView: UIImageView!
    @IBOutlet weak var forwardImageView: UIImageView!
    @IBOutlet weak var playViewTop: NSLayoutConstraint!
    @IBOutlet weak var playViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var seekbar: CustomSlider!
    @IBOutlet weak var timeLabel: UILabel!
    var playControllTimer = Timer()
    let player = AVPlayer()
    @IBOutlet var playViewSingleTap: UITapGestureRecognizer!
    @IBOutlet var playControlViewSingleTap: UITapGestureRecognizer!
    @IBOutlet weak var seekbarBackView: UIView!
    var timeObserver: Any?
    var didEndPlay = false
    @Published var isPlay = false
    
    // mini player
    @IBOutlet weak var miniBackView: UIView!
    @IBOutlet var playPanGesture: UIPanGestureRecognizer!
    @IBOutlet var playControlPanGesture: UIPanGestureRecognizer!
    let miniTitleLabel = UILabel()
    let miniChannelNameLabel = UILabel()
    let miniPlayPauseButton = UIButton()
    let miniCloseButton = UIButton()
    var miniTapGesture = UITapGestureRecognizer()
    @Published var isMinimized: Bool = false
    private var cancellable: Set<AnyCancellable> = []
    var isMaximizing: Bool = true
    var lastTranslation: CGFloat = 0
    
    // remoteVideo (스트리밍 영상)
    @IBOutlet var remoteVideoView: RTCEAGLVideoView!
    @IBOutlet weak var remoteVideoViewLeading: NSLayoutConstraint!
    
    // button action
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeImageView: UIImageView!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    
    // video information
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
    @IBOutlet weak var explainContainerView: UIView!
    @IBOutlet weak var friendRequestLabel: UILabel!
    @IBOutlet weak var friendRequestButton: UIButton!
    
    // chatting
    @IBOutlet weak var chatSendButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatPlaceHolderLabel: UILabel!
    @IBOutlet weak var chatProfileImageView: UIImageView!
    @IBOutlet weak var chatSeparatorView: UIView!
    @IBOutlet weak var chatViewBottom: NSLayoutConstraint!

    @IBOutlet weak var chatContainerView: UIView!
    @IBOutlet weak var chatContainerViewTop: NSLayoutConstraint!
    @IBOutlet weak var chatContainerViewLeading: NSLayoutConstraint!
    @IBOutlet weak var chatContainerViewCenterX: NSLayoutConstraint!
    @IBOutlet weak var chatCountLabel: UILabel!
    
    @IBOutlet weak var safeBottomView: UIView!
    @IBOutlet weak var safeBottomViewHeight: NSLayoutConstraint!
    var chatDelegate: ChatSendDelegate?
    
    // orientation transition
    var portraitLayout: [NSLayoutConstraint] = []
    var landscapeLayout: [NSLayoutConstraint] = []
    
    // safearea margin
    var safeTop: CGFloat = 0
    var safeBottom: CGFloat = 0
    
    // transition handler
    var coordinator: PlayerCoordinator?

    let viewModel = PlayViewModel()
    
    // MARK: - View LifeCycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        safeBottom = self.parent?.view.safeAreaInsets.bottom ?? 0
        safeBottomViewHeight.constant = safeBottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAnimation()
        showAnimation()
        portraitLayout = [chatContainerViewLeading, chatContainerViewCenterX, chatContainerViewTop, playViewTop, playViewCenterX, playViewWidth]
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(audioRouteChangeListener(_:)), name: AVAudioSession.routeChangeNotification, object: nil)
        setupUI()
        
        // setting for mini player
        setMiniPlayerlayout()
        setMiniPlayerAction()
        
        bindingData()
    }
    
        
    @objc func audioRouteChangeListener(_ notification:Notification) {
        print("change audio listener")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.socket?.disconnect()
//        self.client = nil
        StatusServiceAPI.shared.stopWatchingVideo()
        self.client?.disconneectRecvTransport()
        if let observer = timeObserver {
            self.playView.player?.removeTimeObserver(observer)
            self.timeObserver = nil
        }
        self.playView.player?.replaceCurrentItem(with: nil)
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
            // landscape 모드
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
            // portrait 모드
            NSLayoutConstraint.deactivate(landscapeLayout)
            NSLayoutConstraint.deactivate(portraitLayout)
            NSLayoutConstraint.activate(portraitLayout)
        }
    }
    
    
    func setSpeakerStates(enabled: Bool, isLive: Bool) {
        let session = AVAudioSession.sharedInstance()
        var _: Error?
        if isLive {
            try? session.setCategory(AVAudioSession.Category.playAndRecord)
        } else {
            try? session.setCategory(AVAudioSession.Category.playback)
        }
        try? session.setMode(AVAudioSession.Mode.voiceChat)
        if enabled && (session.isHeadphonesConnected == false) {
            print("speaker")
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } else {
            print("headphone")
            try? session.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
        }
        try? session.setActive(true)
    }
    
    // MARK: - UI Setting
    func setupUI() {
        stretchButton.setTitle("", for: .normal)
        chatSendButton.setTitle("", for: .normal)
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
        friendRequestButton.setTitle("", for: .normal)
        friendRequestLabel.font = UIFont.Content
        guard let userInfo = UserManager.shared.userInfo else { return }
        chatProfileImageView.downloadImageFrom(link: userInfo.profileImage, contentMode: .scaleAspectFill)
        // TODO: 내가 올린 영상일 경우, '친구 신청' 보이지 않도록
    }
    
    
    // MARK: - Player, SeekBar, Gesture setting
    func setPlayer(urlInfo: String) {
        //player
        guard let url = URL(string: urlInfo) else {
            print("invalid url")
            return
        }
        let avAsset = AVURLAsset(url: url)
        let item = AVPlayerItem(asset: avAsset)
        self.player.replaceCurrentItem(with: item)
        playView.player = self.player
        isPlay = true
        
        setSpeakerStates(enabled: true, isLive: false)
        
        // 10 secs forward || backward
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
        self.timeObserver = playView.player?.addPeriodicTimeObserver(forInterval: time, queue: nil, using: {time in
            // seekbar update
            let duration = CMTimeGetSeconds(item.duration)
            let time = CMTimeGetSeconds(self.playView.player!.currentTime())
            let value = Float(self.seekbar.maximumValue - self.seekbar.minimumValue) * Float(time) / Float(duration) + Float(self.seekbar.minimumValue)
            self.seekbar.value = value
            guard let currentTime = self.playView.player?.currentTime() else { return }
            self.updateVideoPlayerState(currentTime: currentTime)
        })
    }

    @objc func playerDidFinishPlaying() {
        self.didEndPlay = true
        self.isPlay = false
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
                  let curSecsStr = timeformatter.string(from: NSNumber(value: curSecs)),
                  let endMinsStr = timeformatter.string(from: NSNumber(value: endMins)),
                  let endSecsStr = timeformatter.string(from: NSNumber(value: endSecs)) else { return }
            
            timeLabel.text = "\(curMinsStr):\(curSecsStr) / \(endMinsStr):\(endSecsStr)"
        }
    }
    
    // Mini size Player initialize
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
            miniCloseButton.widthAnchor.constraint(equalToConstant: 40),
            miniCloseButton.heightAnchor.constraint(equalToConstant: 40),
            miniPlayPauseButton.trailingAnchor.constraint(equalTo: self.miniCloseButton.leadingAnchor, constant: -20),
            miniPlayPauseButton.centerYAnchor.constraint(equalTo: self.miniBackView.centerYAnchor),
            miniPlayPauseButton.widthAnchor.constraint(equalToConstant: 40),
            miniPlayPauseButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    // add chat view
    func connectChatView(roomId: String?) {
        guard let chattingVC = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChattingViewController") as? ChattingViewController else { return }
        chattingVC.roomId = roomId ?? ""
        self.addChild(chattingVC)
        self.chatDelegate = chattingVC
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
        self.viewModel.$videoInfo.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] currentInfo in
                guard let self = self, let info = currentInfo else { return }
                if self.viewModel.isLive == true { return }
                StatusServiceAPI.shared.startWatchingVideo(id: self.viewModel.currentInfo?.id ?? 0, type: 0, videoRoomUuid: info.videoUuid ?? "", title: info.title)
                self.titleLabel.text = info.title
                self.channelNicknameLabel.text = info.uploaderNickname
                self.categoryLabel.text = "#\(self.viewModel.categoryDic[info.category] ?? "기타")"
                self.miniTitleLabel.text = info.title
                self.channelProfileImageView.downloadImageFrom(link: info.uploaderProfileImage, contentMode: .scaleAspectFill)
                self.viewLabel.text = "조회수 \(info.hits)회"
                self.playControllView.isHidden = self.viewModel.isLive
                self.miniPlayPauseButton.alpha = self.viewModel.isLive ? 0 : 1
                self.setPlayer(urlInfo: info.streamingUrl)
//                self.connectChatView(roomId: info.videoUuid)
            }.store(in: &cancellable)
        self.viewModel.$roomInfo.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] currentInfo in
                guard let self = self, let info = currentInfo else { return }
                if self.viewModel.isLive == false { return }
                StatusServiceAPI.shared.startWatchingVideo(id: info.roomId, type: 1, videoRoomUuid: info.uuid ?? "", title: info.title)
                self.titleLabel.text = info.title
                self.channelNicknameLabel.text = info.hostNickname ?? "익명"
                self.categoryLabel.text = "#\(self.viewModel.categoryDic[info.category] ?? "기타")"
                self.miniTitleLabel.text = info.title
                self.channelProfileImageView.downloadImageFrom(link: "https://d8knntbqcc7jf.cloudfront.net/profiles/\(info.hostUuid)", contentMode: .scaleAspectFill)
//                self.viewLabel.text = "조회수 \(info.hits)회"
                self.playControllView.isHidden = self.viewModel.isLive
                self.miniPlayPauseButton.alpha = self.viewModel.isLive ? 0 : 1
                self.connectWebSocket(roomUUID: info.uuid ?? "test1")
            }.store(in: &cancellable)
        self.viewModel.$currentInfo.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] currentInfo in
                guard let self = self, let info = currentInfo else { return }
                self.remoteVideoView.isHidden = true
                self.socket?.unregister(observer: self)
                self.socket?.disconnect()
                self.socket = nil
                self.client = nil
                self.delegate = nil
                if info.uploaderNickname == nil {
                    // 실시간 스트리밍인 경우
                    self.playView.player?.replaceCurrentItem(with: nil)
                    self.remoteVideoView.delegate = self
                } else {
                    // 비디오 스트리밍인 경우
                    self.videoTrack?.isEnabled = false
                    self.videoTrack?.remove(self.remoteVideoView)
                    self.videoTrack = nil
                }
                self.channelNicknameLabel.text = (info.uploaderNickname == nil) ? info.hostNickname : info.uploaderNickname
                self.miniChannelNameLabel.text = (info.uploaderNickname == nil) ? info.hostNickname : info.uploaderNickname
                self.connectChatView(roomId: info.uuid)
                self.viewModel.loadSingleInfo(vc: self, coordinator: self.coordinator)
            }.store(in: &cancellable)
        self.$isPlay.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] tf in
                guard let self = self else { return }
                if tf {
                    if self.didEndPlay { self.isPlay = false }
                    self.playView.player?.play()
                    self.miniPlayPauseButton.setImage(UIImage(named: "pause_black"), for: .normal)
                    self.playPauseButton.setImage(UIImage(named: "pause_white"), for: .normal)
                } else {
                    self.playView.player?.pause()
                    self.miniPlayPauseButton.setImage(UIImage(named: "play_black"), for: .normal)
                    self.playPauseButton.setImage(UIImage(named: "play_white"), for: .normal)
                }
            }.store(in: &cancellable)
        self.viewModel.$isLiked.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] tf in
                guard let self = self else { return }
                guard let liked = tf else {
                    self.likeButton.isEnabled = false
                    return
                }
                self.likeButton.isEnabled = true
                if liked {
                    self.likeImageView.image = UIImage(named: "thumbUp_fill_black")
                } else {
                    self.likeImageView.image = UIImage(named: "thumbUp_empty")
                }
            }.store(in: &cancellable)
        self.viewModel.$isDisliked.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] tf in
                guard let self = self else { return }
                guard let disliked = tf else {
                    self.dislikeButton.isEnabled = false
                    return
                }
                self.dislikeButton.isEnabled = true
                if disliked {
                    self.dislikeImageView.image = UIImage(named: "thumbDown_fill_black")
                } else {
                    self.dislikeImageView.image = UIImage(named: "thumbDown_empty")
                }
            }.store(in: &cancellable)
        self.viewModel.$likeCount.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] num in
                guard let self = self else { return }
                self.likeLabel.text = "\(num)회"
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
    @IBAction func likeButtonDidTap(_ sender: Any) {
        guard let info = viewModel.currentInfo, let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        likeButton.isEnabled = false
        if let liked = self.viewModel.isLiked, liked == true {
            MainServiceAPI.shared.cancelButtons(videoId: info.id, type: (info.hostNickname == nil ? 0 : 1), action: Action.Like, uuid: uuid) { result in
                DispatchQueue.main.async {
                    self.likeButton.isEnabled = true
                    if result["result"] as? String == "success" {
                        self.viewModel.likeCount = (self.viewModel.likeCount == 0 ? 0 : self.viewModel.likeCount - 1)
                        self.viewModel.isLiked = false
                    }
                }
            }
        } else {
            MainServiceAPI.shared.tapButtons(videoId: info.id, type: (info.hostNickname == nil ? 0 : 1), action: Action.Like, uuid: uuid) { result in
                print("result: \(result)")
                DispatchQueue.main.async {
                    self.likeButton.isEnabled = true
                    if result["result"] as? String == "success" {
                        self.viewModel.likeCount += 1
                        self.viewModel.isLiked = true
                    }
                }
            }
        }
    }
    
    @IBAction func dislikeButtonDidTap(_ sender: Any) {
        guard let info = viewModel.currentInfo, let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        dislikeButton.isEnabled = false
        if let disliked = self.viewModel.isDisliked, disliked == true {
            MainServiceAPI.shared.cancelButtons(videoId: info.id, type: (info.hostNickname == nil ? 0 : 1), action: Action.Dislike, uuid: uuid) { result in
                DispatchQueue.main.async {
                    self.dislikeButton.isEnabled = true
                    if result["result"] as? String == "success" {
                        self.viewModel.isDisliked = false
                    }
                }
            }
        } else {
            MainServiceAPI.shared.tapButtons(videoId: info.id, type: (info.hostNickname == nil ? 0 : 1), action: Action.Dislike, uuid: uuid) { result in
                print("result: \(result)")
                DispatchQueue.main.async {
                    self.dislikeButton.isEnabled = true
                    if result["result"] as? String == "success" {
                        self.viewModel.isDisliked = true
                    }
                }
            }
        }
    }
    
    @IBAction func shareButtonDidTap(_ sender: Any) {
        guard let id = self.viewModel.currentInfo?.id, let url = URL(string: "https://streaminggate.shop/video-play/\(id)") else { return }
        let shareSheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(shareSheetVC, animated: true, completion: nil)
    }
    
    
    @IBAction func reportButtonDidTap(_ sender: Any) {
        guard let info = viewModel.currentInfo, let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        reportButton.isEnabled = false
        MainServiceAPI.shared.tapButtons(videoId: info.id, type: (info.hostNickname == nil ? 0 : 1), action: Action.Report, uuid: uuid) { result in
            print("result: \(result)")
            DispatchQueue.main.async {
                self.reportButton.isEnabled = true
                if result["result"] as? String == "success" {
                    self.simpleAlert(message: "신고되었습니다")
                }
            }
        }
    }
    
    @IBAction func friendRequestButtonDidTap(_ sender: Any) {
        guard let info = viewModel.currentInfo, let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        // TODO: uuid 생기면 추가하기
    }
    
    func setMiniPlayerAction() {
        miniCloseButton.addTarget(self, action: #selector(miniCLoseButtonDidTap), for: .touchUpInside)
        miniPlayPauseButton.addTarget(self, action: #selector(miniPlayPauseButtonDidTap), for: .touchUpInside)
    }
    
    @objc func miniCLoseButtonDidTap() {
        chatTextView.resignFirstResponder()
        coordinator?.closeMiniPlayer(vc: self)
    }
    
    @objc func miniPlayPauseButtonDidTap() {
        togglePlay()
    }
    
    @IBAction func playPauseButtonDidTap(_ sender: Any) {
        togglePlay()
    }
    
    @IBAction func chatSendButtonDidTap(_ sender: Any) {
        chatTextView.resignFirstResponder()
        guard let message = chatTextView.text, message.isEmpty == false, let userInfo = UserManager.shared.userInfo, let nickname = userInfo.nickName else { return }
        chatTextView.text = ""
        chatPlaceHolderLabel.isHidden = false
        chatCountLabel.textColor = UIColor.placeHolder
        chatCountLabel.text = "0/200"
        self.chatDelegate?.sendChatMessage(nickname: nickname, message: message, senderRole: "VIEWER", chatType: "NORMAL")
    }
    
    func togglePlay() {
        guard let play = playView.player else { return }
        if (play.isPlaying) {
            miniPlayPauseButton.setImage(UIImage(named: "play_black"), for: .normal)
            playPauseButton.setImage(UIImage(named: "play_white"), for: .normal)
            isPlay = false
        } else {
            miniPlayPauseButton.setImage(UIImage(named: "pause_black"), for: .normal)
            playPauseButton.setImage(UIImage(named: "pause_white"), for: .normal)
            isPlay = true
        }
    }
    
    @IBAction func explainStretchButtonDidTap(_ sender: Any) {
        chatTextView.resignFirstResponder()
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
            if self.viewModel.isLive { return }
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
            let height = UIScreen.main.bounds.width / 16 * 9
            let maxHeight = UIScreen.main.bounds.height - safeTop - safeBottom - 150
            
            switch pan.state {
            case .began, .changed:
                self.lastTranslation = pan.translation(in: view).y
                if pan.location(in: self.parent?.view).y <= height / 2 {
                    self.setPlayViewOriginalSize()
                } else if pan.location(in: self.parent?.view).y >= maxHeight + 40 {
                    self.setPlayViewMinimizing()
                } else {
                    parent.playViewTopMargin.constant = pan.location(in: self.parent?.view).y - (height / 2)
                }
            case .ended:
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
        if isMinimized || self.viewModel.isLive { return }
        let point = gestureRecognizer.location(in: self.playView)
        let halfPosition = playView.frame.width / 2
        if point.x < (halfPosition - 30) {
            move10Secs(secs: -10)
        } else if point.x > (halfPosition + 30) {
            move10Secs(secs: 10)
        }
    }
    
    func move10Secs(secs: Double) {
        let duration = CMTimeGetSeconds(self.playView.player!.currentItem!.duration)
        let time = CMTimeGetSeconds(self.playView.player!.currentTime()) + secs
        let value = Float(self.seekbar.maximumValue - self.seekbar.minimumValue) * Float(time) / Float(duration) + Float(self.seekbar.minimumValue)
        self.seekbar.setValue(Float(value), animated: true)
        let currentTime = CMTimeMakeWithSeconds(Float64(seekbar.value), preferredTimescale: Int32(NSEC_PER_SEC))
        playView.player?.seek(to: currentTime)
        guard let currentTime = self.playView.player?.currentTime() else { return }
        self.updateVideoPlayerState(currentTime: currentTime)
        var stateImageView =  UIImageView()
        if secs < 0 {
            stateImageView = self.backwardImageView
        } else {
            stateImageView = self.forwardImageView
        }
        stateImageView.alpha = 1
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: .showHideTransitionViews, animations: {
            stateImageView.alpha = 0
        }, completion: nil)
    }
    
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began, .moved:
                self.playControllTimer.invalidate()
                self.isPlay = false
                let currentTime = CMTimeMakeWithSeconds(Float64(seekbar.value), preferredTimescale: Int32(NSEC_PER_SEC))
                self.updateVideoPlayerState(currentTime: currentTime)
            case .ended:
                self.didEndPlay = false
                self.playControllTimer.invalidate()
                playView.player?.seek(to: CMTimeMakeWithSeconds(Float64(seekbar.value), preferredTimescale: Int32(NSEC_PER_SEC)))
                self.isPlay = true
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
        self.didEndPlay = false
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
        chatTextView.resignFirstResponder()
        coordinator?.setPlayViewOriginalSize(vc: self)
    }
    
    func setPlayViewMinimizing() {
        chatTextView.resignFirstResponder()
        coordinator?.setPlayMinimizing(vc: self)
    }
}

extension PlayViewController {
    // MARK: - Watch live Streaming
    private func connectWebSocket(roomUUID: String) {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        self.socket = EchoSocket.init();
        self.socket?.register(observer: self)
        do {
            self.roomId = roomUUID
            try self.socket!.connect(wsUri: "wss://streaminggate.shop:4443/?room=\(roomUUID)&peer=\(uuid)&role=consume")
            print("--> wss://streaminggate.shop:4443/?room=\(roomUUID)&peer=\(uuid)&role=consume")
        } catch {
            print("Failed to connect to server")
        }
    }
    
    private func handleWebSocketConnected() {
        // Initialize mediasoup client
        self.initializeMediasoup()

        // Get router rtp capabilities
        guard let getRoomRtpCapabilitiesResponse: JSON = Request.shared.sendGetRoomRtpCapabilitiesRequest(socket: self.socket!, roomId: self.roomId) else { return }
        
        // Initialize mediasoup device
        let device: Device = Device.init()
        device.load(getRoomRtpCapabilitiesResponse["data"].description)
        print("handleWebSocketConnected() device loaded: \(device)")
        self.delegate = self
        self.client = RoomClient.init(socket: self.socket!, device: device, roomId: self.roomId, roomListener: self.delegate!)
        self.client!.createRecvTransport()
    }
    
    private func initializeMediasoup() {
        Mediasoupclient.initializePC()
        print("initializeMediasoup() client initialized")
        Logger.setDefaultHandler()
        Logger.setLogLevel(LogLevel.LOG_WARN)
    }
    
}

// MARK: - Chattign Input
extension PlayViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        chatPlaceHolderLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        chatPlaceHolderLabel.isHidden = !(textView.text.count == 0)
        if textView.text.count > 200 {
            textView.deleteBackward()
            chatCountLabel.textColor = UIColor.red
            return
        }
        chatCountLabel.textColor = UIColor.placeHolder
        chatCountLabel.text = "\(textView.text.count)/200"
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        chatPlaceHolderLabel.isHidden = !(textView.text.count == 0)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            guard let message = chatTextView.text, message.isEmpty == false, let userInfo = UserManager.shared.userInfo, let nickname = userInfo.nickName else { return false }
            chatTextView.text = ""
            chatPlaceHolderLabel.isHidden = false
            chatCountLabel.textColor = UIColor.placeHolder
            chatCountLabel.text = "0/200"
            self.chatDelegate?.sendChatMessage(nickname: nickname, message: message, senderRole: "VIEWER", chatType: "NORMAL")
            return false
        }
        return true
    }
}

// MARK: - Keyboard up/down adjustment
extension PlayViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - safeBottom
            chatViewBottom.constant = adjustmentHeight
            self.view.layoutIfNeeded()
        } else {
            chatViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

extension PlayViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.seekbarBackView) == true {
            return false
        } else if touch.view?.isDescendant(of: self.seekbar) == true {
            return false
        }
        return true
    }
}

extension PlayViewController : MessageObserver {
    func on(event: String, data: JSON?) {
        switch event {
        case ActionEvent.OPEN:
            print("socket connected")
            self.handleWebSocketConnected()
            break
        case ActionEvent.NEW_USER:
            print("NEW_USER id =" + data!["userId"]["userId"].stringValue)
            break
        case "556":
            print("NEW_CONSUMER data=" + data!.description)
            self.handleNewConsumerEvent(consumerInfo: data!["data"])
            break
        default:
            print("Unknown event " + event)
        }
    }
    
    private func handleNewConsumerEvent(consumerInfo: JSON) {
        print("handleNewConsumerEvent info = " + consumerInfo.description)
        // Start consuming
        self.client!.consumeTrack(consumerInfo: consumerInfo)
    }
}

// Extension for RoomListener
extension PlayViewController : RoomListener {
    func onNewConsumer(consumer: Consumer) {
        print("RoomListener::onNewConsumer kind=" + consumer.getKind())
        
        if consumer.getKind() == "video" {
            print("vide track loading!")
            if let track = consumer.getTrack() as? RTCVideoTrack {
                self.videoTrack = track
                self.videoTrack?.isEnabled = true
                self.videoTrack?.add(self.remoteVideoView)
                DispatchQueue.main.async {                
                    self.remoteVideoView.isHidden = false
                }
            } else {
                self.videoTrack?.isEnabled = false
                self.videoTrack?.remove(self.remoteVideoView)
                self.videoTrack = nil
            }
        } else {
            if let track = consumer.getTrack() as? RTCAudioTrack {
                print("audio track loading")
                track.isEnabled = true
                RTCAudioSession.sharedInstance().isAudioEnabled = true
                setSpeakerStates(enabled: true, isLive: true)
            }
        }
        
        do {
            consumer.getKind() == "video"
                ? try self.client!.resumeRemoteVideo()
                : try self.client!.resumeRemoteAudio()
        } catch {
            print("onNewConsumer() failed to resume remote track")
        }
    }
}

extension PlayViewController: RTCVideoViewDelegate {
    func videoView(_ videoView: RTCVideoRenderer, didChangeVideoSize size: CGSize) {
        // 실시간 방송 시 remoteVideoView 비율 설정
        remoteVideoView.translatesAutoresizingMaskIntoConstraints = false
        let playerHeight = UIScreen.main.bounds.width / 16 * 9
        let remoteVideoWidth = playerHeight / size.height * size.width
        remoteVideoViewLeading.constant = remoteVideoWidth >= UIScreen.main.bounds.width ? 0 : (UIScreen.main.bounds.width - remoteVideoWidth) / 2
        NSLayoutConstraint.activate([
            remoteVideoView.widthAnchor.constraint(equalTo: remoteVideoView.heightAnchor, multiplier: size.width / size.height)
        ])
        self.view.layoutIfNeeded()
        self.remoteVideoView.layoutIfNeeded()
    }
}


extension AVAudioSession {
    
    static var isHeadphonesConnected: Bool {
        return sharedInstance().isHeadphonesConnected
    }

    var isHeadphonesConnected: Bool {
        return !currentRoute.outputs.filter { $0.isHeadphones }.isEmpty
    }

}

extension AVAudioSessionPortDescription {
    var isHeadphones: Bool {
        return portType == AVAudioSession.Port.headphones
    }
}
