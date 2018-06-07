//
//  ConsolePickerTableViewController.swift
//  Sessionz
//
//  Created by C4Q on 5/24/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class ConsolePickerTableViewController: UITableViewController {

    
    
    var selectedConsole: String? {
        didSet {
            if let selectedConsole = selectedConsole {
                let index = allConsoles.index(of: selectedConsole)
                selectedConsoleIndex = index
            }
        }
    }
    
    var selectedConsoleIndex: Int?
    var console = Console()
    var allConsoles = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        allConsoles = console.allConsoles()

   
    }
    
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allConsoles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConsoleCell", for: indexPath)
        cell.textLabel?.text = allConsoles[indexPath.row]
        if indexPath.row == selectedConsoleIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let index = selectedConsoleIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        selectedConsole = allConsoles[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "SaveSelectedConsole",
        let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) else {return}
        let index = indexPath.row
        selectedConsole = allConsoles[index]
    }
    
    

}
