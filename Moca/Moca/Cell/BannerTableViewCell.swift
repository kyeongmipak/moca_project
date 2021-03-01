//
//  BannerTableViewCell.swift
//  Moca
//
//  Created by 박경미 on 2021/03/01.
//

import UIKit

class BannerTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {    
    
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var bannerPageControl: UIPageControl!
    
    // 현재페이지 체크 변수 (자동 스크롤할 때 필요)
    var nowPage: Int = 0

    // 배너 이미지 배열
    let imageArray: Array<UIImage> = [UIImage(named: "banner01.png")!, UIImage(named: "banner02.png")!, UIImage(named: "banner03.png")!]
    
    
    //------------------------------------
    var timer = Timer()
    var counter = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //------------------------------------
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        //------------------------------------
        
        // page control
        bannerPageControl.numberOfPages = imageArray.count
        bannerPageControl.currentPage = 0

        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // timer objc
    @objc func changeImage(){
        if counter < imageArray.count {
       
            let index = IndexPath.init(item: counter, section: 0)
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
  
            bannerPageControl.currentPage = counter
            counter += 1
        
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.bannerCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            bannerPageControl.currentPage = counter
            counter = 1
        }
        
    }
    
    // 컬렉션뷰 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    // 컬렉션뷰 셀 설정
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCollectionViewCell
       
                cell.bannerImgView.image = imageArray[indexPath.row]
                return cell
    }
    
    // UICollectionViewDelegateFlowLayout 상속
    //컬렉션뷰 사이즈 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bannerCollectionView.frame.size.width  , height:  bannerCollectionView.frame.height)

    }
    
    // 배너 스와이프 시
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageFloat = (scrollView.contentOffset.x / scrollView.frame.size.width)
           let pageInt = Int(round(pageFloat))
            bannerPageControl.currentPage = pageInt

    }

    
}
