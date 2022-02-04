//
//  LiveViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/10.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import Combine

class LiveViewController: UIViewController {
    let captureSession = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let photoOutput = AVCapturePhotoOutput()
    
    let sessionQueue = DispatchQueue(label: "session queue")
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    
    let viewModel = ChatViewModel()
    private var cancellable: Set<AnyCancellable> = []
    @Published var isBottomFocused = true
    @Published var isPinned = false
    
    @IBOutlet weak var chatViewBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomScrollImageView: UIImageView!
    @IBOutlet weak var bottomScrollButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var cameraViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var cameraViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var liveSignRedView: UIView!
    @IBOutlet weak var liveSignLabel: UILabel!
    @IBOutlet weak var timeBlackView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var participantsNumLabel: UILabel!
    @IBOutlet weak var likeNumLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatPlaceHolderLabel: UILabel!
    @IBOutlet weak var chatCountLabel: UILabel!
    
    var safeBottom: CGFloat = 0
    
    // transition handler
    var coordinator: PlayerCoordinator?

    
    // MARK: - View Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraViewTopMargin.constant = -(self.view.safeAreaInsets.top)
        cameraViewBottomMargin.constant = -(self.view.safeAreaInsets.bottom)
        liveSignRedView.roundCorners([.topLeft , .bottomLeft], radius: 3)
        timeBlackView.roundCorners([.topRight , .bottomRight], radius: 3)
        safeBottom = self.parent?.view.safeAreaInsets.bottom ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        cameraView.session = captureSession
        sessionQueue.async {
            self.setupSession()
            self.startSession()
        }
        setupUI()
        viewModel.roomId = "ae0a8eb9-ff2c-4256-8be7-f8a9e84a3afa"
        viewModel.connectToSocket()
        bindViewModelData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.disconnectToSocket()
    }
    
    func setupUI() {
        switchButton.setTitle("", for: .normal)
        sendButton.setTitle("", for: .normal)
        liveSignLabel.font = UIFont.caption
        timeLabel.font = UIFont.caption
        participantsNumLabel.font = UIFont.caption
        likeNumLabel.font = UIFont.caption
    }
    
    func bindViewModelData() {
        viewModel.$chatList.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] list in
                guard let self = self else { return }
                self.tableView.reloadData()
                if self.isBottomFocused {
                    self.tableView.scrollToBottom()
                }
            }.store(in: &cancellable)
        $isBottomFocused.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] isFocused in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: .showHideTransitionViews, animations: {
                    if isFocused {
                        self.bottomScrollButton.alpha = 0
                        self.bottomScrollImageView.alpha = 0
                    } else {
                        self.bottomScrollButton.alpha = 1
                        self.bottomScrollImageView.alpha = 1
                    }
                }, completion: nil)
            }.store(in: &cancellable)
    }
    
    
    @IBAction func switchCamera(sender: Any) {
        guard videoDeviceDiscoverySession.devices.count > 1 else {
            return
        }
        sessionQueue.async {
            let currentVideoDevice = self.videoDeviceInput.device
            let currentPosition = currentVideoDevice.position
            let isFront = currentPosition == .front
            let preferredPosition: AVCaptureDevice.Position = isFront ? .back : .front
            
            let devices = self.videoDeviceDiscoverySession.devices
            var newVideoDevice: AVCaptureDevice?
            newVideoDevice = devices.first { $0.position == preferredPosition }
            
            // update captureSession
            
            if let newDevice = newVideoDevice {
                do {
                    let videoDeviceInput = try AVCaptureDeviceInput(device: newDevice)
                    self.captureSession.beginConfiguration()
                    self.captureSession.removeInput(self.videoDeviceInput)
                    
                    // add new device input
                    if self.captureSession.canAddInput(videoDeviceInput) {
                        self.captureSession.addInput(videoDeviceInput)
                        self.videoDeviceInput = videoDeviceInput
                    } else {
                        self.captureSession.addInput(self.videoDeviceInput)
                    }
                
                    self.captureSession.commitConfiguration()
                } catch let error {
                    print("error occured while creating device input: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @IBAction func sendButtonDidTap(_ sender: Any) {
        chatTextView.resignFirstResponder()
        guard let message = chatTextView.text, message.isEmpty == false else { return }
        chatTextView.text = ""
        chatPlaceHolderLabel.isHidden = false
        chatCountLabel.textColor = UIColor.placeHolder
        chatCountLabel.text = "0/200"
        viewModel.sendMessage(message: message, nickname: "nickname", type: isPinned == true ? "PINNED" : "NORMAL", role: "VIEWER")
    }
    
    @IBAction func finishButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bottomScrollDidTap(_ sender: Any) {
        self.tableView.scrollToBottom()
        isBottomFocused = true
    }
}


extension LiveViewController {
    // MARK: - Setup session and preview
    func setupSession() {
        captureSession.sessionPreset = .photo
        captureSession.beginConfiguration()
        
        // Add Video Input
        do {
            var defaultVideoDevice: AVCaptureDevice?
            if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                defaultVideoDevice = dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                defaultVideoDevice = frontCameraDevice
            }
            
            guard let camera = defaultVideoDevice else {
                captureSession.commitConfiguration()
                return
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: camera)
            
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                captureSession.commitConfiguration()
                return
            }
        } catch {
            captureSession.commitConfiguration()
            return
        }
        
        
        // Add photo output
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            captureSession.commitConfiguration()
            return
        }
        
        captureSession.commitConfiguration()
    }
    
    func startSession() {
        if !captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.stopRunning()
            }
        }
    }
}


extension LiveViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LiveChatCell", for: indexPath) as? LiveChatCell else { return UITableViewCell()}
        cell.setupUI(info: viewModel.chatList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 스크롤이 하단이 아닐 경우 새 메세지가 왔을 때 하단으로 자동 스크롤되지 않도록
        if (viewModel.chatList.count - 1) == indexPath.row {
            if viewModel.isMaximum == true {
                viewModel.isMaximum = false
            } else {
                isBottomFocused = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 스크롤이 하단일 경우 새 메세지가 왔을 때 하단으로 자동 스크롤되도록
        if (viewModel.chatList.count - 1) == indexPath.row {
            isBottomFocused = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension LiveViewController: UITextViewDelegate {
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
            guard let message = chatTextView.text, message.isEmpty == false else { return false }
            chatTextView.text = ""
            chatPlaceHolderLabel.isHidden = false
            chatCountLabel.textColor = UIColor.placeHolder
            chatCountLabel.text = "0/200"
            viewModel.sendMessage(message: message, nickname: "nickname", type: "NORMAL", role: "VIEWER")
            return false
        }
        return true
    }
}

// MARK: - Keyboard up/down adjustment
extension LiveViewController {
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
