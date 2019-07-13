 //
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by e10a on 7/13/19.
//  Copyright © 2019 e10a. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {

    @IBOutlet weak var textfield: UITextField!
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never 
    }

    override func viewWillAppear(_ animated: Bool) {
        textfield.becomeFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

 extension AddItemTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textfield.resignFirstResponder()
        return false
    }
 }
