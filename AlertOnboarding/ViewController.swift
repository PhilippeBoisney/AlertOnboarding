//
//  ViewController.swift
//  AlertOnboarding
//
//  Created by Philippe Boisney on 23/03/2016.
//  Copyright © 2016 Philippe Boisney. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var alertView: AlertOnboarding!
    
    var arrayOfImage = ["image1", "image2", "image3"]
    var arrayOfTitle = ["CREATE ACCOUNT", "CHOOSE THE PLANET", "DEPARTURE"]
    var arrayOfDescription = ["In your profile, you can view the statistics of its operations and the recommandations of friends",
        "Purchase tickets on hot tours to your favorite planet and fly to the most comfortable intergalactic spaceships of best companies",
        "In the process of flight you will be in cryogenic sleep and supply the body with all the necessary things for life"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alertView = AlertOnboarding(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription)
        
    }
    @IBAction func onTouchLol(sender: AnyObject) {
        self.alertView.hide()
    }

    @IBAction func onTouch(sender: AnyObject) {
       
        /*
        
        IF YOU WANT TO CUSTOM ALERTVIEW
        self.alertView.colorForAlertViewBackground = UIColor(red: 173/255, green: 206/255, blue: 183/255, alpha: 1.0)
        self.alertView.colorButtonText = UIColor.whiteColor()
        self.alertView.colorButtonBottomBackground = UIColor(red: 65/255, green: 165/255, blue: 115/255, alpha: 1.0)
        
        self.alertView.colorTitleLabel = UIColor.whiteColor()
        self.alertView.colorDescriptionLabel = UIColor.whiteColor()
        
        self.alertView.colorPageIndicator = UIColor.whiteColor()
        self.alertView.colorCurrentPageIndicator = UIColor(red: 65/255, green: 165/255, blue: 115/255, alpha: 1.0)  
        */
        
        self.alertView.show()
    }

}

