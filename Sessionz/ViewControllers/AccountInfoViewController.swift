//
//  AccountInfoViewController.swift
//  Sessionz
//
//  Created by C4Q on 5/23/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import FirebaseAuth


class AccountInfoViewController: UITableViewController {

    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var onlineTagTextField: UITextField!
    
    @IBOutlet weak var chosesConsoleLabel: UILabel!
    
    @IBOutlet weak var char1Label: UILabel!
    
  private var authUserService = UserProfileService.manager
    var activeTextField: UITextField = UITextField()
    var console: String = "" {
        didSet {
            chosesConsoleLabel.text = console
        }
    }
    var firstChosenChar: String = "" {
        didSet {
            char1Label.text = firstChosenChar
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onlineTagTextField.delegate = self 

        
    }
    
    
    public func storyboardInstance() -> UINavigationController {
        let storyboard = UIStoryboard(name: "UserCreation", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AccountInfoViewController") as! AccountInfoViewController
        let navController = UINavigationController(rootViewController: vc)
        
        return navController
    }
    
    func configureUserInfo() {
        let currentUser = AuthUserService.manager.getCurrentUser()!
        
        guard let onlineTag = self.onlineTagTextField.text else {self.alertForErrors(with: "Please enter an online tag"); return}
        guard console != "" else {self.alertForErrors(with: "Choose preffered console"); return}
        guard firstChosenChar != "" else {self.alertForErrors(with: "Please choose a character"); return}
        self.authUserService.delegate = self
        
        UserProfileService.manager.addInfoToUser(using: currentUser.uid, console: console, character: firstChosenChar, onlieTag: onlineTag)
        
    }
    public func alertForErrors(with message: String) {
        let ac = UIAlertController(title: "Error Saving Info", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        ac.addAction(okAction)
        self.present(ac, animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIBarButtonItem) {
        
        configureUserInfo()
        
    }
    
   

    // MARK: - Table view data source

   
}

extension AccountInfoViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            onlineTagTextField.becomeFirstResponder()
            
        }
    }
    
    
}

extension AccountInfoViewController {
    @IBAction func unwindWithSelectedConsole(segue: UIStoryboardSegue) {
        if let consolePickerController = segue.source as? ConsolePickerTableViewController,
            let selectedConsole = consolePickerController.selectedConsole {
            console = selectedConsole
        }
    }
    
}

extension AccountInfoViewController {
    @IBAction func unwindWithSelectedChars(segue: UIStoryboardSegue) {
        if let characterVC = segue.source as? CharactersTableViewController,
            let firstChar = characterVC.firstSelectedChar {
            firstChosenChar = firstChar
           
        }
    }
}
extension AccountInfoViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension AccountInfoViewController: UserProfileDelegate {
    func didAddInfoToUser(_ userService: UserProfileService) {
        let chooseImageVC = ChooseImageViewController()
        self.navigationController?.pushViewController(chooseImageVC, animated: true)
    }
    
    func didFailToAddInfoToUser(_ userService: UserProfileService, error: Error) {
        
    }
    

    
    
}

    
    

