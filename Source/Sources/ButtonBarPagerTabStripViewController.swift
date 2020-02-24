//  PagerBarTabStripViewController.swift
//
//  Created by Daniel Kim on 2020/02/20.
//  Copyright © 2020 Daniel Kim. All rights reserved.
//

import Foundation
import UIKit

public enum PagerBarItemSpec<CellType: UICollectionViewCell> {
    
    case nibFile(nibName: String, bundle: Bundle?, width:((IndicatorInfo)-> CGFloat))
    case cellClass(width:((IndicatorInfo)-> CGFloat))
    
    
    public var weight: ((IndicatorInfo) -> CGFloat) {
        switch self {
        case .cellClass(let widthCallback):
            return widthCallback
        case .nibFile(_, _, let widthCallback):
            return widthCallback
        }
    }
}



open class PagerBarTabStripViewController: PagerTabStripViewController, PagerTabStripDataSource, PagerTabStripIsProgressiveDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    //
    public var pagerBarBackgroundColor: UIColor?
    public var pagerBarMinimumInteritemSpacing: CGFloat?
    public var pagerBarMinimumLineSpacing: CGFloat?
    public var pagerBarLeftContentInset: CGFloat?
    public var pagerBarRightContentInset: CGFloat?
    
    public var selectedBarBackgroundColor = UIColor.black
    public var selectedBarHeight: CGFloat = 2
    public var selectedBarVerticalAlignment: SelectedBarVerticalAlignment = .bottom
    
    public var pagerBarItemBackgroundColor: UIColor?
    public var pagerBarItemFont = UIFont.systemFont(ofSize: 18)
    public var pagerBarItemLeftRightMargin: CGFloat = 8
    public var pagerBarItemTitleColor: UIColor?
    public var pagerBarItemsShouldFillAvailableWidth = true
    
    public var pagerBarHeight: CGFloat?
    //
    
    //added
    public var pagerBottomBarUnderLine: Bool = false
    public var pagerBottomBarUnderLineColor: UIColor = .white
    public var pagerBottomBarUnderLineHeight: CGFloat = 1
    
    //
    
    public var pagerBarItemSpec: PagerBarItemSpec<PagerBarViewCell>!
    
    public var changeCurrentIndex: ((_ oldCell: PagerBarViewCell?, _ newCell: PagerBarViewCell?, _ animated: Bool) -> Void)?
    public var changeCurrentIndexProgressive: ((_ oldCell: PagerBarViewCell?, _ newCell: PagerBarViewCell?, _ progressPercentage: CGFloat, _ changeCurrentIndex: Bool, _ animated: Bool) -> Void)?
    
    var pagerBar: PagerBarView!
    
    lazy private var cachedCellWidths: [CGFloat]? = { [unowned self] in
        return self.calculateWidths()
        }()
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        delegate = self
        datasource = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        datasource = self
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        pagerBarItemSpec = .cellClass(width: { [weak self] (childItemInfo) -> CGFloat in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = self?.pagerBarItemFont
            label.text = childItemInfo.title
            let labelSize = label.intrinsicContentSize
            return labelSize.width + (self?.pagerBarItemLeftRightMargin ?? 8) * 2
        })
        
        let pagerBarViewAux = pagerBar ?? {
            let flowLayout = UICollectionViewFlowLayout()
            
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: pagerBarLeftContentInset ?? 0, bottom: 0, right: pagerBarRightContentInset ?? 0)
            
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumInteritemSpacing = self.pagerBarMinimumInteritemSpacing ?? flowLayout.minimumInteritemSpacing
            flowLayout.minimumLineSpacing = self.pagerBarMinimumLineSpacing ?? flowLayout.minimumLineSpacing
            
            let pagerBar = PagerBarView(frame: .zero, collectionViewLayout: flowLayout)
            pagerBar.backgroundColor = .white
            pagerBar.selectedBar.backgroundColor = .black
            pagerBar.autoresizingMask = .flexibleWidth

            if self.pagerBottomBarUnderLine == true {
                
            }

            let sectionInset = flowLayout.sectionInset
            flowLayout.sectionInset = UIEdgeInsets(top: sectionInset.top, left: self.pagerBarLeftContentInset ?? sectionInset.left, bottom: sectionInset.bottom, right: self.pagerBarRightContentInset ?? sectionInset.right)
            return pagerBar
        }()
        pagerBar = pagerBarViewAux
        //        CGRect(x: 0, y: 0, width: view.frame.size.width, height: pagerBarHeight)
        
        if pagerBar.superview == nil {
            view.addSubview(pagerBar)
            
            pagerBar.translatesAutoresizingMaskIntoConstraints = false
            
            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
            
            self.view.addConstraint(NSLayoutConstraint(item: pagerBar!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: navigationBarHeight))
            
            self.view.addConstraint(NSLayoutConstraint(item: pagerBar!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
            
            self.view.addConstraint(NSLayoutConstraint(item: pagerBar!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.pagerBarHeight ?? 44))
        
            var newContainerViewFrame = containerView.frame
            let pagerBarHeight = self.pagerBarHeight ?? 44
            newContainerViewFrame.origin.y = pagerBarHeight + navigationBarHeight
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
        pagerBar.backgroundColor = self.pagerBarBackgroundColor ?? pagerBar.backgroundColor
        pagerBar.selectedBar.backgroundColor = self.selectedBarBackgroundColor
        
        pagerBar.selectedBarHeight = self.selectedBarHeight
        pagerBar.selectedBarVerticalAlignment = self.selectedBarVerticalAlignment
        
        // register button bar item cell
        switch pagerBarItemSpec! {
        case .nibFile(let nibName, let bundle, _):
            pagerBar.register(UINib(nibName: nibName, bundle: bundle), forCellWithReuseIdentifier:"Cell")
        case .cellClass:
            pagerBar.register(PagerBarViewCell.self, forCellWithReuseIdentifier:"Cell")
        }
        //-
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pagerBar.layoutIfNeeded()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard isViewAppearing || isViewRotating else { return }
        
        cachedCellWidths = calculateWidths()
        pagerBar.collectionViewLayout.invalidateLayout()
        
        pagerBar.moveTo(index: currentIndex, animated: false, swipeDirection: .none, pagerScroll: .scrollOnlyIfOutOfScreen)
        pagerBar.selectItem(at: IndexPath(item: currentIndex, section: 0), animated: false, scrollPosition: [])
    }
    
    // MARK: - Public Methods
    
    open override func reloadPagerTabStripView() {
        super.reloadPagerTabStripView()
        guard isViewLoaded else { return }
        pagerBar.reloadData()
        cachedCellWidths = calculateWidths()
        pagerBar.moveTo(index: currentIndex, animated: false, swipeDirection: .none, pagerScroll: .yes)
    }
    
    open func calculateStretchedCellWidths(_ minimumCellWidths: [CGFloat], suggestedStretchedCellWidth: CGFloat, previousNumberOfLargeCells: Int) -> CGFloat {
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
    
    open func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int) {
        guard shouldUpdatepagerBarView else { return }
        pagerBar.moveTo(index: toIndex, animated: false, swipeDirection: toIndex < fromIndex ? .right : .left, pagerScroll: .yes)
        
        if let changeCurrentIndex = changeCurrentIndex {
            let oldIndexPath = IndexPath(item: currentIndex != fromIndex ? fromIndex : toIndex, section: 0)
            let newIndexPath = IndexPath(item: currentIndex, section: 0)
            
            let cells = cellForItems(at: [oldIndexPath, newIndexPath], reloadIfNotVisible: collectionViewDidLoad)
            changeCurrentIndex(cells.first!, cells.last!, true)
        }
    }
    
    open func updateIndicator(for viewController: PagerTabStripViewController, fromIndex: Int, toIndex: Int, withProgressPercentage progressPercentage: CGFloat, indexWasChanged: Bool) {
        guard shouldUpdatepagerBarView else { return }
        pagerBar.move(fromIndex: fromIndex, toIndex: toIndex, progressPercentage: progressPercentage, pagerScroll: .yes)
        if let changeCurrentIndexProgressive = changeCurrentIndexProgressive {
            let oldIndexPath = IndexPath(item: currentIndex != fromIndex ? fromIndex : toIndex, section: 0)
            let newIndexPath = IndexPath(item: currentIndex, section: 0)
            
            let cells = cellForItems(at: [oldIndexPath, newIndexPath], reloadIfNotVisible: collectionViewDidLoad)
            changeCurrentIndexProgressive(cells.first!, cells.last!, progressPercentage, indexWasChanged, true)
        }
    }
    
    private func cellForItems(at indexPaths: [IndexPath], reloadIfNotVisible reload: Bool = true) -> [PagerBarViewCell?] {
        let cells = indexPaths.map { pagerBar.cellForItem(at: $0) as? PagerBarViewCell }
        
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
    
    @objc open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        guard let cellWidthValue = cachedCellWidths?[indexPath.row] else {
            fatalError("cachedCellWidths for \(indexPath.row) must not be nil")
        }
        return CGSize(width: cellWidthValue, height: collectionView.frame.size.height)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != currentIndex else { return }
        
        pagerBar.moveTo(index: indexPath.item, animated: true, swipeDirection: .none, pagerScroll: .yes)
        shouldUpdatepagerBarView = false
        
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
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PagerBarViewCell else {
            fatalError("UICollectionViewCell should be or extend from PagerBarViewCell")
        }
        
        collectionViewDidLoad = true
        
        let childController = viewControllers[indexPath.item] as! IndicatorInfoProvider // swiftlint:disable:this force_cast
        let indicatorInfo = childController.indicatorInfo(for: self)
        
        cell.label.text = indicatorInfo.title
        cell.label.font = self.pagerBarItemFont
        cell.label.textColor = self.pagerBarItemTitleColor ?? cell.label.textColor
        cell.contentView.backgroundColor = self.pagerBarItemBackgroundColor ?? cell.contentView.backgroundColor
        cell.backgroundColor = self.pagerBarItemBackgroundColor ?? cell.backgroundColor
        if let image = indicatorInfo.image {
            cell.imageView.image = image
        }
        if let highlightedImage = indicatorInfo.highlightedImage {
            cell.imageView.highlightedImage = highlightedImage
        }
        
        configureCell(cell, indicatorInfo: indicatorInfo)
        
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
    
    open override func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        super.scrollViewDidEndScrollingAnimation(scrollView)
        
        guard scrollView == containerView else { return }
        shouldUpdatepagerBarView = true
    }
    
    open func configureCell(_ cell: PagerBarViewCell, indicatorInfo: IndicatorInfo) {
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
            case .nibFile(_, _, let widthCallback):
                let width = widthCallback(indicatorInfo)
                minimumCellWidths.append(width)
                collectionViewContentWidth += width
            }
        }
        
        let cellSpacingTotal = CGFloat(numberOfCells - 1) * flowLayout.minimumLineSpacing
        collectionViewContentWidth += cellSpacingTotal
        
        let collectionViewAvailableVisibleWidth = pagerBar.frame.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
        
        if !self.pagerBarItemsShouldFillAvailableWidth || collectionViewAvailableVisibleWidth < collectionViewContentWidth {
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
    
    private var shouldUpdatepagerBarView = true
    private var collectionViewDidLoad = false
    
}
