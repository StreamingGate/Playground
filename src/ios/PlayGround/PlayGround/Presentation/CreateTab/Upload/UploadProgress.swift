//
//  UploadProgress.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/08.
//

import Foundation

class UploadProgress {
    static let shared = UploadProgress()
    @Published var isFinished: Progress = .inProgress
}
