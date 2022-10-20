//
//  RecordButton.swift
//  TikTok
//
//  Created by Kaan Yeyrek on 10/10/22.
//

import UIKit

class RecordButton: UIButton {

    enum State {
        case recording
        case notRecording
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = nil
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.5
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = height/2
    }

    
    public func toggle(with state: State) {
        switch state {
        case .recording:
            backgroundColor = .systemRed
           
        case .notRecording:
            backgroundColor = nil
            
            
            
        }
    }
    
    

}
