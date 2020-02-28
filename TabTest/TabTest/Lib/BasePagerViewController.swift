//
//  BasePagerViewController.swift
//  BizTalk iOS
//
//  Created by Daniel Kim on 2020/02/25.
//  Copyright © 2020 wade.hawk. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

//Todo - 뷰가 회전 할때는 고려 하지 않음, 뷰 회전 할때 다시 잡아 주는 동작 필요함.
class BasePagerViewController: BasePagerStripViewController, PagerTabStripDataSource, PagerTabStripIsProgressiveDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    var settings = BasePagerSettings()
    
    var pagerBarItemSpec: PagerBarItemSpec<BasePagerViewCell>!
    
    var changeCurrentIndex: ((_ oldCell: BasePagerViewCell?, _ newCell: BasePagerViewCell?, _ animated: Bool) -> Void)?
    var changeCurrentIndexProgressive: ((_ oldCell: BasePagerViewCell?, _ newCell: BasePagerViewCell?, _ progressPercentage: CGFloat, _ changeCurrentIndex: Bool, _ animated: Bool) -> Void)?
    
    var pagerBar: BasePagerBarView!
    
    lazy private var cachedCellWidths: [CGFloat]? = { [unowned self] in
        return self.calculateWidths()
        }()
    
    override  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
        datasource = self
    }
    
    required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        datasource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagerBarItemSpec = .cellClass(width: { [weak self] (childItemInfo) -> CGFloat in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font =  self?.settings.barStyle.tabItemFont
            label.text = childItemInfo.title
            let labelSize = label.intrinsicContentSize
            return labelSize.width + (self?.settings.barStyle.tabItemLeftRightMargin ?? 8) * 2
        })
        
        let BasePagerBarViewAux = pagerBar ?? {
            let flowLayout = UICollectionViewFlowLayout()
            
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: settings.barStyle.tabLeftContentInset ?? 0, bottom: 0, right: settings.barStyle.tabRightContentInset ?? 0)
            
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = settings.barStyle.tabMinimumInteritemSpacing ?? flowLayout.minimumInteritemSpacing
            flowLayout.minimumLineSpacing = settings.barStyle.tabMinimumLineSpacing ?? flowLayout.minimumLineSpacing
            
            let pagerBar = BasePagerBarView(frame: .zero, collectionViewLayout: flowLayout)
            pagerBar.backgroundColor = .white
            pagerBar.selectedBar.backgroundColor = .black
            pagerBar.autoresizingMask = .flexibleWidth
            
            //후에 바텀라인 지우는거 만들것
            
            let sectionInset = flowLayout.sectionInset
            flowLayout.sectionInset = UIEdgeInsets(top: sectionInset.top, left: settings.barStyle.tabLeftContentInset  ?? sectionInset.left, bottom: sectionInset.bottom, right: settings.barStyle.tabRightContentInset  ?? sectionInset.right)
            return pagerBar
            }()
        pagerBar = BasePagerBarViewAux

        if pagerBar.superview == nil {
            view.addSubview(pagerBar)
            
            pagerBar.translatesAutoresizingMaskIntoConstraints = false
            
              let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
            
            self.view.addConstraint(NSLayoutConstraint(item: pagerBar!, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: pagerBar!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: pagerBar!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.settings.barStyle.tabHeight))
            
            var newContainerViewFrame = containerView.frame
            let pagerBarHeight = self.settings.barStyle.tabHeight ?? 44
            newContainerViewFrame.origin.y = pagerBarHeight + navigationBarHeight
            print("y is \(pagerBarHeight + navigationBarHeight)")
            newContainerViewFrame.size.height = containerView.frame.size.height - (pagerBarHeight + navigationBarHeight + containerView.frame.origin.y)
            containerView.frame = newContainerViewFrame
            
        }
        if pagerBar.delegate == nil {
            pagerBar.delegate = self
        }
        if pagerBar.dataSource == nil {
            pagerBar.dataSource = self
        }
        pagerBar.scrollsToTop = false
        
        
        pagerBar.showsHorizontalScrollIndicator = false
        pagerBar.backgroundColor = settings.barStyle.tabBarBackgroundColor ?? pagerBar.backgroundColor
        pagerBar.selectedBar.backgroundColor = settings.barStyle.selectedBarBackgroundColor
        
        pagerBar.selectedBarHeight = settings.barStyle.selectedBarHeight
        pagerBar.selectedBarVerticalAlignment = settings.barStyle.selectedBarVerticalAlignment
        
        // register button bar item cell
        switch pagerBarItemSpec! {
        case .cellClass:
            pagerBar.register(BasePagerViewCell.self, forCellWithReuseIdentifier:"Cell")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pagerBar.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard isViewAppearing || isViewRotating else { return }
        
        cachedCellWidths = calculateWidths()
        pagerBar.collectionViewLayout.invalidateLayout()
        
        pagerBar.moveTo(index: currentIndex, animated: false, swipeDirection: .none, pagerScroll: .scrollOnlyIfOutOfScreen)
        pagerBar.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: false, scrollPosition: [])
    }
    
    // MARK: -  Methods
    
    override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
        guard isViewLoaded else { return }
        pagerBar.reloadData()
        cachedCellWidths = calculateWidths()
        pagerBar.moveTo(index: currentIndex, animated: false, swipeDirection: .none, pagerScroll: .yes)
    }
    
    func calculateStretchedCellWidths(_ minimumCellWidths: [CGFloat], suggestedStretchedCellWidth: CGFloat, previousNumberOfLargeCells: Int) -> CGFloat {
        var numberOfLargeCells = 0
        var totalWidthOfLargeCells: CGFloat = 0
        
        for minimumCellWidthValue in minimumCellWidths where minimumCellWidthValue > suggestedStretchedCellWidth {
            totalWidthOfLargeCells += minimumCellWidthValue
            numberOfLargeCells += 1
        }
        
        guard numberOfLargeCells > previousNumberOfLargeCells else { return suggestedStretchedCellWidth }
        
        let flowLayout = pagerBar.collectionViewLayout as! UICollectionViewFlowLayout // swiftlint:disable:this force_cast
        let collectionViewAvailiableWidth = pagerBar.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        let numberOfCells = minimumCellWidths.count
        let cellSpacingTotal = CGFloat(numberOfCells - 1) * flowLayout.minimumLineSpacing
        
        let numberOfSmallCells = numberOfCells - numberOfLargeCells
        let newSuggestedStretchedCellWidth = (collectionViewAvailiableWidth - totalWidthOfLargeCells - cellSpacingTotal) / CGFloat(numberOfSmallCells)
        
        return calculateStretchedCellWidths(minimumCellWidths, suggestedStretchedCellWidth: newSuggestedStretchedCellWidth, previousNumberOfLargeCells: numberOfLargeCells)
    }
    
    func updateIndicator(for viewController: BasePagerStripViewController, fromIndex: Int, toIndex: Int) {
        guard shouldUpdateBasePagerBarView else { return }
        pagerBar.moveTo(index: toIndex, animated: false, swipeDirection: toIndex < fromIndex ? .right : .left, pagerScroll: .yes)
        
        if let changeCurrentIndex = changeCurrentIndex {
            let oldIndexPath = IndexPath(item: currentIndex != fromIndex ? fromIndex : toIndex, section: 0)
            let newIndexPath = IndexPath(item: currentIndex, section: 0)
            
            let cells = cellForItems(at: [oldIndexPath, newIndexPath], reloadIfNotVisible: collectionViewDidLoad)
            changeCurrentIndex(cells.first!, cells.last!, true)
        }
    }
    
    func updateIndicator(for viewController: BasePagerStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        guard shouldUpdateBasePagerBarView else { return }
        pagerBar.move(fromIndex: fromIndex, toIndex: toIndex, progressPercentage: progressPercentage, pagerScroll: .yes)
        if let changeCurrentIndexProgressive = changeCurrentIndexProgressive {
            let oldIndexPath = IndexPath(item: currentIndex != fromIndex ? fromIndex : toIndex, section: 0)
            let newIndexPath = IndexPath(item: currentIndex, section: 0)
            
            let cells = cellForItems(at: [oldIndexPath, newIndexPath], reloadIfNotVisible: collectionViewDidLoad)
            changeCurrentIndexProgressive(cells.first!, cells.last!, progressPercentage, indexWasChanged, true)
        }
    }
    
    private func cellForItems(at indexPaths: [IndexPath], reloadIfNotVisible reload: Bool = true) -> [BasePagerViewCell?] {
        let cells = indexPaths.map { pagerBar.cellForItem(at: $0) as? BasePagerViewCell }
        
        if reload {
            let indexPathsToReload = cells.enumerated()
                .compactMap { (arg) -> IndexPath? in
                    let (index, cell) = arg
                    return cell == nil ? indexPaths[index] : nil
            }
            .compactMap { (indexPath: IndexPath) -> IndexPath? in
                return (indexPath.item >= 0 && indexPath.item < pagerBar.numberOfItems(inSection: indexPath.section)) ? indexPath : nil
            }
            
            if !indexPathsToReload.isEmpty {
                pagerBar.reloadItems(at: indexPathsToReload)
            }
        }
        
        return cells
    }
    
    // MARK: - UICollectionViewDelegateFlowLayut
    
    @objc  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        guard let cellWidthValue = cachedCellWidths?[indexPath.row] else {
            fatalError("cachedCellWidths for \(indexPath.row) must not be nil")
        }
        return CGSize(width: cellWidthValue, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != currentIndex else { return }
        
        pagerBar.moveTo(index: indexPath.item, animated: true, swipeDirection: .none, pagerScroll: .yes)
        shouldUpdateBasePagerBarView = false
        
        let oldIndexPath = IndexPath(item: currentIndex, section: 0)
        let newIndexPath = IndexPath(item: indexPath.item, section: 0)
        
        let cells = cellForItems(at: [oldIndexPath, newIndexPath], reloadIfNotVisible: collectionViewDidLoad)
        
        if pagerBehaviour.isProgressiveIndicator {
            if let changeCurrentIndexProgressive = changeCurrentIndexProgressive {
                changeCurrentIndexProgressive(cells.first!, cells.last!, 1, true, true)
            }
        } else {
            if let changeCurrentIndex = changeCurrentIndex {
                changeCurrentIndex(cells.first!, cells.last!, true)
            }
        }
        moveToViewController(at: indexPath.item)
    }
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? BasePagerViewCell else {
            fatalError("UICollectionViewCell should be or extend from BasePagerViewCell")
        }
        
        collectionViewDidLoad = true
        
        let childController = viewControllers[indexPath.item] as! IndicatorInfoProvider // swiftlint:disable:this force_cast
        let indicatorInfo = childController.indicatorInfo(for: self)
        
        cell.label.text = indicatorInfo.title
        cell.label.font = settings.barStyle.tabItemFont
        cell.label.textColor = self.settings.barStyle.tabItemTitleColor ?? cell.label.textColor
        cell.contentView.backgroundColor = self.settings.barStyle.tabItemBackgroundColor ?? cell.contentView.backgroundColor
        cell.backgroundColor = self.settings.barStyle.tabItemBackgroundColor ?? cell.backgroundColor
        
        if pagerBehaviour.isProgressiveIndicator {
            if let changeCurrentIndexProgressive = changeCurrentIndexProgressive {
                changeCurrentIndexProgressive(currentIndex == indexPath.item ? nil : cell, currentIndex == indexPath.item ? cell : nil, 1, true, false)
            }
        } else {
            if let changeCurrentIndex = changeCurrentIndex {
                changeCurrentIndex(currentIndex == indexPath.item ? nil : cell, currentIndex == indexPath.item ? cell : nil, false)
            }
        }
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = indicatorInfo.accessibilityLabel ?? cell.label.text
        cell.accessibilityTraits.insert([.button, .header])
        return cell
    }
    
    // MARK: - UIScrollViewDelegate
    
    override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        super.scrollViewDidEndScrollingAnimation(scrollView)
        
        guard scrollView == containerView else { return }
        shouldUpdateBasePagerBarView = true
    }
    
    func configureCell(_ cell: BasePagerViewCell, indicatorInfo: IndicatorInfoProvider) {
    }
    
    private func calculateWidths() -> [CGFloat] {
        let flowLayout = pagerBar.collectionViewLayout as! UICollectionViewFlowLayout // swiftlint:disable:this force_cast
        let numberOfCells = viewControllers.count
        
        var minimumCellWidths = [CGFloat]()
        var collectionViewContentWidth: CGFloat = 0
        
        for viewController in viewControllers {
            let childController = viewController as! IndicatorInfoProvider // swiftlint:disable:this force_cast
            let indicatorInfo = childController.indicatorInfo(for: self)
            switch pagerBarItemSpec! {
            case .cellClass(let widthCallback):
                let width = widthCallback(indicatorInfo)
                minimumCellWidths.append(width)
                collectionViewContentWidth += width
            }
        }
        
        let cellSpacingTotal = CGFloat(numberOfCells - 1) * flowLayout.minimumLineSpacing
        collectionViewContentWidth += cellSpacingTotal
        
        let collectionViewAvailableVisibleWidth = pagerBar.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        
        if !settings.barStyle.tabItemsShouldFillAvailableWidth || collectionViewAvailableVisibleWidth < collectionViewContentWidth {
            return minimumCellWidths
        } else {
            let stretchedCellWidthIfAllEqual = (collectionViewAvailableVisibleWidth - cellSpacingTotal) / CGFloat(numberOfCells)
            let generalMinimumCellWidth = calculateStretchedCellWidths(minimumCellWidths, suggestedStretchedCellWidth: stretchedCellWidthIfAllEqual, previousNumberOfLargeCells: 0)
            var stretchedCellWidths = [CGFloat]()
            
            for minimumCellWidthValue in minimumCellWidths {
                let cellWidth = (minimumCellWidthValue > generalMinimumCellWidth) ? minimumCellWidthValue : generalMinimumCellWidth
                stretchedCellWidths.append(cellWidth)
            }
            
            return stretchedCellWidths
        }
    }
    
    private var shouldUpdateBasePagerBarView = true
    private var collectionViewDidLoad = false
    
}
