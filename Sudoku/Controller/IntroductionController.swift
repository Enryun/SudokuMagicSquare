//
//  IntroductionController.swift
//  Sudoku
//
//  Created by James Thang on 6/26/20.
//  Copyright © 2020 James Thang. All rights reserved.
//

import UIKit

class IntroductionController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    private let introImageName = ["Intro1", "Intro2", "Intro3", "Intro4", "Intro5", "Intro6", "Intro7", "Intro8"]
    
    private let introLabel = [
        "Golden Rule: Contain number between 1 and 9. Each number only appear once in a row, column, or block.",
        "Using the same Logic, the middle number must be 1. This Strategy rarely works at the Beginning of the Game.",
        "Find the Most appeared number. Here number 8 appears 7 times. There left 2 number 8 at block 6 and block 8.",
        "Using the Golden Rule, we can find the 2 remaining number 8 and an additional number 6.",
        "Next up is number 5. First using Elimination to find them at block 3 and 7. After that then locate it at block 4.",
        "We can't always figure out all the number. Like number 7 can only be sure at block 6 but not at block 7 and 9.",
        "Using the same basic Elimination Process from the Golden Rule on column, row or block. You get the Idea.",
        "Here is the final result. Let's go back to the Challenge."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "IntroCell", bundle: nil), forCellWithReuseIdentifier: "introCell")
        collectionView.isPagingEnabled = true
        
    }
    

    @IBAction func backPress(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        
        pageControl.currentPage = Int(x)/Int(collectionView.frame.width)
    }
    
    @IBAction func previousPress(_ sender: UIButton) {
        let nextIndex = max(pageControl.currentPage - 1, 0)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @IBAction func nextPress(_ sender: UIButton) {
        let nextIndex = min(pageControl.currentPage + 1, introLabel.count - 1)
        let indexPath = IndexPath(item: nextIndex, section: 0)
        pageControl.currentPage = nextIndex
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return introImageName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "introCell", for: indexPath) as! IntroCell
        
        cell.introImage.image = UIImage(named: introImageName[indexPath.item])
        cell.introLabel.text = introLabel[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
