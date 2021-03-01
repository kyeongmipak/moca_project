//
//  BrandTabsView.swift
//  Moca
//
//  Created by 박경미 on 2021/03/01.
//

import UIKit

protocol BrandTabsDelegate {
    func tabsViewDidSelectItemAt(position: Int)
}

enum BrandTabMode {
    case fixed
    case scrollable
}

struct BrandTab {
    var icon: UIImage?
    var title: String
}

class BrandTabsView: UIView {
    var tabMode: BrandTabMode = .scrollable {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var tabs: [BrandTab] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var titleColor: UIColor = .black {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var titleFont: UIFont = UIFont.systemFont(ofSize: 20, weight: .regular) {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var iconColor: UIColor = .black {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var indicatorColor: UIColor = .black {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var collectionView: UICollectionView!
    
    var delegate: BrandTabsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createView()
    }
    
    private func createView() {
        // Create Flow Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        // Create CollectionView
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BrandTabCell.self, forCellWithReuseIdentifier: "BrandTabCell")
        addSubview(collectionView)
        
        // ColletionView Constraints
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}

extension BrandTabsView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandTabCell", for: indexPath) as? BrandTabCell else {
            return UICollectionViewCell()
        }
        cell.tabViewModel = BrandTab(icon: tabs[indexPath.item].icon, title: tabs[indexPath.item].title)
        
        // Change Icon Color
//        cell.tabIcon.image = cell.tabIcon.image?.withRenderingMode(.alwaysTemplate)
//        cell.tabIcon.tintColor = iconColor
        
        // Change Title Color
        cell.tabTitle.font = titleFont
        cell.tabTitle.textColor = titleColor
        cell.indicatorColor = indicatorColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tabsViewDidSelectItemAt(position: indexPath.item)
    }
}

extension BrandTabsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch tabMode {
        case .scrollable:
            let tabSize = CGSize(width: 500, height: self.frame.height)
            let tabTitle = tabs[indexPath.item].title
            
            // Add more space left and right the tab
            var addSpace: CGFloat = 20
            if tabs[indexPath.item].icon != nil {
                // Icon exist, add space for the icon width
                addSpace += 40
            }
            // Calculate the width of the Tab Title string
            let titleWidth = NSString(string: tabTitle).boundingRect(with: tabSize, options: .usesLineFragmentOrigin, attributes: [.font: titleFont], context: nil).size.width
            
            let tabWidth = titleWidth + addSpace
            
            return CGSize(width: tabWidth, height: self.frame.height)
        case .fixed:
            return CGSize(width: self.frame.width / CGFloat(tabs.count), height: self.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
