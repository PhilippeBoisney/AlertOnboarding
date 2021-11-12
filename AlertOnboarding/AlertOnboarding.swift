//
//  AlertOnboarding.swift
//  AlertOnboarding
//
//  Created by Philippe on 26/09/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//

import UIKit

public protocol AlertOnboardingDelegate {
    func alertOnboardingSkipped(_ currentStep: Int, maxStep: Int)
    func alertOnboardingCompleted()
    func alertOnboardingNext(_ nextStep: Int)
}

open class AlertOnboarding: UIView, AlertPageViewDelegate {
    
    //FOR DATA  ------------------------
    fileprivate var arrayOfImage = [String]()
    fileprivate var arrayOfTitle = [String]()
    fileprivate var arrayOfDescription = [String]()
    
    //FOR DESIGN    ------------------------
    open var buttonBottom = UIButton()

    fileprivate var container: AlertPageViewController!
    open var background = UIView()
    
    
    //PUBLIC VARS   ------------------------
    open var colorForAlertViewBackground: UIColor = UIColor.white
    
    open var colorButtonBottomBackground: UIColor = UIColor(red: 226/255, green: 237/255, blue: 248/255, alpha: 1.0)
    open var colorButtonText: UIColor = UIColor(red: 118/255, green: 125/255, blue: 152/255, alpha: 1.0)
    
    open var colorTitleLabel: UIColor = UIColor(red: 171/255, green: 177/255, blue: 196/255, alpha: 1.0)
    open var colorDescriptionLabel: UIColor = UIColor(red: 171/255, green: 177/255, blue: 196/255, alpha: 1.0)
    
    open var colorPageIndicator = UIColor(red: 171/255, green: 177/255, blue: 196/255, alpha: 1.0)
    open var colorCurrentPageIndicator = UIColor(red: 118/255, green: 125/255, blue: 152/255, alpha: 1.0)
    
    open var heightForAlertView: CGFloat!
    open var widthForAlertView: CGFloat!
    
    open var percentageRatioHeight: CGFloat = 0.8
    open var percentageRatioWidth: CGFloat = 0.8
    
    open var titleSkipButton = "SKIP"
    open var titleGotItButton = "GOT IT !"
    
