//
//  HeaderNavigation.swift
//  Pulse
//
//  Created by Design First Apps on 3/28/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit

public protocol HeaderNavigationDelegate: class {
    func numberOfSections(in headerNavigation: HeaderNavigation) -> Int
    func headerNavigation(_ headerNavigation: HeaderNavigation, numberOfItemsInSection section: Int) -> Int
    func headerNavigation(_ headerNavigation: HeaderNavigation, titleForIndex indexPath: IndexPath) -> String?
    func headerNavigation(_ headerNavigation: HeaderNavigation, changedSelectedIndex indexPath: IndexPath)
}

open class HeaderNavigation: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    public var color: UIColor? {
        get {
            return self.collectionView.backgroundColor
        }
        set {
            UIView.animate(withDuration: 0.1, animations: {
                self.collectionView.backgroundColor = newValue
                self.collectionView.visibleCells.forEach({ (cell) in
                    cell.contentView.backgroundColor = newValue
                })
            })
        }
    }
    open var delegate: HeaderNavigationDelegate?
    private var marker: UIImageView = UIImageView(image: #imageLiteral(resourceName: "WhiteDot"))
    fileprivate var selectedIndex: IndexPath = IndexPath(row: 0, section: 0) {
        didSet {
            guard let cell: HeaderNavigationCell = self.collectionView.cellForItem(at: self.selectedIndex) as? HeaderNavigationCell else {
                print("Attempting to set index out of range. Setting to previous value.")
                self.selectedIndex = oldValue
                return
            }
            self.setSelected(cell: cell, for: self.selectedIndex)
            self.showCellFor(index: self.selectedIndex)
        }
    }
    private(set) var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    private func xibSetup() {
        view = self.loadViewFromNib()
        view.frame = self.bounds
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        self.addSubview(view)
        self.viewLoaded()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "HeaderNavigation", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    private func viewLoaded() {
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        let cell: UINib = UINib(nibName: "HeaderNavigationCell", bundle: Bundle(for: type(of: self)))
        self.collectionView.register(cell, forCellWithReuseIdentifier: "cell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 18)
        self.collectionView.reloadData()
    }
    
    fileprivate func setSelected(cell: HeaderNavigationCell, for indexPath: IndexPath) {
        if self.selectedIndex == indexPath {
            cell.markerHolder.addSubview(self.marker)
        } else {
            cell.markerHolder.subviews.forEach({ (view) in
                view.removeFromSuperview()
            })
        }
    }
    
    private func showCellFor(index: IndexPath) {
        self.collectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
    }
    
    public func reloadTitles() {
        self.collectionView.reloadData()
    }
    
    public func setSelected(index: IndexPath) {
        self.selectedIndex = index
    }
}

extension HeaderNavigation: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = self.delegate?.headerNavigation(self, titleForIndex: indexPath)
        label.sizeToFit()
        let margin: CGFloat = 8.0
        
        return CGSize(width: label.frame.width + (margin * 2), height: self.collectionView.frame.height)
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.delegate?.numberOfSections(in: self) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.delegate?.headerNavigation(self, numberOfItemsInSection: section) ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HeaderNavigationCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HeaderNavigationCell
        cell.contentView.backgroundColor = collectionView.backgroundColor
        cell.label.text = self.delegate?.headerNavigation(self, titleForIndex: indexPath)
        self.setSelected(cell: cell, for: indexPath)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath
        self.delegate?.headerNavigation(self, changedSelectedIndex: indexPath)
    }
}
