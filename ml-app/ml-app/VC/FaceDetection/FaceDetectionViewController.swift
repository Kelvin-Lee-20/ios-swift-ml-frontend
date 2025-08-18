//
//  FaceDetectionViewController.swift
//  ml-app
//
//  Created by Kelvin on 17/8/2025.
//

import UIKit
import SnapKit
import PhotosUI
import Vision

class FaceDetectionViewController: UIViewController {
    
    private let addButton = UIButton()
    private var imageView = UIImageView()
    private let infoLabel = UILabel()
    private var isAddButtonPressedOnce = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        addButton.tintColor = .systemBlue
        addButton.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        addButton.layer.cornerRadius = 8
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(50)
        }

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in }
        
        infoLabel.text = "" // Set text
        infoLabel.font = UIFont.systemFont(ofSize: 16)
        infoLabel.textColor = .darkGray
        infoLabel.numberOfLines = 0 // Allows multiple lines
        infoLabel.textAlignment = .center
        view.addSubview(infoLabel)
    
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            // No fixed height - it will size to content
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            
            self.scaleView()
            
        }

    }
    
    @objc func scaleView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.addButton.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: [], animations: {
                self.addButton.transform = .identity
            }, completion: nil)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            
            if (self.isAddButtonPressedOnce == false) { self.scaleView() }
            
        }
    }

    @objc private func addButtonTapped() {
        isAddButtonPressedOnce = true
        showImagePickerOptions()
    }
    
    private func showImagePickerOptions() {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
          self.openCamera()
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
          self.openPhotoLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
  
    private func openCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("Camera not available")
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    private func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension FaceDetectionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            
            imageView.subviews.forEach { $0.removeFromSuperview() }
            imageView.image = image
            let ratio = image.size.height / image.size.width
            
            imageView.snp.remakeConstraints { make in
                make.top.equalTo(addButton.snp.bottom).offset(20)
                make.centerX.equalToSuperview()
                make.width.equalToSuperview().multipliedBy(0.8)
                make.height.equalTo(imageView.snp.width).multipliedBy(ratio)
            }
            imageView.superview!.layoutIfNeeded()

            let request = VNDetectFaceRectanglesRequest { (req, err) in
                if let err = err {
                    print("Failed to detect faces : ", err)
                    return
                }
                
                let faceCount = req.results?.count ?? 0
                print("Number of faces detected: \(faceCount)")
                
                DispatchQueue.main.async {
                    self.infoLabel.text = "Number of faces detected = \(faceCount)"
                }
                
                req.results?.forEach({ (res) in
                    
                    DispatchQueue.main.async {
                        
                        guard let faceObservation = res as? VNFaceObservation else { return }
                        
                        let width = self.imageView.frame.width * faceObservation.boundingBox.width
                        let height = self.imageView.frame.height * faceObservation.boundingBox.height
                        let x = self.imageView.frame.width * faceObservation.boundingBox.origin.x
                        let y = self.imageView.frame.height * (1 - faceObservation.boundingBox.origin.y) - height
                        
                        let facefound = UIView()
                        // facefound.backgroundColor = .red
                        // facefound.alpha = 0.1
                        facefound.layer.borderColor = UIColor.red.cgColor
                        facefound.layer.borderWidth = 2
                        facefound.frame = CGRect(x: x, y: y, width: width, height: height)
                        self.imageView.addSubview(facefound)
                        
                    }
                    
                })
            }
            
            guard let cgImage = image.fixedOrientation().cgImage else { return }
            
            DispatchQueue.global(qos: .background).async {
                let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                do {
                    try handler.perform([request])
                } catch let reqErr {
                    print("Failed to perform request : ", reqErr)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

