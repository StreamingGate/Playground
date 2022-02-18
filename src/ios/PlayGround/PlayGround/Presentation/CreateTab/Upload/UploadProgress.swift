//
//  UploadProgress.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/08.
//

import Foundation

/**
 global thread에서 실행되는 비디오 업로드 상태를 알기 위한 class
 */
class UploadProgress {
    static let shared = UploadProgress()
    @Published var isFinished: Progress = .inProgress
}