    open var delegate: AlertOnboardingDelegate?
    
    
    public init (arrayOfImage: [String], arrayOfTitle: [String], arrayOfDescription: [String]) {
        super.init(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
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
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //-----------------------------------------------------------------------------------------
    // MARK: PUBLIC FUNCTIONS
    //-----------------------------------------------------------------------------------------
    
    open func show() {
        
        //Update Color
        buttonBottom.backgroundColor = colorButtonBottomBackground
        backgroundColor = colorForAlertViewBackground
        buttonBottom.setTitleColor(colorButtonText, for: UIControl.State())
        buttonBottom.setTitle(titleSkipButton, for: UIControl.State())
        
        container = AlertPageViewController(arrayOfImage: arrayOfImage, arrayOfTitle: arrayOfTitle, arrayOfDescription: arrayOfDescription, alertView: self)
        container.delegate = self
        insertSubview(container.view, aboveSubview: self)
        insertSubview(buttonBottom, aboveSubview: self)
        
        // Only show once
        if superview != nil {
            return
        }
        
        // Find current stop viewcontroller
        if let topController = getTopViewController() {
            let superView: UIView = topController.view
            superView.addSubview(background)
            superView.addSubview(self)
            configureConstraints(topController.view)
            animateForOpening()
        }
    }
    
    //Hide onboarding with animation
    open func hide(){
        checkIfOnboardingWasSkipped()
        DispatchQueue.main.async { () -> Void in
            self.animateForEnding()
        }
    }
    
    
    //------------------------------------------------------------------------------------------
    // MARK: PRIVATE FUNCTIONS
    //------------------------------------------------------------------------------------------
    
    //MARK: Check if onboarding was skipped
    fileprivate func checkIfOnboardingWasSkipped(){
        let currentStep = container.currentStep
        if currentStep < (container.arrayOfImage.count - 1) && !container.isCompleted{
            delegate?.alertOnboardingSkipped(currentStep, maxStep: container.maxStep)
        }
        else {
            delegate?.alertOnboardingCompleted()
        }
    }
    
    
    //MARK: FOR CONFIGURATION
    fileprivate func configure(_ arrayOfImage: [String], arrayOfTitle: [String], arrayOfDescription: [String]) {
        
        buttonBottom = UIButton(frame: CGRect(x: 0,y: 0, width: 0, height: 0))
        buttonBottom.titleLabel?.font = UIFont(name: "Avenir-Black", size: 15)
        buttonBottom.addTarget(self, action: #selector(AlertOnboarding.onClick), for: .touchUpInside)
        
        background = UIView(frame: CGRect(x: 0,y: 0, width: 0, height: 0))
        background.backgroundColor = UIColor.black
        background.alpha = 0.0
        
        
        clipsToBounds = true
        layer.cornerRadius = 10
    }
    
    
    fileprivate func configureConstraints(_ superView: UIView) {
        
        translatesAutoresizingMaskIntoConstraints = false
        buttonBottom.translatesAutoresizingMaskIntoConstraints = false
        container.view.translatesAutoresizingMaskIntoConstraints = false
        background.translatesAutoresizingMaskIntoConstraints = false
        
        removeConstraints(constraints)
        buttonBottom.removeConstraints(buttonBottom.constraints)
        container.view.removeConstraints(container.view.constraints)
        
        heightForAlertView = UIScreen.main.bounds.height*percentageRatioHeight
        widthForAlertView = UIScreen.main.bounds.width*percentageRatioWidth
        
        //Constraints for alertview
        let horizontalContraintsAlertView = NSLayoutConstraint(item: self, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: superView, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0)
        let verticalContraintsAlertView = NSLayoutConstraint(item: self, attribute: .centerYWithinMargins, relatedBy: .equal, toItem: superView, attribute: .centerYWithinMargins, multiplier: 1.0, constant: 0)
        let heightConstraintForAlertView = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: heightForAlertView)
        let widthConstraintForAlertView = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: widthForAlertView)
        
        //Constraints for button
        let verticalContraintsButtonBottom = NSLayoutConstraint(item: buttonBottom, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: self, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0)
        let heightConstraintForButtonBottom = NSLayoutConstraint.init(item: buttonBottom, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: heightForAlertView*0.1)
        let widthConstraintForButtonBottom = NSLayoutConstraint.init(item: buttonBottom, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: widthForAlertView)
        let pinContraintsButtonBottom = NSLayoutConstraint(item: buttonBottom, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        //Constraints for container
        let verticalContraintsForContainer = NSLayoutConstraint(item: container.view, attribute: .centerXWithinMargins, relatedBy: .equal, toItem: self, attribute: .centerXWithinMargins, multiplier: 1.0, constant: 0)
        let heightConstraintForContainer = NSLayoutConstraint.init(item: container.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: heightForAlertView*0.9)
        let widthConstraintForContainer = NSLayoutConstraint.init(item: container.view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: widthForAlertView)
        let pinContraintsForContainer = NSLayoutConstraint(item: container.view, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        
        
        //Constraints for background
        let widthContraintsForBackground = NSLayoutConstraint(item: background, attribute:.width, relatedBy: .equal, toItem: superView, attribute: .width, multiplier: 1, constant: 0)
        let heightConstraintForBackground = NSLayoutConstraint.init(item: background, attribute: .height, relatedBy: .equal, toItem: superView, attribute: .height, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([horizontalContraintsAlertView, verticalContraintsAlertView,heightConstraintForAlertView, widthConstraintForAlertView,
                                     verticalContraintsButtonBottom, heightConstraintForButtonBottom, widthConstraintForButtonBottom, pinContraintsButtonBottom,
                                     verticalContraintsForContainer, heightConstraintForContainer, widthConstraintForContainer, pinContraintsForContainer,
                                     widthContraintsForBackground, heightConstraintForBackground])
    }
    
    //MARK: FOR ANIMATIONS
    fileprivate func animateForOpening() {
        alpha = 1.0
        transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        UIView.animate(withDuration: 1, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: { [weak self] in
            guard let self = self else { return }

            self.background.alpha = 0.5
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
    }
    
    fileprivate func animateForEnding() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }

            self.alpha = 0.0
            self.background.alpha = 0.0
            }, completion: { [weak self] finished in
                // On main thread
                self?.endingAnimationCompleted()
        })
    }

    private func endingAnimationCompleted() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.background.removeFromSuperview()
            self.removeFromSuperview()
            self.container.removeFromParent()
            self.container.view.removeFromSuperview()
        }
    }
    
    //MARK: BUTTON ACTIONS
    
    @objc func onClick() {
        hide()
    }
    
    //MARK: ALERTPAGEVIEWDELEGATE
    
    func nextStep(_ step: Int) {
        delegate?.alertOnboardingNext(step)
    }
    
    //MARK: OTHERS
    fileprivate func getTopViewController() -> UIViewController? {
        var topController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController
        while topController?.presentedViewController != nil {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    //MARK: NOTIFICATIONS PROCESS
    fileprivate func interceptOrientationChange(){
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(onOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func onOrientationChange(){
        if let superview = superview {
            configureConstraints(superview)
            container.configureConstraintsForPageControl()
        }
    }
}
