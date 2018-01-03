//
//  ViewController.swift
//  DiscoverySpotlight
//
//  Created by Jason Hughes on 6/30/17.
//  Copyright © 2017 1976. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    
    var numCells = 1;
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.collectionView.register(UINib.init(nibName: "DiscoverySpotlightHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "collectionViewHeader")
        self.collectionView.register(UINib.init(nibName: "DiscoveryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "discoveryCell")
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        
        for item:UIButton in [self.oneButton, self.twoButton, self.threeButton] as [UIButton] {
            item.addTarget(self, action: #selector(onItemButtonTapped(sender:)), for: .touchUpInside);
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func onItemButtonTapped(sender:UIButton) {
        var tempNumCells = 0
        
        switch sender {
        case self.oneButton:
            tempNumCells = 1
        case self.twoButton:
            tempNumCells = 2
        case self.threeButton:
            tempNumCells = 4
        default:
            tempNumCells = 0
        }
        
        if tempNumCells != self.numCells {
            self.numCells = tempNumCells
            self.collectionView.reloadData()
        }
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.bounds.size.width, height: 50)
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: self.collectionView.bounds.size.width, height: 368)
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var view:UICollectionReusableView!
        
        if kind == UICollectionElementKindSectionHeader {
            view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "collectionViewHeader", for: indexPath)
            
            
            if let view = view as? DiscoverySpotlightHeaderView {
                
                var headerModelArray:Array<DiscoverySpotlightCellModel> = []
                
                let cellDataArray = [
                    ["", "spotlight banner 1", "This is one line of hero text", "Hi I'm a subtitle", "", "", "And I'm a sub subtitle"],
                    ["", "spotlight banner 2", "This is two line of hero text.  That should fill up two lines", "Darth Vader", "", "", "Son / Daughter"],
                    ["", "spotlight banner 3", "This is two line of hero text.  That should fill up two lines", "Yoda", "", "", "Yogi Radwanksa / Don't forget your force!"],
                    ["", "spotlight banner 4", "This is three line of hero text.  That should fill up three lines.  Pretty well for now. Actually it's to much text. Should we truncate?", "Star Wars", "", "", ""]
                ] as [Array<String>]
                
                for i in 0..<self.numCells {
                    let cellData = cellDataArray[i]
                    
                    let spotlightCellModel = DiscoverySpotlightCellModel(backgroundImageURL: cellData[0], bannerText: cellData[1], heroText: cellData[2], discoveryNameText: cellData[3], pillarIconURL: cellData[4], dxID: cellData[5], influencerText: cellData[6])
                    
                    headerModelArray.append(spotlightCellModel)
                }
                
                view.setup(with: headerModelArray)
                
            }
            
        }
        
        return view;
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "discoveryCell", for: indexPath)
        return cell
    }
}

