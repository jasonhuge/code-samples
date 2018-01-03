//
//  DiscoverySpotlightHeaderCell.swift
//  DiscoverySpotlight
//
//  Created by Jason Hughes on 6/30/17.
//  Copyright © 2017 1976 LLC. All rights reserved.
//

import UIKit

class DiscoverySpotlightHeaderCell: UIView {
    
    @IBOutlet weak var bannerEndCap: UIView!
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var pillarIcon: UIImageView!
    @IBOutlet weak var heroLabel: UILabel!
    @IBOutlet weak var discoveryNameLabel: UILabel!
    @IBOutlet weak var influencerLabel: UILabel!
    @IBOutlet weak var influencerLabelHeight:NSLayoutConstraint!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    var leftConstraint:NSLayoutConstraint?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.bannerEndCap.layer.mask == nil {
            let pathWidth = self.bannerEndCap.bounds.size.width
            let pathHeight = self.bannerEndCap.bounds.size.height
            
            let path = UIBezierPath.init()
            path.move(to: CGPoint.init(x: pathWidth, y: 0))
            path.addLine(to: CGPoint.init(x: pathWidth, y: pathHeight))
            path.addLine(to: CGPoint.init(x: 0, y: pathHeight))
            path.close()
            
            let mask = CAShapeLayer.init()
            mask.frame = CGRect.init(x: 0, y: 0, width: pathWidth, height:pathHeight)
            mask.path = path.cgPath
            
            self.bannerEndCap.layer.mask = mask
            
        }
    }
    
    func update(with model:DiscoverySpotlightCellModel) {
        self.bannerLabel.text = model.bannerText
        
        self.heroLabel.text = model.heroText
        self.heroLabel.lineBreakMode = .byTruncatingTail
        
        self.discoveryNameLabel.text = model.discoveryNameText
        
        if let influencerText = model.influencerText, influencerText != "" {
            self.influencerLabel.isHidden = false;
            self.influencerLabel.text = influencerText
            self.influencerLabelHeight.constant = 18
        } else {
            self.influencerLabel.isHidden = true
            self.influencerLabelHeight.constant = 0
        }
    }

}
