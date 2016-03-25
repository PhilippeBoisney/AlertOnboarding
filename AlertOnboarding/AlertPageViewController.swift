//
//  AlertPageViewController.swift
//  AlertOnboarding
//
//  Created by Philippe Boisney on 24/03/2016.
//  Copyright © 2016 Philippe Boisney. All rights reserved.
//

import UIKit

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
        
        self.view.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.pageController.view)
        self.view.addSubview(self.pageControl)
        self.pageController.didMoveToParentViewController(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! AlertChildPageViewController).pageIndex!
        
        if(index == 0){
            return nil
        }
        
        index--
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! AlertChildPageViewController).pageIndex!
        
        index++
        
        if(index == arrayOfImage.count){
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        let pageContentViewController = UINib(nibName: "AlertChildPageViewController", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! AlertChildPageViewController
        pageContentViewController.pageIndex = index // 0
        
        let realIndex = arrayOfImage.count - index - 1
        
        pageContentViewController.image.image = UIImage(named: arrayOfImage[realIndex])
        pageContentViewController.labelMainTitle.text = arrayOfTitle[realIndex]
        pageContentViewController.labelMainTitle.textColor = alertview.colorTitleLabel
        pageContentViewController.labelDescription.text = arrayOfDescription[realIndex]
        pageContentViewController.labelDescription.textColor = alertview.colorDescriptionLabel
                
        return pageContentViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0] as! AlertChildPageViewController
        let index = pageContentViewController.pageIndex
        if pageControl != nil {
            pageControl.currentPage = arrayOfImage.count - index - 1
            if pageControl.currentPage == arrayOfImage.count - 1 {
                self.alertview.buttonBottom.setTitle(alertview.titleGotItButton, forState: .Normal)
            } else {
                self.alertview.buttonBottom.setTitle(alertview.titleSkipButton, forState: .Normal)
            }
        }
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return arrayOfImage.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    //MARK: CONFIGURATION ---------------------------------------------------------------------------------
    private func configurePageControl() {
        self.pageControl = UIPageControl(frame: CGRectMake(0,0,0,0))
        self.pageControl.backgroundColor = alertview.colorForAlertViewBackground
        self.pageControl.pageIndicatorTintColor = alertview.colorPageIndicator
        self.pageControl.currentPageIndicatorTintColor = alertview.colorCurrentPageIndicator
        self.pageControl.numberOfPages = arrayOfImage.count
        self.pageControl.currentPage = 0
        self.pageControl.enabled = false
        
        self.configureConstraintsForPageControl()
    }
    
    private func configurePageViewController(){
        self.pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        self.pageController.view.backgroundColor = UIColor.clearColor()
        self.pageController.dataSource = self
        self.pageController.delegate = self
        
        let initialViewController = self.viewControllerAtIndex(arrayOfImage.count-1)
        self.viewControllers = [initialViewController!]
        self.pageController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        
        self.addChildViewController(self.pageController)
    }
    
    func configureConstraintsForPageControl() {        
        let alertViewSizeHeight = UIScreen.mainScreen().bounds.height*0.8
        let positionX = alertViewSizeHeight - (alertViewSizeHeight * 0.1) - 50
        self.pageControl.frame = CGRectMake(0, positionX, self.view.bounds.width, 50)
    }
}
