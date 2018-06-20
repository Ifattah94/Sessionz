//
//  ChooseImageViewController.swift
//  Sessionz
//
//  Created by C4Q on 5/30/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth

class ChooseImageViewController: UIViewController {

    private lazy var chooseImageView = ChooseImageView(frame: self.view.safeAreaLayoutGuide.layoutFrame)
    lazy var currentUserID = AuthUserService.manager.getCurrentUser()!.uid
    
     private let imagePickerController = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupNavigation()
        imagePickerController.delegate = self
        

    }
    
    private func setupViews() {
        view.addSubview(chooseImageView)
        view.backgroundColor = Stylesheet.Colors.customPurple
        
        chooseImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
        chooseImageView.changeProfileImageButton.addTarget(self, action: #selector(changeProfileButtonPressed), for: .touchUpInside)
    }
    
    @objc private func showHomeVC() {
        let homeVC = HomeViewController()
        let navigationController = UINavigationController(rootViewController: homeVC)
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
    private func setupNavigation() {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(showHomeVC))
        
        self.navigationItem.rightBarButtonItem = doneButton
        
    }
    
    
    @objc private func changeProfileButtonPressed() {
        //checkAVAuthorizationStatus()
        //imagePickerController.sourceType = .photoLibrary
        let actionSheet = UIAlertController(title: "Choose source", message: "Choose Camera or Photo", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (Action) in
            self.imagePickerController.sourceType = .camera
            self.checkAVAuthorizationStatus()
        }))
        actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (Action) in
            self.imagePickerController.sourceType = .photoLibrary
            self.checkAVAuthorizationStatus()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
}

   

extension ChooseImageViewController {
    private func setupImagePickerController() {
        imagePickerController.delegate = self
    }
    
    private func checkAVAuthorizationStatus() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            print("authorized")
            showPickerController()
        case .denied:
            print("denied")
        case .restricted:
            print("restricted")
        case .notDetermined:
            print("nonDetermined")
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                if granted {
                    self.showPickerController()
                }
            })
        }
    }
    
    private func showPickerController() {
        present(imagePickerController, animated: true, completion: nil)
    }
}
    
extension ChooseImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        chooseImageView.profileImageView.image = image
        FirebaseStorageService.service.storeImage(withImageType: .userProfileImg, imageUID: currentUserID, image: image)
        NSCacheHelper.manager.addImage(with: currentUserID, and: image)
        dismiss(animated: true, completion: nil)
    }
    
    
}
