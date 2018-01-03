//
//  ViewController.swift
//  CompassAlertControllerSwift
//
//  Created by Jason Hughes on 10/30/17.
//  Copyright © 2017 adidas America. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showOverlay() {
        let vc = ADAlertController(modalStyle: .overlay, title: "You are pretty much amazing, friend.", message: "Great job on this milestone. We want to help you increase your stamina, which should be no problem since you are already a rock star.", image: nil)
        
        let action = ADAlertAction(withTitle: "test 1", style: .base, handler: nil)
        let action2 = ADAlertAction(withTitle: "test 2", style: .secondary, handler: nil)
        let action3 = ADAlertAction(withTitle: "test 3", style: .primary, handler: nil)
        
        vc.add(action: action2)
        vc.add(action: action)
        vc.add(action: action3)
        
        self.present(vc, animated: true) {
            
        }
        
    }
    
    @IBAction func showFull() {
        let vc = ADAlertController(modalStyle: .full, title: "You are pretty much amazing, friend.", message: "Great job on this milestone. We want to help you increase your stamina, which should be no problem since you are already a rock star.", image: nil)
        
        let action = ADAlertAction(withTitle: "test 1", style: .base, handler: nil)
        let action2 = ADAlertAction(withTitle: "test 2", style: .secondary, handler: nil)
        let action3 = ADAlertAction(withTitle: "test 3", style: .primary, handler: nil)
        
        vc.add(action: action2)
        vc.add(action: action)
        vc.add(action: action3)
        
        self.present(vc, animated: true) {
            
        }
        
    }
    
    @IBAction func showPartial() {
        let vc = ADAlertController(modalStyle: .partial, title:nil, message: "Sign up for our email to receive weekly workout recaps, celebrate your milestones, and know about the latest Discovery releases.", image: UIImage(named:"cat.jpg"))
        
        let action = ADAlertAction(withTitle: "PRIMARY ACTION", style: .primary, handler: nil)
        
        vc.add(action: action)
        vc.add(action: action)
        
        
        self.present(vc, animated: true) {
            
        }
        
    }
    
    @IBAction func showManualOptIn() {
        let vc = ADAlertController(modalStyle: .overlay, title: "DON’T MISS OUT", message: "Sign up for our email to receive weekly workout recaps, celebrate your milestones, and know about the latest Discovery releases.", image: UIImage(named:"cat.jpg"), contentNibName: "ManualOptInContentView")
        
        let action = ADAlertAction(withTitle: "I'M IN", style: .primary, handler: nil)
        let action1 = ADAlertAction(withTitle: "MAYBE LATER", style: .base, handler: nil)
        
        vc.add(action: action)
        vc.add(action: action1)
        
        
        self.present(vc, animated: true) {
            
        }
        
    }
    
    
}

