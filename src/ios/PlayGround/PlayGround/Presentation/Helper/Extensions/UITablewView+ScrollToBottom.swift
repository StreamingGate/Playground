//
//  UITablewView+ScrollToBottom.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/27.
//

import UIKit

extension UITableView {
    func scrollToBottom() {
        let rows = self.numberOfRows(inSection: 0)

        if rows > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: rows - 1, section: 0)
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}
