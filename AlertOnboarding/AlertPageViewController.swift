//
//  AlertPageViewController.swift
//  AlertOnboarding
//
//  Created by Philippe on 26/09/2016.
//  Copyright © 2016 CookMinute. All rights reserved.
//  Forked by Webdevotion 07/2017

import UIKit

protocol AlertPageViewDelegate {
    func nextStep(_ step: Int)
}

struct AlertOnboardingPageIndex {
    
    static let INVALID_PAGE_INDEX: Int = -1
    
    var value : Int = 0
    var maximum : Int = 0
    var valid : Bool {
        get {
            return self.isValueValid(self.value)
        }
    }
    
    var isLastPageIndex : Bool {
        get {
            return self.maximum == self.value
        }
    }
    
    // always zero, negative page indexes do not exist, ... yet
    let minimum : Int = 0
    
    
    init(_ value:Int = 0, maximum:Int = 0) {
        self.value = value
        self.maximum = maximum
    }
    
    func next() -> Int {
        return isValueValid(self.value + 1) ? self.value + 1 : AlertOnboardingPageIndex.INVALID_PAGE_INDEX
    }
    
    func prev() -> Int {
        return isValueValid(self.value - 1) ? self.value - 1 : AlertOnboardingPageIndex.INVALID_PAGE_INDEX
    }
    
    func isValueValid (_ value: Int = -1) -> Bool {
        return value == max(self.minimum,min(self.maximum,value))
    }
}

struct PageViewControllerTransitions {
    var nextIndex: Int
}

extension AlertPageViewController {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return AlertOnboardingPageIndex.INVALID_PAGE_INDEX  == currentStep.next() ? nil : self.viewControllerAtIndex( currentStep.next() )
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return AlertOnboardingPageIndex.INVALID_PAGE_INDEX == currentStep.prev() ? nil : self.viewControllerAtIndex( currentStep.prev() )
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers[0] as? AlertChildPageViewController {
            pageViewControllerTransition.nextIndex = vc.pageIndex
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if( !completed ){
            return
        }
        
        if( self.currentStep.value != pageViewControllerTransition.nextIndex ){
            self.currentStep.value = pageViewControllerTransition.nextIndex
            refresh(animated:false)
        }
    }
}

extension AlertPageViewController {
    // get initialized viewcontroller from story board, depending on manual install or as cocoapod
    func getPageContentViewController() -> AlertChildPageViewController{
        //
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "AlertOnboardingXib", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                return UINib(nibName: "AlertChildPageViewController", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! AlertChildPageViewController
            } else {
                assertionFailure("Could not load the bundle.. Please re-install AlertOnboarding via Cocoapod or install it manually.")
            }
            //FROM MANUAL INSTALL
        }
        
        return UINib(nibName: "AlertChildPageViewController", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AlertChildPageViewController
    }
}

class AlertPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //FOR DESIGN
    var pageController: UIPageViewController!
    var pageControl: UIPageControl!
    var alertview: AlertOnboarding!
    
    //FOR DATA
    var _arrayOfImage:[String]!
    var arrayOfImage: [String]! {
        get {
            return _arrayOfImage
        }
        
        set {
            _arrayOfImage = newValue
            self.currentStep.maximum = _arrayOfImage.count - 1
        }
    }
    var arrayOfTitle: [String]!
    var arrayOfDescription: [String]!
    var arrayOfContainers: [UIViewController]!
    var viewControllers = [UIViewController]()
    
    //FOR TRACKING USER USAGE
    var pageViewControllerTransition = PageViewControllerTransitions(nextIndex: 0)
    var currentStep : AlertOnboardingPageIndex = AlertOnboardingPageIndex()
    var maxStep = 0
    var isCompleted : Bool {
        get {
            return self.currentStep.isLastPageIndex
        }
    }
    var delegate: AlertPageViewDelegate?
    
    
    init (arrayOfImage: [String], arrayOfTitle: [String], arrayOfDescription: [String], arrayOfContainers: [UIViewController], alertView: AlertOnboarding) {
        super.init(nibName: nil, bundle: nil)
        self.arrayOfImage = arrayOfImage
        self.arrayOfTitle = arrayOfTitle
        self.arrayOfDescription = arrayOfDescription
        self.alertview = alertView
        self.arrayOfContainers = arrayOfContainers
    }
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configurePageViewController()
        self.configurePageControl()
        
        self.refresh()
        
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
    
    func nextPage() -> Bool {
        if self.currentStep.isLastPageIndex {
            return false
        }
        
        let nextIndex = self.currentStep.next()
        if( nextIndex == AlertOnboardingPageIndex.INVALID_PAGE_INDEX ){
            return false
        }
        
        self.currentStep.value = nextIndex
        self.refresh()
        return true
    }
    
    func viewControllerAtIndex(_ index : Int) -> AlertChildPageViewController? {
        
        if !self.currentStep.isValueValid(index) {
            return nil
        }
        
        let pageContentViewController = getPageContentViewController()
        
        pageContentViewController.pageIndex = index
        pageContentViewController.image.image = UIImage(named: arrayOfImage[index])
        pageContentViewController.labelMainTitle.text = arrayOfTitle[index]
        pageContentViewController.labelMainTitle.textColor = alertview.colorTitleLabel
        pageContentViewController.labelDescription.text = arrayOfDescription[index]
        pageContentViewController.labelDescription.textColor = alertview.colorDescriptionLabel
        
        let vc = arrayOfContainers[index]
        pageContentViewController.addChildViewController(vc)
        pageContentViewController.view.addSubview(vc.view)
        pageContentViewController.contentContainer = vc.view
        vc.didMove(toParentViewController: pageContentViewController)
        pageContentViewController.configureConstraints()
        return pageContentViewController
    }

    
    func refresh(animated:Bool = true,direction:UIPageViewControllerNavigationDirection = .forward) {
        DispatchQueue.main.async {
            
            guard let currentPageViewController = self.viewControllerAtIndex(self.currentStep.value) else {
                return
            }
            
            self.viewControllers = [currentPageViewController]
            self.pageController.setViewControllers(self.viewControllers, direction: direction, animated: animated, completion: nil)
            self.currentStep.value = (currentPageViewController as AlertChildPageViewController).pageIndex

            //Remember the last screen user have seen
            self.maxStep = max( self.maxStep, self.currentStep.value )
            self.delegate?.nextStep(self.currentStep.value)
            
            if self.pageControl == nil {
                return
            }
            
            self.pageControl.currentPage = self.currentStep.value
            let buttonLabel : String = self.currentStep.isLastPageIndex ? self.alertview.titleGotItButton : self.alertview.titleSkipButton
            self.alertview.buttonBottom.setTitle(buttonLabel, for: UIControlState())
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
        self.pageControl.numberOfPages = self.currentStep.maximum + 1
        self.pageControl.currentPage = self.currentStep.value
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
        }
        
        self.pageController.dataSource = self
        self.pageController.delegate = self
        
        self.addChildViewController(self.pageController)
    }
    
    //MARK: Called after notification orientation changement
    func configureConstraintsForPageControl() {
        self.pageControl.frame = CGRect(x: 0, y: 15.0, width: self.view.bounds.width, height: 50)
    }
}
