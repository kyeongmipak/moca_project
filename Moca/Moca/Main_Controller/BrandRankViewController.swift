//
//  BrandRankViewController.swift
//  Moca
//
//  Created by 박경미 on 2021/03/02.
//

import UIKit

class BrandRankViewController: UIViewController, BrandTabsDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    @IBOutlet weak var tabsView: BrandTabsView!
    
    var reveiveItem = ""
    var currentIndex: Int = 0
    var selectedIndex = 0
    
    var pageController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch reveiveItem {
            case "스타벅스":
                selectedIndex = 0
            case "투썸플레이스":
                selectedIndex = 1
            case "이디야":
                selectedIndex = 2
            case "할리스":
                selectedIndex = 3
            default:
                selectedIndex = 0
        }
        
        
        setupTabs()
        
        setupPageViewController(index: selectedIndex)
    }
    func setupTabs() {
        // Add Tabs (Set 'icon'to nil if you don't want to have icons)
        tabsView.tabs = [
            BrandTab(title: "스타벅스"),
            BrandTab(title: "투썸플레이스"),
            BrandTab(title: "이디야"),
            BrandTab(title: "할리스커피")
//            Tab(icon: UIImage(named: "music"), title: "스타벅스"),
//            Tab(icon: UIImage(named: "movies"), title: "이디야"),
//            Tab(icon: UIImage(named: "books"), title: "할리스커피"),
//            Tab(icon: UIImage(named: "books"), title: "커피빈")
        ]
        
        // Set TabMode to '.fixed' for stretched tabs in full width of screen or '.scrollable' for scrolling to see all tabs
        tabsView.tabMode = .fixed
        
        // TabView Customization
        tabsView.titleColor = .white
        tabsView.iconColor = .white
        tabsView.indicatorColor = .white
        tabsView.titleFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        // tabsView.collectionView.backgroundColor = .cyan
        
        // Set TabsView Delegate
        tabsView.delegate = self
        
        // Set the selected Tab when the app starts
        tabsView.collectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .centeredVertically)
    }
    
    func setupPageViewController(index: Int) {
        // PageViewController
        self.pageController = storyboard?.instantiateViewController(withIdentifier: "TabsPageViewController") as! TabsPageViewController
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        
        // Set PageViewController Delegate & DataSource
        pageController.delegate = self
        pageController.dataSource = self
        
        // Set the selected ViewController in the PageViewController when the app starts
        pageController.setViewControllers([showViewController(index)!], direction: .forward, animated: true, completion: nil)
        
        // PageViewController Constraints
        self.pageController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pageController.view.topAnchor.constraint(equalTo: self.tabsView.bottomAnchor),
            self.pageController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.pageController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.pageController.didMove(toParent: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Refresh CollectionView Layout when you rotate the device
        tabsView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // Show ViewController for the current position
    func showViewController(_ index: Int) -> UIViewController? {
        if (self.tabsView.tabs.count == 0) || (index >= self.tabsView.tabs.count) {
            return nil
        }
        
        currentIndex = index
        
        if index == 0 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "StarbucksViewController") as! StarbucksViewController
            contentVC.brandName = tabsView.tabs[index].title
            contentVC.pageIndex = index
            return contentVC
        } else if index == 1 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "TwosomeViewController") as! TwosomeViewController
            contentVC.brandName = tabsView.tabs[index].title
            contentVC.pageIndex = index
            return contentVC
        } else if index == 2 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "EdiyaViewController") as! EdiyaViewController
            contentVC.brandName = tabsView.tabs[index].title
            contentVC.pageIndex = index
            return contentVC
        } else if index == 3 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "HollysViewController") as! HollysViewController
            contentVC.brandName = tabsView.tabs[index].title
            contentVC.pageIndex = index
            return contentVC
        } else {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "StarbucksViewController") as! StarbucksViewController
            contentVC.brandName = tabsView.tabs[index].title
            contentVC.pageIndex = index
            return contentVC
        }
    }
    
    // return ViewController when go backward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        
        if index == 0 {
            return nil
        } else {
            index -= 1
            return self.showViewController(index)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if completed {
                guard let vc = pageViewController.viewControllers?.first else { return }
                let index: Int
                
                index = getVCPageIndex(vc)
                
                
                tabsView.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredVertically)
                // Animate the tab in the TabsView to be centered when you are scrolling using .scrollable
                tabsView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    // Return the current position that is saved in the UIViewControllers we have in the UIPageViewController
    func getVCPageIndex(_ viewController: UIViewController?) -> Int {
        switch viewController {
        case is StarbucksViewController:
            let vc = viewController as! StarbucksViewController
            return vc.pageIndex
        case is TwosomeViewController:
            let vc = viewController as! TwosomeViewController
            return vc.pageIndex
        case is EdiyaViewController:
            let vc = viewController as! EdiyaViewController
            return vc.pageIndex
        case is HollysViewController:
            let vc = viewController as! HollysViewController
            return vc.pageIndex
        default:
            let vc = viewController as! StarbucksViewController
            return vc.pageIndex
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        // Don't do anything when viewpager reach the number of tabs
        if index == tabsView.tabs.count {
            return nil
        } else {
            index += 1
            return self.showViewController(index)
        }
    }
    
    func tabsViewDidSelectItemAt(position: Int) {
        // Check if the selected tab cell position is the same with the current position in pageController, if not, then go forward or backward
        if position != currentIndex {
            if position > currentIndex {
                self.pageController.setViewControllers([showViewController(position)!], direction: .forward, animated: true, completion: nil)
            } else {
                self.pageController.setViewControllers([showViewController(position)!], direction: .reverse, animated: true, completion: nil)
            }
            tabsView.collectionView.scrollToItem(at: IndexPath(item: position, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
}
