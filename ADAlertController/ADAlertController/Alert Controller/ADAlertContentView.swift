//
//  ADAlertContentView.swift
//  ADAlertControllerSwift
//
//  Created by Jason Hughes on 11/9/17.
//  Copyright © 2017 1976 LLC. All rights reserved.
//

import UIKit

class ADAlertContentView: UIView {
    
    
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var messageTextView: UITextView?
    @IBOutlet weak var imageView: UIImageView?
    
    public func update( withTitle title: String?, message: String?, image: UIImage?) {
        if let titleLabel = self.titleLabel {
            titleLabel.text = title
        }
        
        if let messageTextView = self.messageTextView {
            messageTextView.text = message
        }
        
        if let imageView = self.imageView {
            imageView.image = image
        }
    }
}
