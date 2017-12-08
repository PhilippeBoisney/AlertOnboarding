//
//  AlertChildPageViewController.swift
//  AlertOnboarding
//
//  Created by Philippe on 26/09/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//

import UIKit

@objc public class AlertChildPageViewController: UIViewController {
    
    internal(set) var pageIndex: Int!
    
    @objc @IBOutlet public private(set) weak var image: UIImageView!
    @objc @IBOutlet public private(set) weak var labelMainTitle: UILabel!
    @objc @IBOutlet public private(set) weak var labelDescription: UILabel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
