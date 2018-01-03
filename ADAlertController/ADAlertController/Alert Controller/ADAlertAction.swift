//
//  ADAlertAction.swift
//
//  Created by Jason Hughes on 10/30/17.
//  Copyright © 2017 1976 LLC. All rights reserved.
//

import UIKit

enum ADAlertActionButtonStyle {
    case base
    case secondary
    case primary
}

class ADAlertAction: NSObject {
    
    private(set) public var title = ""
    private(set) public var style:ADAlertActionButtonStyle = .base
    private(set) public var shouldDismiss = false
    private(set) public var handler:((ADAlertAction)->Void)?
    
    public var tag = 0
    
    convenience init(withTitle title:String, style:ADAlertActionButtonStyle, handler:((ADAlertAction)->Void)?) {
        
        self.init(withTitle: title, style: style,shouldDismiss: true, handler: handler)
        
    }
    
    init(withTitle title:String, style:ADAlertActionButtonStyle, shouldDismiss:Bool, handler:((ADAlertAction)->Void)?) {
        
        self.title = title
        self.style = style
        self.shouldDismiss = shouldDismiss
        self.handler = handler
        
    }
}
