//
//  CategoryRankViewController.swift
//  Main_FINIALLY_2.26
//
//  Created by 박경미 on 2021/02/27.
//

import UIKit

class CategoryRankViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource, CategoryTabsDelegate {
    
    @IBOutlet weak var categoryTabsView: CategoryTabsView!
  
    var reveiveItem = ""
    var currentIndex: Int = 0
    var selectedIndex = 0
    
    var pageController: UIPageViewController!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        switch reveiveItem {
            case "전체":
                selectedIndex = 0
            case "커피":
                selectedIndex = 1
            case "음료":
                selectedIndex = 2
            case "티":
                selectedIndex = 3
            case "밀크티":
                selectedIndex = 4
            default:
                selectedIndex = 0
        }


        setupTabs()

        setupPageViewController(index: selectedIndex)
    }
    
    func setupTabs() {
        // Add Tabs (Set 'icon'to nil if you don't want to have icons)
        categoryTabsView.tabs = [
            CategoryTab(title: "전체"),
            CategoryTab(title: "커피"),
            CategoryTab(title: "음료"),
            CategoryTab(title: "티"),
            CategoryTab(title: "쉐이크")

        ]

        // Set TabMode to '.fixed' for stretched tabs in full width of screen or '.scrollable' for scrolling to see all tabs
        categoryTabsView.tabMode = .fixed

        // TabView Customization
        categoryTabsView.titleColor = .white
        categoryTabsView.iconColor = .white
        categoryTabsView.indicatorColor = .white
        categoryTabsView.titleFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
        // tabsView.collectionView.backgroundColor = .cyan

        // Set TabsView Delegate
        categoryTabsView.delegate = self

        // Set the selected Tab when the app starts
        categoryTabsView.collectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .centeredVertically)
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
            self.pageController.view.topAnchor.constraint(equalTo: self.categoryTabsView.bottomAnchor),
            self.pageController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.pageController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.pageController.didMove(toParent: self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Refresh CollectionView Layout when you rotate the device
        categoryTabsView.collectionView.collectionViewLayout.invalidateLayout()
    }

    // Show ViewController for the current position
    func showViewController(_ index: Int) -> UIViewController? {
        if (self.categoryTabsView.tabs.count == 0) || (index >= self.categoryTabsView.tabs.count) {
            return nil
        }

        currentIndex = index

        if index == 0 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "AllMenuViewController") as! AllMenuViewController
//            contentVC.categoryName = categoryTabsView.tabs[index].title
            contentVC.categoryName = ""
            contentVC.pageIndex = index
            return contentVC
        } else if index == 1 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "CoffeeViewController") as! CoffeeViewController
            contentVC.categoryName = categoryTabsView.tabs[index].title
            contentVC.pageIndex = index
            return contentVC
            
        } else if index == 2 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "BeverageViewController") as! BeverageViewController
            contentVC.categoryName = categoryTabsView.tabs[index].title
            contentVC.pageIndex = index
            return contentVC
            
        } else if index == 3 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "TeaViewController") as! TeaViewController
            contentVC.categoryName = categoryTabsView.tabs[index].title
            contentVC.pageIndex = index
            return contentVC
        } else if index == 4 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "ShakeViewController") as! ShakeViewController
            contentVC.categoryName = categoryTabsView.tabs[index].title
            contentVC.pageIndex = index
            return contentVC
        } else {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "AllMenuViewController") as! AllMenuViewController
//            contentVC.categoryName = categoryTabsView.tabs[index].title
            contentVC.categoryName = ""
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


                categoryTabsView.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredVertically)
                // Animate the tab in the TabsView to be centered when you are scrolling using .scrollable
                categoryTabsView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }

    // Return the current position that is saved in the UIViewControllers we have in the UIPageViewController
    func getVCPageIndex(_ viewController: UIViewController?) -> Int {
        switch viewController {
        case is AllMenuViewController:
            let vc = viewController as! AllMenuViewController
            return vc.pageIndex
        case is CoffeeViewController:
            let vc = viewController as! CoffeeViewController
            return vc.pageIndex
        case is BeverageViewController:
            let vc = viewController as! BeverageViewController
            return vc.pageIndex
        case is TeaViewController:
            let vc = viewController as! TeaViewController
            return vc.pageIndex
        case is ShakeViewController:
            let vc = viewController as! ShakeViewController
            return vc.pageIndex
        default:
            let vc = viewController as! AllMenuViewController
            return vc.pageIndex
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        // Don't do anything when viewpager reach the number of tabs
        if index == categoryTabsView.tabs.count {
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
            categoryTabsView.collectionView.scrollToItem(at: IndexPath(item: position, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
}
