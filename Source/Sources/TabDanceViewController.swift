//
//  TabDanceViewController.swift
//  TabDance
//
//  Created by Daniel Kim on 2020/02/24.
//  Copyright © 2020 Daniel Kim. All rights reserved.
//

import Foundation
import UIKit



//Settings

    //Todo - 뷰가 회전 할때는 고려 하지 않음, 뷰 회전 할때 다시 잡아 주는 동작 필요함.
open class TabDanceViewController: UIPageViewController {
    
    // Attributes
    internal var isViewAppearing = false
    internal var isViewRotating = false
    private var shouldUpdatepagerBarView = true
    private var collectionViewDidLoad = false
    

    private var lastContentOffset: CGFloat = 0.0
    private var pageBeforeRotate = 0
    private var lastSize = CGSize(width: 0, height: 0)

    
    public var pagerBarItemSpec: PagerBarItemSpec<PagerBarViewCell>!
    
    public var settings = TabDanceSettings()
    
    
    var pendingPage:Int?
    var presentIndex = 0
    var presentVisibleIndex:Int {
        get {
            return self.presentIndex
        }
        set {
            presentIndex = newValue
            print("index change \(presentIndex)")
        }
    }
    
    open lazy var arrViewControllers = [UIViewController]()
    
    // Views
    var pagerBar: PagerBarView!
    
    
    public var changeCurrentIndex: ((_ oldCell: PagerBarViewCell?, _ newCell: PagerBarViewCell?, _ animated: Bool) -> Void)?
    
    public var changeCurrentIndexProgressive: ((_ oldCell: PagerBarViewCell?, _ newCell: PagerBarViewCell?, _ progressPercentage: CGFloat, _ changeCurrentIndex: Bool, _ animated: Bool) -> Void)?
    
    open var pagerBehaviour = PagerTabStripBehaviour.progressive(skipIntermediateViewControllers: true, elasticIndicatorLimit: true)
    
    
    lazy private var cachedCellWidths: [CGFloat]? = { [unowned self] in
        return self.calculateWidths()
        }()
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: options)
    }
    
    required public init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setStyling()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pagerBar.layoutIfNeeded()
        isViewAppearing = true
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isViewAppearing = false
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("view Did Layout Subvies")
        
        guard isViewAppearing else { return }

        cachedCellWidths = calculateWidths()
        pagerBar.collectionViewLayout.invalidateLayout()
        
        pagerBar.moveTo(index: presentVisibleIndex, animated: false, pagerScroll: .scrollOnlyIfOutOfScreen)
        pagerBar.selectItem(at: IndexPath(item: presentVisibleIndex, section: 0), animated: false, scrollPosition: [])
    }
    
    func setViews() {
        settingViewFrame()
        settingPagerBar()
    }
    
    func setStyling() {
        self.view.backgroundColor = self.settings.contentStyle.contentViewBackgroundColor
        pagerBar.backgroundColor = .white
        pagerBar.selectedBar.backgroundColor = .black
        pagerBar.autoresizingMask = .flexibleWidth
        pagerBar.bounces = settings.barStyle.pagerBounce
        pagerBar.showsHorizontalScrollIndicator = false
        pagerBar.backgroundColor = self.settings.barStyle.tabDanceBarBackgroundColor ?? pagerBar.backgroundColor
        pagerBar.selectedBar.backgroundColor = self.settings.barStyle.selectedBarBackgroundColor
        
        pagerBarItemSpec = .cellClass(width: { [weak self] (childItemInfo) -> CGFloat in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = self!.settings.barStyle.tabDanceItemFont
            label.text = childItemInfo.title
            let labelSize = label.intrinsicContentSize
            return labelSize.width + (self?.settings.barStyle.tabDanceItemLeftRightMargin ?? 8) * 2
        })
    }
    

    
    private func settingViewFrame() {
        let naviHeight:CGFloat = 100
        let frame = CGRect(x: 0, y:  self.settings.barStyle.tabDanceHeight + naviHeight, width: self.view.bounds.width, height: self.view.bounds.width -  self.settings.barStyle.tabDanceHeight - naviHeight)
        self.view.frame = frame
    }
    
    private func settingPagerBar() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: self.settings.barStyle.tabDanceLeftContentInset , bottom: 0, right: self.settings.barStyle.tabDanceRightContentInset )
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = self.settings.barStyle.tabDanceMinimumInteritemSpacing ?? flowLayout.minimumInteritemSpacing
        flowLayout.minimumLineSpacing = self.settings.barStyle.tabDanceMinimumLineSpacing ?? flowLayout.minimumLineSpacing
        
        pagerBar = PagerBarView(frame: .zero, collectionViewLayout: flowLayout)
        view.addSubview(pagerBar)
        
        pagerBar.translatesAutoresizingMaskIntoConstraints = false
        
        //            let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        
        let navigationBarHeight = self.navigationController?.navigationBar.frame.height ?? 0.0
        //
        //            self.view.frame = CGRect(x: 0, y: navigationBarHeight, width: self.view.frame.width, height: self.view.bounds.height - navigationBarHeight)
        
        
        self.view.addConstraint(NSLayoutConstraint(item: pagerBar!, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: pagerBar!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0))
        
        self.view.addConstraint(NSLayoutConstraint(item: pagerBar!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: self.settings.barStyle.tabDanceHeight))
        
        pagerBar.delegate = self
        pagerBar.dataSource = self
        
        pagerBar.selectedBarHeight = self.settings.barStyle.selectedBarHeight
        pagerBar.selectedBarVerticalAlignment = self.settings.barStyle.selectedBarVerticalAlignment
        
        pagerBar.register(PagerBarViewCell.self, forCellWithReuseIdentifier:"Cell")
    }
}

