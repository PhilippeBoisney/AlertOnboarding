//
//  ViewController.swift
//  AlertOnboarding
//
//  Created by Philippe on 26/09/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AlertOnboardingDelegate {
    
    var alertView: AlertOnboarding!
    
    var arrayOfImage = ["onboarding", "graph", "train","graph"]
    var arrayOfTitle = ["CREATE ACCOUNT", "CHOOSE THE PLANET ACROSS TWO LINES OR EVEN MORE.  IF POSSIBLE.", "DEPARTURE","SWIFTY"]
    var arrayOfDescription = ["In your profile, you can view the statistics of its operations and the recommandations of friends!",
                              "Purchase tickets on hot tours to your favorite planet and fly to the most comfortable intergalactic spaceships of best companies. Purchase tickets on hot tours to your favorite planet and fly to the most comfortable intergalactic spaceships of best companies!",
                              "In the process of flight you will be in cryogenic sleep and supply the body with all the necessary things for life!","This is very Swifty"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertView = AlertOnboarding(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription, arrayOfContainers: [self.contentExample(), self.contentExample(), self.contentExample(),self.contentExample()])
        alertView.delegate = self   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.onTouch(self)
    }
    
    func contentExample() -> UIViewController {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "exampleContent")
        return vc
    }
    
    @IBAction func onTouch(_ sender: AnyObject) {
        // IF YOU WANT TO CUSTOMISE ALERTVIEW
        self.alertView.colorForAlertViewBackground = UIColor(hue:0.55, saturation:0.62, brightness:0.97, alpha:1.00)
        self.alertView.colorButtonText = .white
        self.alertView.colorButtonBottomBackground = UIColor(hue:0.59, saturation:0.89, brightness:0.98, alpha:1.00)

        self.alertView.colorTitleLabel = .white
        self.alertView.colorDescriptionLabel = .white

        self.alertView.colorPageIndicator = .white
        self.alertView.colorCurrentPageIndicator = .lightGray

        self.alertView.percentageRatioHeight = 1.0
        self.alertView.percentageRatioWidth = 1.0
        self.alertView.show(animated:false)
    }
    
    //--------------------------------------------------------
    // MARK: DELEGATE METHODS --------------------------------
    //--------------------------------------------------------
    
    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int) {
        print("Onboarding skipped the \(currentStep) step and the max step he saw was the number \(maxStep)")
    }
    
    func alertOnboardingCompleted() {
        print("Onboarding completed!")
    }
    
    func alertOnboardingNext(_ nextStep: Int) {
        
    }
    
}
