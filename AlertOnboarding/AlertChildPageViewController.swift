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
    @IBOutlet weak var labelMainTitle: UILabel!
    @IBOutlet weak var labelDescription: AlertOnboardingTopAlignedLabel!
    @IBOutlet weak var contentContainer: UIView!
    @IBOutlet weak var containerHeightConstraint: NSLayoutConstraint!
    
    var pageIndex: Int!
    var _containerHeight : CGFloat = 10.0
    var containerHeight: CGFloat {
        set {
            _containerHeight = newValue
            self.containerHeightConstraint.constant = _containerHeight
            self.view.setNeedsUpdateConstraints()
        }
        
        get {
            return _containerHeight
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("did load", containerHeightConstraint.constant)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.configureConstraints()
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent);
        print("did move", containerHeightConstraint.constant)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func configureConstraints() {
        self.contentContainer.translatesAutoresizingMaskIntoConstraints = false
        self.contentContainer.removeConstraints(self.contentContainer.constraints)
        
        //Constraints for container
        let horizontalContraintsForContainer = NSLayoutConstraint(item: self.contentContainer,
                                                                attribute:.centerXWithinMargins,
                                                                relatedBy: .equal,
                                                                toItem: self.view,
                                                                attribute: .centerXWithinMargins,
                                                                multiplier: 1.0,
                                                                constant: 0)
        
        let heightConstraintForContainer = NSLayoutConstraint.init(item: self.contentContainer,
                                                                   attribute: .height,
                                                                   relatedBy: .equal,
                                                                   toItem: nil,
                                                                   attribute: .notAnAttribute,
                                                                   multiplier: 1,
                                                                   constant: self.containerHeight)
        
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
        leftContraintsForContainer.identifier = "left constraint for container"
        
        NSLayoutConstraint.activate([horizontalContraintsForContainer,
                                     heightConstraintForContainer,
                                     widthConstraintForContainer,
                                     leftContraintsForContainer,
                                     bottomContraintsForContainer])
    }
}
