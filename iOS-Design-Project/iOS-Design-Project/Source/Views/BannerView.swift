//
//  BannerView.swift
//  InfiniteScrollView
//
//  Created by aybek can kaya on 17.05.2019.
//  Copyright © 2019 aybek can kaya. All rights reserved.
//

import UIKit

struct BannerViewConfiguration {
    var pagingDuration = 1.0
    var enableSelection = true
}
var Pagenum:Int = 0

class BannerView: UIView , UIScrollViewDelegate{
    private var pageControl = UIPageControl(frame: .zero)
    private let scrollView:UIScrollView = {
        let sc = UIScrollView(frame: .zero)
        sc.translatesAutoresizingMaskIntoConstraints = true
        sc.isPagingEnabled = true
        return sc
    }()
    private var itemAtIndex:((_ bannerView:BannerView , _ index:Int)->(UIView))!
    private var numberOfItems:Int = 0
   
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setUpUI()
        self.insertSubview(pageControl, at: 0)
        self.bringSubviewToFront(pageControl)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(configuration:BannerViewConfiguration? , numberOfItems:Int , itemAtIndex:@escaping ((_ bannerView:BannerView , _ index:Int)->(UIView)) ) {
       self.itemAtIndex = itemAtIndex
        self.numberOfItems = numberOfItems
       reloadScrollView()
    }
    private func reloadScrollView() {
        guard self.numberOfItems > 0 else { return }
        if self.numberOfItems == 1 {
            let firstItem:UIView = self.itemAtIndex(self , 0)
            addViewToIndex(view: firstItem, index: 0)
            scrollView.isScrollEnabled = false
            return
        }
        let firstItem:UIView = self.itemAtIndex(self , 0)
        addViewToIndex(view: firstItem, index: numberOfItems+1)
        
        let lastItem:UIView = self.itemAtIndex(self , numberOfItems-1)
        addViewToIndex(view: lastItem, index: 0)
        for index in 0..<self.numberOfItems {
            let item:UIView = self.itemAtIndex(self , index)
            addViewToIndex(view: item, index: index+1)
        }
        scrollView.contentSize = CGSize(width: CGFloat(numberOfItems+2)*scrollView.frame.size.width, height: scrollView.frame.size.height)
        scrollView.contentOffset = CGPoint(x: self.scrollView.frame.size.width, y: self.scrollView.contentOffset.y)
    }
    
    private func addViewToIndex(view:UIView, index:Int) {
        view.translatesAutoresizingMaskIntoConstraints = true
        scrollView.addSubview(view)
        view.frame = CGRect(x: CGFloat(index)*scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage:Int = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        if currentPage == 0 {
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(numberOfItems), y: scrollView.contentOffset.y)
        }
        else if currentPage == numberOfItems {
            self.scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentOffset.y)
        }
        self.bringSubviewToFront(pageControl)
        self.bringSubviewToFront(pageControl)
        pageControl.currentPage = currentPage-1
   }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        Int(targetContentOffset.pointee.x / scrollView.frame.width)
    }
    
    private func setUpUI() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        scrollView.delegate = self
        self.addSubview(scrollView)
        
        
        scrollView.showsHorizontalScrollIndicator = false
        setupPageControl()
        print("스크롤뷰")
        print(scrollView.frame)

    }
    private func setupPageControl() {

        pageControl.numberOfPages = 6
        pageControl.translatesAutoresizingMaskIntoConstraints = true
        pageControl.currentPageIndicatorTintColor = UIColor.blue
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)
        pageControl.frame = CGRect(x: self.bounds.midX-(pageControl.size(forNumberOfPages: 6).width/4), y: self.frame.size.height-11, width: 0, height:0)
        self.addSubview(pageControl)
        self.bringSubviewToFront(pageControl)
    }
    
}
