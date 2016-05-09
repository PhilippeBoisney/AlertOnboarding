//
//  AlertOnboarding.swift
//  AlertOnboarding
//
//  Created by Philippe Boisney on 23/03/2016.
//  Copyright © 2016 Philippe Boisney. All rights reserved.
//


import UIKit

public protocol AlertOnboardingDelegate {
    func alertOnboardingSkipped(currentStep: Int, maxStep: Int)
    func alertOnboardingCompleted()
    func alertOnboardingNext(nextStep: Int)
}

public class AlertOnboarding: UIView, AlertPageViewDelegate {
    
    //FOR DATA  ------------------------
    private var arrayOfImage = [String]()
    private var arrayOfTitle = [String]()
    private var arrayOfDescription = [String]()
    
    //FOR DESIGN    ------------------------
    public var buttonBottom: UIButton!
    private var container: AlertPageViewController!
    public var background: UIView!
    
    
    //PUBLIC VARS   ------------------------
    public var colorForAlertViewBackground: UIColor = UIColor.whiteColor()
    
    public var colorButtonBottomBackground: UIColor = UIColor(red: 226/255, green: 237/255, blue: 248/255, alpha: 1.0)
    public var colorButtonText: UIColor = UIColor(red: 118/255, green: 125/255, blue: 152/255, alpha: 1.0)
    
    public var colorTitleLabel: UIColor = UIColor(red: 171/255, green: 177/255, blue: 196/255, alpha: 1.0)
    public var colorDescriptionLabel: UIColor = UIColor(red: 171/255, green: 177/255, blue: 196/255, alpha: 1.0)
    
    public var colorPageIndicator = UIColor(red: 171/255, green: 177/255, blue: 196/255, alpha: 1.0)
    public var colorCurrentPageIndicator = UIColor(red: 118/255, green: 125/255, blue: 152/255, alpha: 1.0)
    
    public var heightForAlertView: CGFloat!
    public var widthForAlertView: CGFloat!
    
    public var percentageRatioHeight: CGFloat = 0.8
    public var percentageRatioWidth: CGFloat = 0.8
    
    public var titleSkipButton = "SKIP"
    public var titleGotItButton = "GOT IT !"
    
    public var delegate: AlertOnboardingDelegate?
    
    
    public init (arrayOfImage: [String], arrayOfTitle: [String], arrayOfDescription: [String]) {
        super.init(frame: CGRectMake(0,0,0,0))
        self.configure(arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription)
        self.arrayOfImage = arrayOfImage
        self.arrayOfTitle = arrayOfTitle
        self.arrayOfDescription = arrayOfDescription
        
        self.interceptOrientationChange()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //-----------------------------------------------------------------------------------------
    // MARK: PUBLIC FUNCTIONS    --------------------------------------------------------------
    //-----------------------------------------------------------------------------------------
    
    public func show() {
        
        //Update Color
        self.buttonBottom.backgroundColor = colorButtonBottomBackground
        self.backgroundColor = colorForAlertViewBackground
        self.buttonBottom.setTitleColor(colorButtonText, forState: .Normal)
        self.buttonBottom.setTitle(self.titleSkipButton, forState: .Normal)
        
        self.container = AlertPageViewController(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription, alertView: self)
        self.container.delegate = self
        self.insertSubview(self.container.view, aboveSubview: self)
        self.insertSubview(self.buttonBottom, aboveSubview: self)
        
        // Only show once
        if self.superview != nil {
            return
        }
        
        // Find current stop viewcontroller
        if let topController = getTopViewController() {
            let superView: UIView = topController.view
            superView.addSubview(self.background)
            superView.addSubview(self)
            self.configureConstraints(topController.view)
            self.animateForOpening()
        }
    }
    
    //Hide onboarding with animation
    public func hide(){
        self.checkIfOnboardingWasSkipped()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.animateForEnding()
        }
    }
    
    
    //------------------------------------------------------------------------------------------
    // MARK: PRIVATE FUNCTIONS    --------------------------------------------------------------
    //------------------------------------------------------------------------------------------
    
