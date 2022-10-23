//
//  SwitchCellViewModel.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 10/22/22.
//

import Foundation

struct SwitchCellViewModel {
    let title: String
    var isOn: Bool
    
    mutating func setOn(_ on: Bool) {
        self.isOn = on
    }
}
