//
//  AlertChildPageViewController.swift
//  AlertOnboarding
//
//  Created by Philippe on 26/09/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//

import UIKit

class AlertChildPageViewController: UIViewController {
    
    var pageIndex: Int!
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var labelMainTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
