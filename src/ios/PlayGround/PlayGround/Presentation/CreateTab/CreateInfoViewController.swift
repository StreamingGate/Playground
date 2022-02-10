//
//  LiveStreamingInfoViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit
import AVFoundation
import MobileCoreServices
import Combine

class createInfoViewController: UIViewController {
    @IBOutlet weak var currentAccountLabel: UILabel!
    @IBOutlet weak var accountNicknameLabel: UILabel!
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
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingCancelButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var cameraView: CameraView!
    @IBOutlet weak var cameraViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var cameraViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var loadingViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var loadingViewBottomMargin: NSLayoutConstraint!
    
    let imagePicker = UIImagePickerController()
    var imageInfo: UIImage?
    
    let captureSession = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let photoOutput = AVCapturePhotoOutput()
    
    let sessionQueue = DispatchQueue(label: "session queue")
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    
    var navVC: CreateNavigationController?
    var categoryList: [String] = []
    @Published var selectedCategory: String?
    let categoryDic = ["ALL": "전체", "EDU": "교육", "SPORTS": "스포츠", "KPOP": "K-POP"]
    private var cancellable: Set<AnyCancellable> = []
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cameraViewTopMargin.constant = -(self.view.safeAreaInsets.top)
        cameraViewBottomMargin.constant = -(self.view.safeAreaInsets.bottom)
        loadingViewTopMargin.constant = -(self.view.safeAreaInsets.top)
        loadingViewBottomMargin.constant = (self.view.safeAreaInsets.bottom)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? CreateNavigationController else { return }
        navVC = nav
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        
        cameraView.session = captureSession
        sessionQueue.async {
            self.setupSession()
            self.startSession()
        }
        
        MainServiceAPI.shared.getAllList(lastVideoId: -1, lastLiveId: -1, category: "ALL", size: 1) { result in
            guard let data = NetworkResultManager.shared.analyze(result: result, vc: self, coordinator: self.navVC?.coordinator) as? HomeList else { return }
            self.categoryList = data.categories.filter({ $0 != "ALL" })
        }
        bindData()
        setupUI()
    }
    
    func setupUI() {
        closeButton.setTitle("", for: .normal)
        currentAccountLabel.font = UIFont.bottomTab
        currentAccountLabel.textColor = UIColor.background
        accountNicknameLabel.font = UIFont.Component
        accountNicknameLabel.textColor = UIColor.background
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
        
        startButton.backgroundColor = UIColor.PGOrange
        startButton.titleLabel?.font = UIFont.SubTitle
        startButton.layer.cornerRadius = 20
        
        profileImageView.backgroundColor = UIColor.separator
        profileImageView.layer.cornerRadius = 33 / 2
        
        loadingLabel.font = UIFont.Tab
        loadingLabel.textColor = UIColor.white
        
        loadingCancelButton.backgroundColor = UIColor.white
        loadingCancelButton.tintColor = UIColor.black
        loadingCancelButton.titleLabel?.font = UIFont.SubTitle
        loadingCancelButton.layer.cornerRadius = 20
        
        titleTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        explainTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func bindData() {
        self.$selectedCategory.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] selected in
                guard let self = self else { return }
                guard let info = selected, let categoryString = self.categoryDic[info] else {
                    self.categoryContentLabel.text = "카테고리를 선택해주세요"
                    return
                }
                self.categoryContentLabel.text = categoryString
            }.store(in: &cancellable)
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
    
    @IBAction func startButtonDidTap(_ sender: Any) {
        guard let titleInfo = titleTextView.text, titleInfo != "", let contentInfo = explainTextView.text, contentInfo != "", let categoryInfo = self.selectedCategory, let thumbnail = self.imageInfo, var imageData = thumbnail.pngData() else {
            self.simpleAlert(message: "실시간 스트리밍에 필요한 모든 정보를 입력해주세요")
            return
        }
        let roomUUID = UUID().uuidString
        startButton.isEnabled = false
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.loadingView.alpha = 1
        }
        var quality: CGFloat = 1
        while imageData.count >= 1572864 {
            quality -= 0.1
            if let newData = thumbnail.jpegData(compressionQuality: quality) {
                imageData = newData
            }
        }
        let binaryImage = imageData.base64EncodedString()
        RoomServiceAPI.shared.createRoom(uuid: roomUUID, title: titleInfo, content: contentInfo, thumbnail: binaryImage, category: categoryInfo) { result in
            if result["result"] as? String == "success" {
                DispatchQueue.main.async {
                    self.navVC?.roomUuid = roomUUID
                    self.navVC?.coordinator?.startBroadcasting()
                }
            } else {
                DispatchQueue.main.async {
                    self.simpleAlert(message: "동영상 데이터를 가져오는 데 실패했습니다. 동영상을 다시 업로드해주세요")
                    self.startButton.isEnabled = true
                }
            }
        }
    }
    
    @IBAction func loadingCancleButtonDidTap(_ sender: Any) {
        self.navVC?.coordinator?.dismiss()
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.navVC?.coordinator?.dismiss()
    }
    
    @IBAction func tempButtonDidTap(_ sender: Any) {
        self.navVC?.coordinator?.startBroadcasting()
    }
    
    @IBAction func thumbnailButtonDidTap(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func backgroundDidTap(_ sender: Any) {
        titleTextView.resignFirstResponder()
        explainTextView.resignFirstResponder()
    }
}



extension createInfoViewController {
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

extension createInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageInfo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imageInfo = imageInfo
        thumbnailImageView.image = imageInfo
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

extension createInfoViewController: UITextViewDelegate {
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
