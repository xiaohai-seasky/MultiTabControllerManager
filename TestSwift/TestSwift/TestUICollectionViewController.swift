//
//  TestUICollectionViewController.swift
//  TestSwift
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 apple. All rights reserved.
//

import UIKit

class TestUICollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView:UICollectionView! = nil
    

// MARK: - SystemLifeCycleMethod
    override func viewDidLoad() {
        super.viewDidLoad()

        initCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
// MARK: - MYSelfMethod
    private func initCollectionView() {
        let collectionViewLayout:UICollectionViewFlowLayout! = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        collectionViewLayout.itemSize = CGSize(width: 60, height: 70)
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.headerReferenceSize = CGSize(width: self.view.bounds.width, height: 30)
        collectionViewLayout.footerReferenceSize = CGSize(width: self.view.bounds.width, height: 30)
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout:collectionViewLayout)
        self.view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.scrollEnabled = true
        collectionView.bounces = true
        collectionView.backgroundColor = UIColor.blueColor()
        collectionView.reloadData()
    }
    
    
// MARK: - UICollectionViewDataSource
    
    // required (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    // required (ios 6.0, *) // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    // optional (ios 6.0, *)
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    // optional (ios 6.0, *) // The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
    
    // optional (ios 9.0, *)
    func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // optional (ios 9.0, *)
    func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        
    }
    
// MARK: - UICollectionViewDelegate
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // optional (ios 6.0, *) // called when the user taps on an already-selected item in multi-select mode
    func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // optional (ios 8.0, *)
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // optional (ios 8.0, *)
    func collectionView(collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, atIndexPath indexPath: NSIndexPath) {
        
    }
    
    // These methods provide support for copy/paste actions on cells.
    // All three should be implemented if any are.
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return true
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        
    }
    
    // support for custom transition layout (ios 7.0, *)
    // optional
    func collectionView(collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        var layout: UICollectionViewTransitionLayout!
        return layout
    }
    
    // These Method Is About Focus (ios 9.0, *)
    // optional(ios 9.0, *)
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // optional(ios 9.0, *)
    func collectionView(collectionView: UICollectionView, shouldUpdateFocusInContext context: UICollectionViewFocusUpdateContext) -> Bool {
        return true
    }
    
    // optional(ios 9.0, *)
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
    }
    
    // optional(ios 9.0, *)
    func indexPathForPreferredFocusedViewInCollectionView(collectionView: UICollectionView) -> NSIndexPath? {
        return NSIndexPath()
    }
    
    // optional(ios 9.0, *)
    func collectionView(collectionView: UICollectionView, targetIndexPathForMoveFromItemAtIndexPath originalIndexPath: NSIndexPath, toProposedIndexPath proposedIndexPath: NSIndexPath) -> NSIndexPath {
        return NSIndexPath()
    }
    
    // optional(ios 9.0, *)
    func collectionView(collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return CGPointZero
    }

// MARK: - UICollectionViewDelegateFlowLayout
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeZero
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets()
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeZero
    }
    
    // optional (ios 6.0, *)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeZero
    }

}
