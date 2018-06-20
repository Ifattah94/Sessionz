//
//  CharactersTableViewController.swift
//  Sessionz
//
//  Created by C4Q on 5/26/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class CharactersTableViewController: UITableViewController {

    var allCharacters = [String]()
    var character = DBZChar()
    
    
    var firstSelectedCharIndex: Int?
    var firstSelectedChar: String? {
        didSet {
            if let firstSelectedChar = firstSelectedChar {
                let index = allCharacters.index(of: firstSelectedChar)
                firstSelectedCharIndex = index
            }
        }
    }
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allCharacters = character.allTheChars
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCharacters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
        cell.textLabel?.text = allCharacters[indexPath.row]
        
        if indexPath.row == firstSelectedCharIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
     
      return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let index = firstSelectedCharIndex
            {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
           
            cell?.accessoryType = .checkmark
         
        }
        firstSelectedChar = allCharacters[indexPath.row]
       
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        self.performSegue(withIdentifier: "SaveSelectedChars", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveSelectedChars",
        let cell = sender as? UITableViewCell,
            
            let indexPath = tableView.indexPath(for: cell) else {return}
        let index = indexPath.row
        firstSelectedChar = allCharacters[index]
        
    }
    

    
    
    

}
