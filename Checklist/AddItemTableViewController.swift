 //
//  AddItemTableViewController.swift
//  Checklist
//
//  Created by e10a on 7/13/19.
//  Copyright © 2019 e10a. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {

    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func done(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func textField(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never 
    }

}
