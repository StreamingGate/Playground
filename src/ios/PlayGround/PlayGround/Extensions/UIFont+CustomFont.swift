//
//  UIFont+CustomFont.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2021/12/28.
//

import Foundation
import UIKit

extension UIFont {
    static var Title : UIFont {
        return UIFont(name: "Apple SD Gothic Neo Bold", size: 21) ?? UIFont.boldSystemFont(ofSize: 21)
    }
    
    static var SubTitle : UIFont {
        return UIFont(name: "Apple SD Gothic Neo Bold", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
    }
    
    static var Tab : UIFont {
        return UIFont(name: "Apple SD Gothic Neo Bold", size: 16) ?? UIFont.boldSystemFont(ofSize: 16)
    }
    
    static var highlightCaption : UIFont {
        return UIFont(name: "Apple SD Gothic Neo Bold", size: 12) ?? UIFont.boldSystemFont(ofSize: 12)
    }
    
    static var LightTitle : UIFont {
        return UIFont(name: "Apple SD Gothic Neo", size: 18) ?? UIFont.systemFont(ofSize: 18)
    }
    
    static var Component : UIFont {
        return UIFont(name: "Apple SD Gothic Neo", size: 16) ?? UIFont.systemFont(ofSize: 16)
    }
    
    static var Content : UIFont {
        return UIFont(name: "Apple SD Gothic Neo", size: 14) ?? UIFont.systemFont(ofSize: 14)
    }
    
    static var caption : UIFont {
        return UIFont(name: "Apple SD Gothic Neo", size: 12) ?? UIFont.systemFont(ofSize: 12)
    }
    
    static var bottomTab : UIFont {
        return UIFont(name: "Apple SD Gothic Neo", size: 9) ?? UIFont.systemFont(ofSize: 9)
    }
}
