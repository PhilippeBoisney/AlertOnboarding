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

    // FOR DESIGN
    var pageController: UIPageViewController = {
        let pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.view.backgroundColor = .clear
        return pageController
    }()

    var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        pageControl.backgroundColor = UIColor.clear

        pageControl.currentPage = 0
        pageControl.isEnabled = false
        return pageControl
    }()

    var alertview: AlertOnboarding

    // FOR DATA
    var arrayOfImage: [String]
    var arrayOfTitle: [String]
    var arrayOfDescription: [String]
    var viewControllers = [UIViewController]()

    // FOR TRACKING USER USAGE
    var currentStep = 0
    var maxStep = 0
    var isCompleted = false
    var delegate: AlertPageViewDelegate?

    init (arrayOfImage: [String], arrayOfTitle: [String], arrayOfDescription: [String], alertView: AlertOnboarding) {
        self.arrayOfImage = arrayOfImage
        self.arrayOfTitle = arrayOfTitle
        self.arrayOfDescription = arrayOfDescription
        self.alertview = alertView

        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configurePageViewController()
        configurePageControl()

        view.backgroundColor = UIColor.clear
        view.addSubview(pageController.view)
        view.addSubview(pageControl)
        pageController.didMove(toParent: self)
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
        guard let viewController = viewController as? AlertChildPageViewController else {
            return nil
        }

        var index = viewController.pageIndex

        if index == 0 {
            return nil
        }

        index -= 1
        return viewControllerAtIndex(index)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? AlertChildPageViewController else {
            return nil
        }

        var index = viewController.pageIndex

        index += 1

        if index == arrayOfImage.count {
            return nil
        }

        return viewControllerAtIndex(index)
    }

    func viewControllerAtIndex(_ index: Int) -> UIViewController? {

        var pageContentViewController: AlertChildPageViewController!
        let podBundle = Bundle(for: classForCoder)

        // FROM COCOAPOD
        if let bundleURL = podBundle.url(forResource: "AlertOnboardingXib", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                pageContentViewController = UINib(nibName: "AlertChildPageViewController", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? AlertChildPageViewController
            } else {
                assertionFailure("Could not load the bundle.. Please re-install AlertOnboarding via Cocoapod or install it manually.")
            }
            // FROM MANUAL INSTALL
        } else {
            pageContentViewController = UINib(nibName: "AlertChildPageViewController", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? AlertChildPageViewController
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
        guard let controllers = pageViewController.viewControllers, !controllers.isEmpty else { return }
        guard let pageContentViewController = controllers[0] as? AlertChildPageViewController else { return }

        let index = pageContentViewController.pageIndex
        currentStep = (arrayOfImage.count - index - 1)
        delegate?.nextStep(currentStep)
        // Check if user watching the last step
        if currentStep == arrayOfImage.count - 1 {
            isCompleted = true
        }
        // Remember the last screen user have seen
        if currentStep > maxStep {
            maxStep = currentStep
        }

        pageControl.currentPage = arrayOfImage.count - index - 1
        if pageControl.currentPage == arrayOfImage.count - 1 {
            alertview.buttonBottom.setTitle(alertview.titleGotItButton, for: UIControl.State())
        } else {
            alertview.buttonBottom.setTitle(alertview.titleSkipButton, for: UIControl.State())
        }
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return arrayOfImage.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }

    // MARK: CONFIGURATION ---------------------------------------------------------------------------------
    fileprivate func configurePageControl() {
        pageControl.pageIndicatorTintColor = alertview.colorPageIndicator
        pageControl.currentPageIndicatorTintColor = alertview.colorCurrentPageIndicator
        pageControl.numberOfPages = arrayOfImage.count

        configureConstraintsForPageControl()
    }

    fileprivate func configurePageViewController() {
        if #available(iOS 9.0, *) {
            let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [AlertPageViewController.self])
            pageControl.pageIndicatorTintColor = UIColor.clear
            pageControl.currentPageIndicatorTintColor = UIColor.clear
        } else {
            // Fallback on earlier versions
        }

        pageController.dataSource = self
        pageController.delegate = self

        let initialViewController = viewControllerAtIndex(arrayOfImage.count-1)
        viewControllers = [initialViewController!]
        pageController.setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)

        addChild(pageController)
    }

    // MARK: Called after notification orientation changement
    func configureConstraintsForPageControl() {
        let alertViewSizeHeight = UIScreen.main.bounds.height*alertview.heightRatio
        let positionX = alertViewSizeHeight - (alertViewSizeHeight * 0.1) - 50
        pageControl.frame = CGRect(x: 0, y: positionX, width: view.bounds.width, height: 50)
    }
}
