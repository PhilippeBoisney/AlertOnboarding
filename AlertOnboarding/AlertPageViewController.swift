//
//  AlertPageViewController.swift
//  AlertOnboarding
//
//  Created by Philippe on 26/09/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//

import UIKit

protocol AlertPageViewDelegate {
    func nextStep(_ step: Int)
}

class AlertPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //FOR DESIGN
    var pageController: UIPageViewController!
    var pageControl: UIPageControl!
    var alertview: AlertOnboarding!
    
    //FOR DATA
    var arrayOfImage: [String]!
    var arrayOfTitle: [String]!
    var arrayOfDescription: [String]!
    var viewControllers = [UIViewController]()
    
    //FOR TRACKING USER USAGE
    var currentStep = 0
    var maxStep = 0
    var isCompleted = false
    var delegate: AlertPageViewDelegate?
    
    
    init (arrayOfImage: [String], arrayOfTitle: [String], arrayOfDescription: [String], alertView: AlertOnboarding) {
        super.init(nibName: nil, bundle: nil)
        self.arrayOfImage = arrayOfImage
        self.arrayOfTitle = arrayOfTitle
        self.arrayOfDescription = arrayOfDescription
        self.alertview = alertView
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurePageViewController()
        self.configurePageControl()
        
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(self.pageController.view)
        self.view.addSubview(self.pageControl)
        self.pageController.didMove(toParentViewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! AlertChildPageViewController).pageIndex!
        
        if(index == 0){
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! AlertChildPageViewController).pageIndex!
        
        index += 1
        
        if(index == arrayOfImage.count){
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    
    func viewControllerAtIndex(_ index : Int) -> UIViewController? {
        
        var pageContentViewController: AlertChildPageViewController!
        let podBundle = Bundle(for: self.classForCoder)
        
        //FROM COCOAPOD
        if let bundleURL = podBundle.url(forResource: "AlertOnboardingXib", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                pageContentViewController = UINib(nibName: "AlertChildPageViewController", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! AlertChildPageViewController
            } else {
                assertionFailure("Could not load the bundle.. Please re-install AlertOnboarding via Cocoapod or install it manually.")
            }
            //FROM MANUAL INSTALL
        }else {
            pageContentViewController = UINib(nibName: "AlertChildPageViewController", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AlertChildPageViewController
        }
        
        pageContentViewController.pageIndex = index // 0
        
        let realIndex = arrayOfImage.count - index - 1
        
        pageContentViewController.image.image = UIImage(named: arrayOfImage[realIndex])
        pageContentViewController.labelMainTitle.text = arrayOfTitle[realIndex]
        pageContentViewController.labelMainTitle.textColor = alertview.colorTitleLabel
        pageContentViewController.labelDescription.text = arrayOfDescription[realIndex]
        pageContentViewController.labelDescription.textColor = alertview.colorDescriptionLabel
        
        return pageContentViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0] as! AlertChildPageViewController
        let index = pageContentViewController.pageIndex
        self.currentStep = (arrayOfImage.count - index! - 1)
        self.delegate?.nextStep(self.currentStep)
        //Check if user watching the last step
        if currentStep == arrayOfImage.count - 1 {
            self.isCompleted = true
        }
        //Remember the last screen user have seen
        if currentStep > self.maxStep {
            self.maxStep = currentStep
        }
        if pageControl != nil {
            pageControl.currentPage = arrayOfImage.count - index! - 1
            if pageControl.currentPage == arrayOfImage.count - 1 {
                self.alertview.buttonBottom.setTitle(alertview.titleGotItButton, for: UIControlState())
            } else {
                self.alertview.buttonBottom.setTitle(alertview.titleSkipButton, for: UIControlState())
            }
        }
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return arrayOfImage.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    //MARK: CONFIGURATION ---------------------------------------------------------------------------------
    fileprivate func configurePageControl() {
        self.pageControl = UIPageControl(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
        self.pageControl.backgroundColor = UIColor.clear
        self.pageControl.pageIndicatorTintColor = alertview.colorPageIndicator
        self.pageControl.currentPageIndicatorTintColor = alertview.colorCurrentPageIndicator
        self.pageControl.numberOfPages = arrayOfImage.count
        self.pageControl.currentPage = 0
        self.pageControl.isEnabled = false
        
        self.configureConstraintsForPageControl()
    }
    
    fileprivate func configurePageViewController(){
        self.pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal, options: nil)
        self.pageController.view.backgroundColor = UIColor.clear
        
        if #available(iOS 9.0, *) {
            let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [AlertPageViewController.self])
            pageControl.pageIndicatorTintColor = UIColor.clear
            pageControl.currentPageIndicatorTintColor = UIColor.clear
            
        } else {
            // Fallback on earlier versions
        }
        
        self.pageController.dataSource = self
        self.pageController.delegate = self
        
        let initialViewController = self.viewControllerAtIndex(arrayOfImage.count-1)
        self.viewControllers = [initialViewController!]
        self.pageController.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        
        self.addChildViewController(self.pageController)
    }
    
    //MARK: Called after notification orientation changement
    func configureConstraintsForPageControl() {
        let alertViewSizeHeight = UIScreen.main.bounds.height*alertview.percentageRatioHeight
        let positionX = alertViewSizeHeight - (alertViewSizeHeight * 0.1) - 50
        self.pageControl.frame = CGRect(x: 0, y: positionX, width: self.view.bounds.width, height: 50)
    }
}
