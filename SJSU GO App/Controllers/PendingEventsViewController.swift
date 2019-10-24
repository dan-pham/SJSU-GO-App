//
//  PendingEventsViewController.swift
//  SJSU GO App
//
//  Created by Dan Pham on 8/23/19.
//  Copyright © 2019 Dan Pham. All rights reserved.
//

import UIKit
import Firebase

class PendingEventsViewController: UIViewController {
    
    @IBOutlet weak var pendingEventsTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // TODO: Need to fix translucency problems
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func doneWithPendingEvents(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
