//
//  String+getDateString.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/31.
//

import Foundation
import UIKit


extension String {
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        guard let dateInfo = dateFormatter.date(from: self) else { return "정보 없음" }
        dateFormatter.timeZone = TimeZone.current
        let calendar = Calendar.current
        let timeComponents = calendar.dateComponents([.hour, .minute, .day, .month, .year], from: dateInfo)
        let nowComponents = calendar.dateComponents([.hour, .minute, .day, .month, .year], from: Date())
        guard let differenceMin = calendar.dateComponents([.minute], from: timeComponents, to: nowComponents).minute, let differenceHour = calendar.dateComponents([.hour], from: timeComponents, to: nowComponents).hour, let differenceDay = calendar.dateComponents([.day], from: timeComponents, to: nowComponents).day, let differenceMonth = calendar.dateComponents([.month], from: timeComponents, to: nowComponents).month, let differenceYear = calendar.dateComponents([.year], from: timeComponents, to: nowComponents).year else { return "정보 없음" }
        if differenceMin <= 60 {
            return "\(differenceMin)분 전"
        } else if differenceMin <= 1440 {
            return "\(differenceHour)시간 전"
        } else if differenceMonth <= 1 {
            return "\(differenceDay)일 전"
        } else if differenceYear <= 1 {
            return "\(differenceMonth)개월 전"
        } else {
            return "\(differenceYear)년 전"
        }
    }
    
    func getDateString_chat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        guard let dateInfo = dateFormatter.date(from: self) else { return "정보 없음" }
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a hh:mm"
        return dateFormatter.string(from: dateInfo)
    }
}

