//
//  ProfileViewController.swift
//  Sessionz
//
//  Created by C4Q on 6/20/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseAuth


class ProfileViewController: UIViewController {

    private lazy var profileView = ProfileView(frame: self.view.safeAreaLayoutGuide.layoutFrame)
    
     lazy var currentUserID = AuthUserService.manager.getCurrentUser()!.uid
    
      private let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        loadData()
        setupNavigation()
        imagePickerController.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let cachedUserImage = NSCacheHelper.manager.getImage(with: currentUserID) {
            profileView.profileImageView.image = cachedUserImage
        } else {
            UserProfileService.manager.getUser(fromUserUID: currentUserID) { (userProfile) in
                self.profileView.displayName.text = userProfile.displayName
                
                guard let imageURL = userProfile.image else {return}
                ImageHelper.manager.getImage(from: imageURL, completionHandler: { (profileImage) in
                    self.profileView.profileImageView.image = profileImage
                    FirebaseStorageService.service.storeImage(withImageType: .userProfileImg, imageUID: self.currentUserID, image: profileImage)
                    //NSCacheHelper.manager.addImage(with: self.currentUserID, and: profileImage)
                }, errorHandler: { (error) in
                    print("Couldn't get profile Image \(error)")
                })
            }
        }
    }
    
    private func setupViews() {
        view.addSubview(profileView)
        view.backgroundColor = Stylesheet.Colors.customPurple
        
        profileView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view.safeAreaLayoutGuide.snp.edges)
        }
    }
    
    
    private func loadData() {
        UserProfileService.manager.getName(from: currentUserID) { (displayName) in
            self.profileView.displayName.text = displayName
        }
    }
    
    
    private func setupNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(logoutPressed))
         profileView.changeProfileImageButton.addTarget(self, action: #selector(changeProfileButtonPressed), for: .touchUpInside)
    }
    
    @objc func logoutPressed() {
        AuthUserService.manager.delegate = self
        AuthUserService.manager.logout()
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

extension ProfileViewController {
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        profileView.profileImageView.image = image
        FirebaseStorageService.service.storeImage(withImageType: .userProfileImg, imageUID: currentUserID, image: image)
        NSCacheHelper.manager.addImage(with: currentUserID, and: image)
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController: AuthUserDelegate {
    func didAddInfoToUser(_ userService: AuthUserService, user: User) {
        
    }
    
    func didFailToAddInfoToUser(_ userService: AuthUserService, error: Error) {
        
    }
    
    func didFailCreatingUser(_ userService: AuthUserService, error: Error) {
    }
    
    func didCreateUser(_ userService: AuthUserService, user: User) {
    }
    
    func didFailSigningOut(_ userService: AuthUserService, error: Error) {
        //todo
    }
    
    func didSignOut(_ userService: AuthUserService) {
        print("user signed out!!")
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func didFailToSignIn(_ userService: AuthUserService, error: Error) {
    }
    
    func didSignIn(_ userService: AuthUserService, user: User) {
    }
    
    func didFailToSendPasswordReset(_ userService: AuthUserService, error: Error) {
    }
    
    func didSendPasswordReset(_userService: AuthUserService) {
    }
}



