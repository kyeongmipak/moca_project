//
//  TipPageViewController.swift
//  Moca
//
//  Created by JiEunPark on 2021/03/02.
//

import UIKit

class TipPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    enum PageViews: String {
        case tip0
        case tip1
        case tip2
        case tip3
        case tip4
        case tip5
    }
        
    fileprivate lazy var TipPageViewController: [UIViewController] = {
        return [self.getViewController(withIdentifier: PageViews.tip0.rawValue),
                self.getViewController(withIdentifier: PageViews.tip1.rawValue),
                self.getViewController(withIdentifier: PageViews.tip2.rawValue),
                self.getViewController(withIdentifier: PageViews.tip3.rawValue),
                self.getViewController(withIdentifier: PageViews.tip4.rawValue),
                self.getViewController(withIdentifier: PageViews.tip5.rawValue)]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
    {
        return (storyboard?.instantiateViewController(withIdentifier: identifier))!
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = TipPageViewController.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return TipPageViewController.last }
        guard TipPageViewController.count > previousIndex else { return nil }
        return TipPageViewController[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = TipPageViewController.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < TipPageViewController.count else { return TipPageViewController.first }
        guard TipPageViewController.count > nextIndex else { return nil }
        return TipPageViewController[nextIndex]
    }
    
    func presentationCount(for: UIPageViewController) -> Int {
        return TipPageViewController.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        if let firstVC = TipPageViewController.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
