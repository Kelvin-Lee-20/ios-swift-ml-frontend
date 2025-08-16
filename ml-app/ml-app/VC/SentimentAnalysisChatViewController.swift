//
//  SentimentAnalysisChatController.swift
//  ml-app
//
//  Created by Kelvin on 30/7/2025.
//

import UIKit
import SnapKit
import Alamofire

class SentimentAnalysisChatController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var messages: [MessageModel] = []
    let tableView = UITableView()
    
    let toolbarView = UIView()
    let textField = UITextField()
    let sendButton = UIButton(type: .system)
    let addButton = UIButton(type: .system)
    var containerBottomConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .systemBlue
        addButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        textField.placeholder = "Type your message..."
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.keyboardType = .asciiCapable // Only shows keyboards that support ASCII characters
        textField.autocorrectionType = .no
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.systemBlue, for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessageToServer), for: .touchUpInside)
        
        toolbarView.backgroundColor = .systemGray6
        view.addSubview(toolbarView)
        toolbarView.addSubview(addButton)
        toolbarView.addSubview(textField)
        toolbarView.addSubview(sendButton)
        
        toolbarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            self.containerBottomConstraint = make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).constraint
            make.height.equalTo(60)
        }
        
        addButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
            make.trailing.equalTo(textField.snp.leading).offset(-8)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(addButton.snp.trailing).offset(8)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.trailing.equalTo(sendButton.snp.leading).offset(-8)
        }
        
        sendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalTo(textField)
            make.width.equalTo(60)
        }
        
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(MessageBubbleCell.self, forCellReuseIdentifier: MessageBubbleCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(toolbarView.snp.top)
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
    }
    
    @objc private func keyboardWillShow(notification: Notification) {

        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        
        containerBottomConstraint?.update(offset: -keyboardHeight+view.safeAreaInsets.bottom)
                
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: animationCurve << 16),
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
        
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval,
              let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {
            return
        }
        
        // Reset the bottom constraint to its original value (typically 0 or whatever you need)
        containerBottomConstraint?.update(offset: 0) // or your original offset if different
        
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            options: UIView.AnimationOptions(rawValue: animationCurve << 16),
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    @objc private func openImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        
        addBubble(msg: MessageModel(text: "", image: image, isFromServer: false))
        
        APIHelper.imageClassification(withImage: image, completion: {
            
            msg in
            
            self.addBubble(msg: msg)
            
        }, fail: {})
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
 
    private func addBubble(msg:MessageModel) {
        messages.append(msg)
        let indexPath = IndexPath(row: messages.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc private func sendMessageToServer() {
        guard let text = textField.text, !text.isEmpty else { return }
        
        addBubble(msg: MessageModel(text: text, isFromServer: false))
        
        textField.text = ""
        
        APIHelper.sentimentAnalysis(withText: text, completion: {
            
            msg in
            
            self.addBubble(msg: msg)
            
        }, fail: {})
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension SentimentAnalysisChatController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MessageBubbleCell.identifier, for: indexPath) as! MessageBubbleCell
        cell.updateCell(with: messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