    //MARK: Check if onboarding was skipped
    private func checkIfOnboardingWasSkipped(){
        let currentStep = self.container.currentStep
        if currentStep < (self.container.arrayOfImage.count - 1) && !self.container.isCompleted{
            self.delegate?.alertOnboardingSkipped(currentStep, maxStep: self.container.maxStep)
        }
        else {
            self.delegate?.alertOnboardingCompleted()
        }
    }
    
    
    //MARK: FOR CONFIGURATION    --------------------------------------
    private func configure(arrayOfImage: [String], arrayOfTitle: [String], arrayOfDescription: [String]) {
        
        self.buttonBottom = UIButton(frame: CGRectMake(0,0, 0, 0))
        self.buttonBottom.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        self.buttonBottom.addTarget(self, action: #selector(AlertOnboarding.onClick), forControlEvents: .TouchUpInside)
        
        self.background = UIView(frame: CGRectMake(0,0, 0, 0))
        self.background.backgroundColor = UIColor.blackColor()
        self.background.alpha = 0.5
        
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
    }
    
    
    private func configureConstraints(superView: UIView) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.buttonBottom.translatesAutoresizingMaskIntoConstraints = false
        self.container.view.translatesAutoresizingMaskIntoConstraints = false
        self.background.translatesAutoresizingMaskIntoConstraints = false
        
        self.removeConstraints(self.constraints)
        self.buttonBottom.removeConstraints(self.buttonBottom.constraints)
        self.container.view.removeConstraints(self.container.view.constraints)
        
        heightForAlertView = UIScreen.mainScreen().bounds.height*percentageRatioHeight
        widthForAlertView = UIScreen.mainScreen().bounds.width*percentageRatioWidth
        
        //Constraints for alertview
        let horizontalContraintsAlertView = NSLayoutConstraint(item: self, attribute: .CenterXWithinMargins, relatedBy: .Equal, toItem: superView, attribute: .CenterXWithinMargins, multiplier: 1.0, constant: 0)
        let verticalContraintsAlertView = NSLayoutConstraint(item: self, attribute:.CenterYWithinMargins, relatedBy: .Equal, toItem: superView, attribute: .CenterYWithinMargins, multiplier: 1.0, constant: 0)
        let heightConstraintForAlertView = NSLayoutConstraint.init(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: heightForAlertView)
        let widthConstraintForAlertView = NSLayoutConstraint.init(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: widthForAlertView)
        
        //Constraints for button
        let verticalContraintsButtonBottom = NSLayoutConstraint(item: self.buttonBottom, attribute:.CenterXWithinMargins, relatedBy: .Equal, toItem: self, attribute: .CenterXWithinMargins, multiplier: 1.0, constant: 0)
        let heightConstraintForButtonBottom = NSLayoutConstraint.init(item: self.buttonBottom, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: heightForAlertView*0.1)
        let widthConstraintForButtonBottom = NSLayoutConstraint.init(item: self.buttonBottom, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: widthForAlertView)
        let pinContraintsButtonBottom = NSLayoutConstraint(item: self.buttonBottom, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0)
        
        //Constraints for container
        let verticalContraintsForContainer = NSLayoutConstraint(item: self.container.view, attribute:.CenterXWithinMargins, relatedBy: .Equal, toItem: self, attribute: .CenterXWithinMargins, multiplier: 1.0, constant: 0)
        let heightConstraintForContainer = NSLayoutConstraint.init(item: self.container.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: heightForAlertView*0.9)
        let widthConstraintForContainer = NSLayoutConstraint.init(item: self.container.view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: widthForAlertView)
        let pinContraintsForContainer = NSLayoutConstraint(item: self.container.view, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0)
        
        
        //Constraints for background
        let widthContraintsForBackground = NSLayoutConstraint(item: self.background, attribute:.Width, relatedBy: .Equal, toItem: superView, attribute: .Width, multiplier: 1, constant: 0)
        let heightConstraintForBackground = NSLayoutConstraint.init(item: self.background, attribute: .Height, relatedBy: .Equal, toItem: superView, attribute: .Height, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activateConstraints([horizontalContraintsAlertView, verticalContraintsAlertView,heightConstraintForAlertView, widthConstraintForAlertView,
            verticalContraintsButtonBottom, heightConstraintForButtonBottom, widthConstraintForButtonBottom, pinContraintsButtonBottom,
            verticalContraintsForContainer, heightConstraintForContainer, widthConstraintForContainer, pinContraintsForContainer,
            widthContraintsForBackground, heightConstraintForBackground])
    }
    
    //MARK: FOR ANIMATIONS ---------------------------------
    private func animateForOpening(){
        self.alpha = 1.0
        self.transform = CGAffineTransformMakeScale(0.3, 0.3)
        UIView.animateWithDuration(1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
    }
    
    private func animateForEnding(){
        UIView.animateWithDuration(0.2, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                // On main thread
                dispatch_async(dispatch_get_main_queue()) {
                    () -> Void in
                    self.background.removeFromSuperview()
                    self.removeFromSuperview()
                    self.container.removeFromParentViewController()
                    self.container.view.removeFromSuperview()
                }
        })
    }
    
    //MARK: BUTTON ACTIONS ---------------------------------
    
    func onClick(){
        self.hide()
    }
    
    //MARK: ALERTPAGEVIEWDELEGATE    --------------------------------------
    
    func nextStep(step: Int) {
        self.delegate?.alertOnboardingNext(step)
    }
    
    //MARK: OTHERS    --------------------------------------
    private func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    //MARK: NOTIFICATIONS PROCESS ------------------------------------------
    private func interceptOrientationChange(){
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AlertOnboarding.onOrientationChange), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func onOrientationChange(){
        if let superview = self.superview {
            self.configureConstraints(superview)
            self.container.configureConstraintsForPageControl()
        }
    }
}