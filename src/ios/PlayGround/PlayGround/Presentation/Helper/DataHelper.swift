//
//  DataHelper.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/27.
//

import Foundation
import UIKit

class DataHelper {
    static func dictionaryToObject<T:Decodable>(objectType:T.Type,dictionary:[String:Any]) -> T? {
        guard let dictionaries = try? JSONSerialization.data(withJSONObject: dictionary) else { return nil }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let objects = try? decoder.decode(T.self, from: dictionaries) else { return nil }
        return objects
    }
}
