//
//  DiscoverySpotlightStackViewCell.swift
//  DiscoverySpotlight
//
//  Created by Jason Hughes on 7/3/17.
//  Copyright © 2017 1976. All rights reserved.
//

import UIKit

class DiscoverySpotlightStackViewCell: UIView {
    
    let colorView = UIView.init(frame: .zero)
    
    var colorViewWidthConstraint:NSLayoutConstraint?
    var colorViewLeftConstraint:NSLayoutConstraint?
    var colorViewRightConstraint:NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.colorView.translatesAutoresizingMaskIntoConstraints = false
        self.colorView.backgroundColor = .magenta
        
        self.addSubview(self.colorView)
        
        self.colorViewLeftConstraint = self.colorView.leftAnchor.constraint(equalTo: self.leftAnchor)
        self.colorViewRightConstraint = self.colorView.rightAnchor.constraint(equalTo: self.rightAnchor)
        
        self.colorView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.colorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true;
        self.colorViewWidthConstraint = self.colorView.widthAnchor.constraint(equalToConstant: 0)
        self.colorViewWidthConstraint?.isActive = true
        
        self.enableLeftConstraint()
        
        self.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func enableLeftConstraint() {
        self.colorViewRightConstraint?.isActive = false
        self.colorViewLeftConstraint?.isActive = true
    }
    
    func enableRightConstraint() {
        self.colorViewLeftConstraint?.isActive = false
        self.colorViewRightConstraint?.isActive = true
    }
    
    func updateColorViewWidthConstraint(with widthPercentage:CGFloat) {
        self.layoutIfNeeded()
        
        let width = self.bounds.size.width
        
        self.colorViewWidthConstraint?.constant = width * widthPercentage
    }

}
