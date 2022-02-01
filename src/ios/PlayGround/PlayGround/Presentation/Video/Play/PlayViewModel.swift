//
//  PlayViewModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/01.
//

import Foundation
import UIKit
import Combine

class PlayViewModel {
    let categoryDic = ["ALL": "전체", "EDU": "교육", "SPORTS": "스포츠", "KPOP": "K-POP"]
    
    @Published var currentInfo: GeneralVideo?
}
