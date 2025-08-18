//
//  LaunchViewController.swift
//  ml-app
//
//  Created by Kelvin Lee on 16/8/2025.
//


import UIKit
import SnapKit

class LaunchViewController: UIViewController {
    
    var isAnimationCompleted = false
    
    private let l1: UILabel = {
        let label = UILabel()
        label.text = "Kelvin Lee"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private let l2: UILabel = {
        let label = UILabel()
        label.text = "ML"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.alpha = 0
        return label
    }()
    
    private let l3: UILabel = {
        let label = UILabel()
        label.text = "lab"
        label.textColor = .white
        label.backgroundColor = .orange
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.alpha = 0
        return label
    }()
    
    private var l1CenterYConstraint: Constraint?
    private var l2CenterXConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(l1)
        view.addSubview(l2)
        view.addSubview(l3)
        
        l1.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            self.l1CenterYConstraint = make.centerY.equalToSuperview().constraint
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        l2.snp.makeConstraints { make in
            self.l2CenterXConstraint = make.centerX.equalToSuperview().constraint
            make.top.equalTo(l1.snp.bottom).offset(20)
        }
        
        l3.snp.makeConstraints { make in
            make.centerY.equalTo(l2.snp.centerY)
            make.leading.equalTo(l2.snp.trailing).offset(10)
            make.width.equalTo(60)
            make.height.equalTo(40)
        }
        
        UIView.animate(withDuration: 3.0, delay: 1, options: .curveEaseInOut, animations: {
            
             self.l1.alpha = 1
            
         }) { _ in
             
             self.l1CenterYConstraint?.update(offset: -60)
             
             UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
                 
                 self.view.layoutIfNeeded()
                 
             }) { _ in
                 
                 UIView.animate(withDuration: 3.0, delay: 0, options: .curveEaseInOut, animations: {
                     
                     self.l2.alpha = 1
                     
                 }) { _ in
                     
                     self.l2CenterXConstraint?.update(offset: -23)
                     
                      UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseInOut, animations: {
     
                          self.view.layoutIfNeeded()
     
                          self.l3.alpha = 1
                          
                      }, completion: {
                          
                          _ in
                          
                          DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                              
                              // ViewController.me.nav.viewControllers = [SentimentAnalysisChatController()]
                              
                              ViewController.me.nav.pushViewController(HomeViewController(), animated: true)
                              
                              self.isAnimationCompleted = true
                              
                          }
                          
                      })
                     
                 }
                 
             }

         }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true

    }
    
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        if (isAnimationCompleted) {
            ViewController.me.nav.pushViewController(HomeViewController(), animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
