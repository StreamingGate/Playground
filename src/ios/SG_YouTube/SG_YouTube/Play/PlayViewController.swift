//
//  PlayViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2021/12/29.
//

import Foundation
import UIKit
import Combine

class PlayViewController: UIViewController {
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var playViewWidth: NSLayoutConstraint!
    @IBOutlet weak var playControllView: UIView!
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
    
    var portraitLayout: [NSLayoutConstraint] = []
    var landscapeLayout: [NSLayoutConstraint] = []
    
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
    
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareAnimation()
        showAnimation()
        playViewWidth.constant = UIScreen.main.bounds.width
        portraitLayout = [chatContainerViewLeading, chatContainerViewCenterX, chatContainerViewTop, playViewTop, playViewCenterX, playViewWidth]
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            self.tabBarController?.tabBar.alpha = 0
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
        titleLabel.font = UIFont.Component
        viewLabel.font = UIFont.caption
        viewLabel.textColor = UIColor.customDarkGray
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
        miniCloseButton.backgroundColor = UIColor.black
        miniPlayPauseButton.backgroundColor = UIColor.darkGray
        chatContainerView.translatesAutoresizingMaskIntoConstraints = false
        playView.translatesAutoresizingMaskIntoConstraints = false
        miniBackView.translatesAutoresizingMaskIntoConstraints = false
        miniTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        miniChannelNameLabel.translatesAutoresizingMaskIntoConstraints = false
        miniPlayPauseButton.translatesAutoresizingMaskIntoConstraints = false
        miniCloseButton.translatesAutoresizingMaskIntoConstraints = false
        connectChatView()
    }
    
    func setMiniPlayerlayout() {
        self.view.addSubview(miniBackView)
        self.miniBackView.addSubview(miniTitleLabel)
        self.miniBackView.addSubview(miniChannelNameLabel)
        self.miniBackView.addSubview(miniPlayPauseButton)
        self.miniBackView.addSubview(miniCloseButton)
        let miniTitleTrailing = miniTitleLabel.trailingAnchor.constraint(equalTo: self.miniBackView.trailingAnchor, constant: -80)
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
            miniPlayPauseButton.trailingAnchor.constraint(equalTo: self.miniCloseButton.leadingAnchor, constant: -10),
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
        }, completion: nil)
    }
    
    // MARK: - Button Action
    func setMiniPlayerAction() {
        miniCloseButton.addTarget(self, action: #selector(miniCLoseButtonDidTap), for: .touchUpInside)
    }
    
    @objc func miniCLoseButtonDidTap() {
        let targetY = (UIScreen.main.bounds.height)
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
            self.view.center = CGPoint(x: self.view.frame.width / 2, y: (self.view.frame.height / 2) + targetY)
        } completion: { _ in
            guard let parent = self.parent as? CustomTabViewController else { return }
            parent.playContainerView.isHidden = true
            parent.playViewTopMargin.constant = 0
            parent.removePlayer()
        }
    }
    
    @IBAction func explainStretchButtonDidTap(_ sender: Any) {
        guard let explainVC = UIStoryboard(name: "Play", bundle: nil).instantiateViewController(withIdentifier: "PlayExplainViewController") as? PlayExplainViewController else { return }
        self.addChild(explainVC)
        self.explainContainerView.addSubview((explainVC.view)!)
        explainVC.view.frame = self.explainContainerView.bounds
        explainVC.didMove(toParent: self)
    }
    
    @IBAction func minimizeButtonDidTap(_ sender: Any) {
        AppUtility.lockOrientation(.portrait)
        isMinimized = true
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        self.tabBarController?.tabBar.alpha = 1
        self.tabBarController?.setTabBar(hidden: false, animated: true, along: self.parent?.transitionCoordinator)
        self.playControllTimer.invalidate()
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            self.setPlayViewMinimizing()
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
        guard let parent = self.parent as? CustomTabViewController else { return }
        if isMinimized {
            isMinimized = false
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                self.playViewWidth.constant = UIScreen.main.bounds.width
                parent.playViewTopMargin.constant = 0
                parent.tabBarHeight.constant = 0
                parent.tabBarStackView.isHidden = true
                parent.tabBarSeparatorView.isHidden = true
                parent.bottomWhiteView.isHidden = true
                parent.view.backgroundColor = UIColor.black
            }
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
                    self.view.backgroundColor = UIColor.black.withAlphaComponent(1)
                    parent.playViewTopMargin.constant = 0
                    parent.tabBarHeight.constant = 0
                    parent.tabBarStackView.isHidden = true
                    parent.tabBarSeparatorView.isHidden = true
                    parent.bottomWhiteView.isHidden = true
                    parent.view.backgroundColor = UIColor.black
                    self.playViewWidth.constant = UIScreen.main.bounds.width
                } else if pan.location(in: self.parent?.view).y >= maxHeight + 40 {
                    self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
                    parent.playViewTopMargin.constant = maxHeight
                    parent.tabBarHeight.constant = 80
                    parent.tabBarStackView.isHidden = false
                    parent.tabBarSeparatorView.isHidden = false
                    parent.bottomWhiteView.isHidden = false
                    parent.view.backgroundColor = UIColor.white
                    let targetWidth =  80 / 9 * 16
                    self.playViewWidth.constant = CGFloat(targetWidth)
                } else {
                    self.view.backgroundColor = UIColor.black.withAlphaComponent(percentage)
                    parent.playViewTopMargin.constant = pan.location(in: self.parent?.view).y - (height / 2)
                }
            case .ended:
                let height = UIScreen.main.bounds.width / 16 * 9
                let maxHeight = UIScreen.main.bounds.height - safeTop - safeBottom - 150
                if lastTranslation == 0 {
                    if pan.location(in: self.parent?.view).y <= self.view.frame.height / 2 {
                        self.isMinimized = false
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                            self.view.backgroundColor = UIColor.black.withAlphaComponent(1)
                            parent.playViewTopMargin.constant = 0
                            parent.tabBarHeight.constant = 0
                            parent.tabBarStackView.isHidden = true
                            parent.tabBarSeparatorView.isHidden = true
                            parent.bottomWhiteView.isHidden = true
                            parent.view.backgroundColor = UIColor.black
                            self.playViewWidth.constant = UIScreen.main.bounds.width
                        }
                    } else {
                        self.isMinimized = true
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                            self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
                            parent.playViewTopMargin.constant = maxHeight
                            parent.tabBarHeight.constant = 80
                            parent.tabBarStackView.isHidden = false
                            parent.tabBarSeparatorView.isHidden = false
                            parent.bottomWhiteView.isHidden = false
                            parent.view.backgroundColor = UIColor.white
                            let targetWidth =  80 / 9 * 16
                            self.playViewWidth.constant = CGFloat(targetWidth)
                        }
                    }
                } else if lastTranslation < 0 {
                    if pan.location(in: self.parent?.view).y < (height / 2) {
                        let value = UIInterfaceOrientation.landscapeRight.rawValue
                        UIDevice.current.setValue(value, forKey: "orientation")
                    } else {
                        self.isMinimized = false
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                            self.view.backgroundColor = UIColor.black.withAlphaComponent(1)
                            parent.playViewTopMargin.constant = 0
                            parent.tabBarHeight.constant = 0
                            parent.tabBarStackView.isHidden = true
                            parent.tabBarSeparatorView.isHidden = true
                            parent.bottomWhiteView.isHidden = true
                            parent.view.backgroundColor = UIColor.black
                            self.playViewWidth.constant = UIScreen.main.bounds.width
                        }
                    }
                } else {
                    self.isMinimized = true
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
                        parent.playViewTopMargin.constant = maxHeight
                        parent.tabBarHeight.constant = 80
                        parent.tabBarStackView.isHidden = false
                        parent.tabBarSeparatorView.isHidden = false
                        parent.bottomWhiteView.isHidden = false
                        parent.view.backgroundColor = UIColor.white
                        let targetWidth =  80 / 9 * 16
                        self.playViewWidth.constant = CGFloat(targetWidth)
                    }
                }
            default:
                break
            }
        } else {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    // MARK: - PlayView layout change
    func setPlayViewOriginalSize() {
    }
    
    func setPlayViewMinimizing() {
    }
    
    func moveViewWithPan(view: UIView, sender: UIPanGestureRecognizer) {
        // translation : -는 위로, +는 아래로
        let translation = sender.translation(in: view)
        view.center = CGPoint(x: view.center.x, y: view.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
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
