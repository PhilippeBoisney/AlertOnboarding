//
//  AlertChildPageViewController.swift
//  AlertOnboarding
//
//  Created by Philippe on 26/09/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//  Forked by Webdevotion 07/2017

import UIKit

@IBDesignable class AlertOnboardingTopAlignedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        if let stringText = text {
            let stringTextAsNSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRect(with: CGSize(width: self.frame.width,height: CGFloat.greatestFiniteMagnitude),
                                                                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                                                                    attributes: [NSFontAttributeName: font],
                                                                    context: nil).size
            super.drawText(in: CGRect(x:0,y: 0,width: self.frame.width, height:ceil(labelStringSize.height)))
        } else {
            super.drawText(in: rect)
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
}

class AlertChildPageViewController: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var labelMainTitle: UILabel!
    @IBOutlet weak var labelDescription: AlertOnboardingTopAlignedLabel!
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    var pageIndex: Int!
    var _containerHeight : CGFloat = 0.0
    var containerHeight: CGFloat {
        set {
            _containerHeight = newValue
            self.containerHeightConstraint.constant = _containerHeight
            self.view.setNeedsUpdateConstraints()
        }
        
        get {
            return max(150.0,_containerHeight)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.contentContainer.layer.cornerRadius = 10
//        self.contentContainer.backgroundColor = UIColor(hue:0.26, saturation:0.82, brightness:0.78, alpha:1.00)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.configureConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureConstraints() {

        self.contentContainer.translatesAutoresizingMaskIntoConstraints = false
        self.contentContainer.removeConstraints( self.contentContainer.constraints )
        self.contentContainer.clipsToBounds = true
        
        let subView = self.contentContainer.subviews[0]
        
        // try to adhere to the height set by the constraint
        // given by the main subcontent view ( container ) in the storyboard
        
        if let heightConstraint = subView.constraints.first(where: { $0.identifier == "containerHeight" }) {
            let heightConstraintForContainer = NSLayoutConstraint.init(item: self.contentContainer,
                                                                       attribute: .height,
                                                                       relatedBy: .equal,
                                                                       toItem: nil,
                                                                       attribute: .notAnAttribute,
                                                                       multiplier: 1,
                                                                       constant: heightConstraint.constant)

            //Constraints for container
            let horizontalContraintsForContainer = NSLayoutConstraint(item: self.contentContainer,
                                                                      attribute:.centerXWithinMargins,
                                                                      relatedBy: .equal,
                                                                      toItem: self.view,
                                                                      attribute: .centerXWithinMargins,
                                                                      multiplier: 1.0,
                                                                      constant: 0)
            
//            let heightConstraintForContainer = NSLayoutConstraint.init(item: self.contentContainer,
//                                                                       attribute: .height,
//                                                                       relatedBy: .equal,
//                                                                       toItem: nil,
//                                                                       attribute: .notAnAttribute,
//                                                                       multiplier: 1,
//                                                                       constant: 100)
            
            let widthConstraintForContainer = NSLayoutConstraint.init(item: self.contentContainer,
                                                                      attribute: .width,
                                                                      relatedBy: .equal,
                                                                      toItem: self.view,
                                                                      attribute: .width,
                                                                      multiplier: 1,
                                                                      constant: -20)
            
            let bottomContraintsForContainer = NSLayoutConstraint(item: self.contentContainer,
                                                                  attribute: .bottom,
                                                                  relatedBy: .equal,
                                                                  toItem: self.view,
                                                                  attribute: .bottom,
                                                                  multiplier: 1.0,
                                                                  constant: 0)
            
            let leftContraintsForContainer = NSLayoutConstraint.init(item: self.contentContainer,
                                                                     attribute: .left,
                                                                     relatedBy: .equal,
                                                                     toItem: self.view,
                                                                     attribute: .left,
                                                                     multiplier: 1,
                                                                     constant: 10)
            
            NSLayoutConstraint.activate([horizontalContraintsForContainer,
                                         heightConstraintForContainer,
                                         widthConstraintForContainer,
                                         leftContraintsForContainer,
                                         bottomContraintsForContainer])
            
            
            let heightConstraintForContainerSub = NSLayoutConstraint.init(item: subView,
                                                                       attribute: .height,
                                                                       relatedBy: .equal,
                                                                       toItem: nil,
                                                                       attribute: .notAnAttribute,
                                                                       multiplier: 1,
                                                                       constant: heightConstraint.constant)
            
            //Constraints for container
            let horizontalContraintsForContainerSub = NSLayoutConstraint(item: subView,
                                                                      attribute:.centerXWithinMargins,
                                                                      relatedBy: .equal,
                                                                      toItem: self.view,
                                                                      attribute: .centerXWithinMargins,
                                                                      multiplier: 1.0,
                                                                      constant: 0)
            
            //            let heightConstraintForContainer = NSLayoutConstraint.init(item: self.contentContainer,
            //                                                                       attribute: .height,
            //                                                                       relatedBy: .equal,
            //                                                                       toItem: nil,
            //                                                                       attribute: .notAnAttribute,
            //                                                                       multiplier: 1,
            //                                                                       constant: 100)
            
            let widthConstraintForContainerSub = NSLayoutConstraint.init(item: subView,
                                                                      attribute: .width,
                                                                      relatedBy: .equal,
                                                                      toItem: self.view,
                                                                      attribute: .width,
                                                                      multiplier: 1,
                                                                      constant: -20)
            
            let bottomContraintsForContainerSub = NSLayoutConstraint(item: subView,
                                                                  attribute: .bottom,
                                                                  relatedBy: .equal,
                                                                  toItem: self.view,
                                                                  attribute: .bottom,
                                                                  multiplier: 1.0,
                                                                  constant: 0)
            
            let leftContraintsForContainerSub = NSLayoutConstraint.init(item: subView,
                                                                     attribute: .left,
                                                                     relatedBy: .equal,
                                                                     toItem: self.view,
                                                                     attribute: .left,
                                                                     multiplier: 1,
                                                                     constant: 10)
            
            NSLayoutConstraint.activate([horizontalContraintsForContainerSub,
                                         heightConstraintForContainerSub,
                                         widthConstraintForContainerSub,
                                         leftContraintsForContainerSub,
                                         bottomContraintsForContainerSub])
            
            let bottomContraintsForContainerImageContainer = NSLayoutConstraint(item: self.imageContainerView,
                                                                     attribute: .bottom,
                                                                     relatedBy: .equal,
                                                                     toItem: self.contentContainer,
                                                                     attribute: .top,
                                                                     multiplier: 1.0,
                                                                     constant: 0)
            
            NSLayoutConstraint.activate([bottomContraintsForContainerImageContainer])
            
        }
    }
}
