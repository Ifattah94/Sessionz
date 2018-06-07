//
//  AccountInfoNavController.swift
//  Sessionz
//
//  Created by C4Q on 5/24/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class AccountInfoNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    public func storyboardInstance() -> AccountInfoNavController {
        let storyboard = UIStoryboard(name: "UserCreation", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "AccountInfoNavController") as! AccountInfoNavController
        return nav
    }


}
