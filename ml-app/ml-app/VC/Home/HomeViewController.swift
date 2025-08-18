//
//  HomeViewController.swift
//  ml-app
//
//  Created by Kelvin on 17/8/2025.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        let buttonsContainer = UIView()
        view.addSubview(buttonsContainer)
        buttonsContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview() // Center vertically
            make.leading.trailing.equalToSuperview() // Full width
        }
        
        let button1 = UIButton()
        button1.backgroundColor = .orange
        button1.setTitle("Face Detection", for: .normal)
        button1.layer.cornerRadius = 8
        button1.addAction {
            ViewController.me.nav.pushViewController(FaceDetectionViewController(), animated: true)
        }
        
        let button2 = UIButton()
        button2.backgroundColor = .brown
        button2.setTitle("Image Classification", for: .normal)
        button2.layer.cornerRadius = 8
        button2.addAction {
            ViewController.me.nav.pushViewController(SentimentAnalysisChatController(), animated: true)
        }
        
        buttonsContainer.addSubview(button1)
        buttonsContainer.addSubview(button2)

        button1.snp.remakeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        button2.snp.remakeConstraints { make in
            make.top.equalTo(button1.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(50)
            make.bottom.equalToSuperview() // Important for container sizing
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