extension TabDanceViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: - Public Methods
    
    open func moveToViewController(at index: Int, animated: Bool = true) {
        
        let selectedVC = arrViewControllers[index]
        
        setViewControllers([selectedVC], direction: index > self.presentIndex ? .forward : .reverse, animated: true, completion: nil)
        
        presentIndex = index
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
    
    @objc open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let cellWidthValue = cachedCellWidths?[indexPath.row] else {
            fatalError("cachedCellWidths for \(indexPath.row) must not be nil")
        }
        return CGSize(width: cellWidthValue, height: collectionView.frame.size.height)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item != settings.contentStyle.currentIndex else { return }
        
        pagerBar.moveTo(index: indexPath.item, animated: true, pagerScroll: .yes)
        shouldUpdatepagerBarView = false
        
        let oldIndexPath = IndexPath(item: settings.contentStyle.currentIndex, section: 0)
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
        return arrViewControllers.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? PagerBarViewCell else {
            fatalError("UICollectionViewCell should be or extend from PagerBarViewCell")
        }
        
        collectionViewDidLoad = true
        
        let childController = arrViewControllers[indexPath.item] as! IndicatorInfoProvider // swiftlint:disable:this force_cast
        let indicatorInfo = childController.indicatorInfo(for: self)
        
        cell.label.text = indicatorInfo.title
        cell.label.font = self.settings.barStyle.tabDanceItemFont
        cell.label.textColor = self.settings.barStyle.tabDanceItemTitleColor ?? cell.label.textColor
        cell.contentView.backgroundColor = self.settings.barStyle.tabDanceBarBackgroundColor ?? cell.contentView.backgroundColor
        cell.backgroundColor = self.settings.barStyle.tabDanceItemBackgroundColor ?? cell.backgroundColor
        if let image = indicatorInfo.image {
            cell.imageView.image = image
        }
        if let highlightedImage = indicatorInfo.highlightedImage {
            cell.imageView.highlightedImage = highlightedImage
        }
        
        if pagerBehaviour.isProgressiveIndicator {
            if let changeCurrentIndexProgressive = changeCurrentIndexProgressive {
                changeCurrentIndexProgressive(settings.contentStyle.currentIndex == indexPath.item ? nil : cell, settings.contentStyle.currentIndex == indexPath.item ? cell : nil, 1, true, false)
            }
        } else {
            if let changeCurrentIndex = changeCurrentIndex {
                changeCurrentIndex(settings.contentStyle.currentIndex == indexPath.item ? nil : cell, settings.contentStyle.currentIndex == indexPath.item ? cell : nil, false)
            }
        }
        cell.isAccessibilityElement = true
        cell.accessibilityLabel = indicatorInfo.accessibilityLabel ?? cell.label.text
        cell.accessibilityTraits.insert([.button, .header])
        return cell
    }
    
}


extension TabDanceViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let page = pendingPage else {
            return
        }
        self.presentVisibleIndex = page
        pagerBar.moveTo(index: page, animated: true, pagerScroll: .yes)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingPage = self.arrViewControllers.firstIndex(of: pendingViewControllers.first!)
    }
    
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore PageViewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = arrViewControllers.firstIndex(of: PageViewController) else {
            return nil
        }
        
        let previousIndex = vcIndex - 1
        
        guard previousIndex >= 0 else {
            return arrViewControllers.last
        }
        
        return arrViewControllers[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter PageViewController: UIViewController) -> UIViewController? {
        guard let vcIndex = arrViewControllers.firstIndex(of: PageViewController) else {
            return nil
        }
        
        guard arrViewControllers.count != (vcIndex + 1) else {
            return arrViewControllers.first
        }
        
        guard arrViewControllers.count > (vcIndex + 1) else {
            return nil
        }
        
        return arrViewControllers[vcIndex + 1]
    }
}


// MARK - Helpers, CaculateWidth
extension TabDanceViewController {
    
    private func calculateWidths() -> [CGFloat] {
        let flowLayout = pagerBar.collectionViewLayout as! UICollectionViewFlowLayout // swiftlint:disable:this force_cast
        let numberOfCells = arrViewControllers.count
        
        var minimumCellWidths = [CGFloat]()
        var collectionViewContentWidth: CGFloat = 0
        
        for viewController in arrViewControllers {
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
        
        if !self.settings.barStyle.tabDanceItemsShouldFillAvailableWidth || collectionViewAvailableVisibleWidth < collectionViewContentWidth {
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
}
