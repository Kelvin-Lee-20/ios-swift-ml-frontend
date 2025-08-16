//
//  ViewController.swift
//  ml-app
//
//  Created by Kelvin on 30/7/2025.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    let nav = UINavigationController()
    static var me:ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ViewController.me = self
        self.initView()
    }

    private func initView() {
        
        nav.isNavigationBarHidden = true
        self.addChild(nav)
        self.view.addSubview(nav.view)
        
        nav.viewControllers = [LaunchViewController()]
        
    }

}

