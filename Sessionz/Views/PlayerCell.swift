//
//  PlayerCell.swift
//  Sessionz
//
//  Created by C4Q on 6/12/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class PlayerCell: UITableViewCell {

    lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        imageView.image = #imageLiteral(resourceName: "placeholder")
        return imageView
    }()
    
    lazy var displayNameLabel: UILabel = {
        let label = UILabel()
        label.text = "name"
        label.font = Stylesheet.Fonts.Bold
        return label
    }()
    
    lazy var characterLabel: UILabel = {
        let label = UILabel()
        label.text = "char"
        label.font = Stylesheet.Fonts.Regular
        label.textColor = .black
        return label
    }()
    
    
    lazy var consoleLabel: UILabel = {
        let label = UILabel()
        label.font = Stylesheet.Fonts.Regular
        return label
    }()
    
    lazy var onlineNameLabel: UILabel = {
        let label = UILabel()
        label.text = "online"
        label.font = Stylesheet.Fonts.Regular
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.alignment = .fill
        sv.spacing = 15
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var user: UserProfile?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "PlayerCell")
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCellWithUser(withUser user: UserProfile) {
        self.displayNameLabel.text = nil
        self.consoleLabel.text = nil
        self.characterLabel.text = nil
        self.onlineNameLabel.text = nil
        
        
       
        
        
        UserProfileService.manager.getUser(fromUserUID: user.userID) { (thisUser) in
            
            self.displayNameLabel.text = thisUser.displayName
            self.characterLabel.text = thisUser.team
            self.onlineNameLabel.text = thisUser.onlineProfile
            self.consoleLabel.text = thisUser.console
            self.userImageView.image = nil
            
            if let cachedUserImage = NSCacheHelper.manager.getImage(with: thisUser.userID) {
                self.userImageView.image = cachedUserImage
                self.userImageView.layoutIfNeeded()
            } else {
                guard let imageURL = thisUser.image else {
                    self.userImageView.image = #imageLiteral(resourceName: "placeholder")
                    //self.layoutIfNeeded()
                    return
                }
                ImageHelper.manager.getImage(from: imageURL, completionHandler: { (profileImage) in
                    self.userImageView.image = profileImage
                    self.layoutIfNeeded()
                    NSCacheHelper.manager.addImage(with: thisUser.userID, and: profileImage)
                }, errorHandler: { (error) in
                    print("Couldn't get profile Image \(error)")
                    self.userImageView.image = #imageLiteral(resourceName: "placeholder")
                    //self.layoutIfNeeded()
                })
            }
            
        }
        
        
    }
    public func configureCell(withUser user: UserProfile) {
        self.user = user
        configureCellWithUser(withUser: user)
    }
    
    private func setupViews() {
        setupDisplayNameLabel()
        setupUserImageView()
        setupConsoleLabel()
        setupCharacterLabel()
        setupOnlineProfileLabel()
        //setupStackView()
    }
    
    private func setupDisplayNameLabel() {
        self.addSubview(displayNameLabel)
        displayNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(8)
            make.top.equalTo(self.snp.top).offset(8)
        }
    }
    
    private func setupUserImageView() {
        self.addSubview(userImageView)
        userImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.snp.leading).offset(8)
                make.top.equalTo(displayNameLabel.snp.bottom).offset(4)
            make.height.equalTo(70)
            make.width.equalTo(userImageView.snp.height)
            make.bottom.equalTo(self.snp.bottom).offset(-6)
            
        }
    }
    
    private func setupConsoleLabel() {
        self.addSubview(consoleLabel)
        consoleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(displayNameLabel.snp.top)
            make.trailing.equalTo(self.snp.trailing).offset(-50)
            
        }
    }
    
    private func setupCharacterLabel() {
        self.addSubview(characterLabel)
        characterLabel.snp.makeConstraints { (make) in
            make.top.equalTo(consoleLabel.snp.bottom).offset(8)
            make.trailing.equalTo(consoleLabel.snp.trailing)
        }
    }
    
    private func setupOnlineProfileLabel() {
        self.addSubview(onlineNameLabel)
        onlineNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(characterLabel.snp.bottom).offset(8)
            make.trailing.equalTo(consoleLabel.snp.trailing)
        }
    }
    
    private func setupStackView() {
        self.addSubview(stackView)
        stackView.addArrangedSubview(consoleLabel)
        stackView.addArrangedSubview(characterLabel)
        stackView.addArrangedSubview(onlineNameLabel)
        stackView.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.snp.trailing).offset(-65)
            make.top.equalTo(self.snp.top).offset(16)
            make.bottom.equalTo(userImageView.snp.bottom).offset(-40)
            make.width.equalTo(userImageView.snp.width).multipliedBy(1.6)
        }
    }
    


 

}
