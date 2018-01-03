//
//  DiscoverySpotlightHeaderView.swift
//  DiscoverySpotlight
//
//  Created by Jason Hughes on 6/30/17.
//  Copyright © 2017 1976 LLC. All rights reserved.
//

import UIKit

enum DiscoverSpotlightPageDirection{
    case left
    case right
}

class DiscoverySpotlightHeaderView: UICollectionReusableView {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!
    
    let scrollViewContentView = UIView.init(frame: .zero)

    /// array of models used to populate scrollView cells
    var data:Array<DiscoverySpotlightCellModel> = []
    
    /// store the scrollViews cells in a array in order to keep track of their initial index because we will be manipulating the cell indexs within the scrollView
    var cells:Array<DiscoverySpotlightHeaderCell> = []
    
    var currentIndex = 0
    var pageStartPosition:CGFloat = 0
    var isPaging = false
    
    var timer = Timer()
    
    //MARK: Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView.delegate = self
        self.setupscrollViewContentView()
    }
    
    //MARK: Setup
    func setupscrollViewContentView() {
        self.scrollViewContentView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.scrollViewContentView)
        
        self.scrollViewContentView.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor).isActive = true
        self.scrollViewContentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.scrollViewContentView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        self.scrollViewContentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor).isActive = true
    }
    
    
    /// Initialize and setup DiscoverySpotlightHeaderCell
    ///
    /// - Parameters:
    ///   - index: index position the view should be added at
    ///   - withCellModel: model to be used to populate cell
    func setupScrollViewCell(for index:Int, withCellModel cellModel:DiscoverySpotlightCellModel) {
        
        guard let cell = Bundle.main.loadNibNamed("DiscoverySpotlightHeaderCell", owner: self, options: nil)?.first as? DiscoverySpotlightHeaderCell else {
            return
        }
        
        let colors:Array<UIColor> = [.red, .green, .blue, .gray, .yellow]
        
        cell.translatesAutoresizingMaskIntoConstraints = false
        cell.backgroundColor = colors[index]
        cell.update(with: cellModel)
        
        self.scrollViewContentView.addSubview(cell)
        
        cell.leftConstraint = cell.leftAnchor.constraint(equalTo: self.scrollViewContentView.leftAnchor, constant: CGFloat(index) * self.scrollView.bounds.size.width)
        
        cell.leftConstraint?.isActive = true
        
        cell.topAnchor.constraint(equalTo: self.scrollViewContentView.topAnchor).isActive = true
        cell.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor).isActive = true
        cell.bottomAnchor.constraint(equalTo: self.scrollViewContentView.bottomAnchor).isActive = true
       
        self.cells.append(cell)
    
    }
    
    
    /// Initialize stackview cell and add it to stackview
    func setupStackViewCell(){
        let stackViewCell = DiscoverySpotlightStackViewCell.init(frame: .zero)
        stackViewCell.backgroundColor = .gray
        
        self.stackView.addArrangedSubview(stackViewCell)
    }
    
    /// setup all header cells and stackview cells, setup contentsize and call reset method to set everything to the default state
    ///
    /// - Parameter data: array of models to be used to setup header cells
    func setup(with data:Array<DiscoverySpotlightCellModel>) {
        // force layout so that all constraints get translated to bounds
        self.reset();
        
        self.layoutIfNeeded()

        self.data = data;
        
        var i = 0;
        
        for cellModel in self.data {
            
            self.setupScrollViewCell(for: i, withCellModel: cellModel)
            self.setupStackViewCell()
            
            i += 1
        }
        
        self.scrollView.contentSize = CGSize.init(width: self.scrollView.bounds.size.width * CGFloat(self.data.count), height: self.scrollView.bounds.size.height)
        
        self.resetLayout()
        
        if self.data.count == 1 {
            self.stackView.isHidden = true
        } else {
            self.stackView.isHidden = false
            self.startTimer();
        }
        
    }
    
    //MARK: Public Methods
    func reset() {
        
        while self.scrollViewContentView.subviews.count > 0 {
            self.scrollViewContentView.subviews.first?.removeFromSuperview()
        }
        
        while self.stackView.arrangedSubviews.count > 0 {
            self.stackView.arrangedSubviews.first?.removeFromSuperview()
        }
        
        self.data = []
        self.cells = []
        
        self.currentIndex = 0
        self.pageStartPosition = 0
        self.isPaging = false
        
        self.stopTimer()
        
        self.resetLayout()
        
    }
    
    /// reset the view and its children to the default layout state
    func resetLayout() {
        self.currentIndex = 0;
        
        var i = 0;
        
        for stackViewCell in self.stackView.arrangedSubviews {
            
            if let stackViewCell = stackViewCell as? DiscoverySpotlightStackViewCell {
                if i == self.currentIndex {
                    stackViewCell.updateColorViewWidthConstraint(with: 1)
                } else {
                    stackViewCell.updateColorViewWidthConstraint(with: 0)
                }
            }
            
            i += 1
        }
        
        self.scrollView.scrollRectToVisible(CGRect.init(x: 0, y: 0, width: self.scrollView.bounds.size.width, height: self.scrollView.bounds.size.height), animated: false)
        
    }
    
    func startTimer() {
        self.timer.invalidate()
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true, block: { (blockTimer) in
            let nextScrollPositionX = self.scrollView.contentOffset.x + self.scrollView.bounds.size.width
            
            self.scrollView.isUserInteractionEnabled = false
            self.scrollView.setContentOffset(CGPoint.init(x: nextScrollPositionX, y: 0), animated: true)
        })
    }
    
    func stopTimer() {
        self.timer.invalidate()
    }
    
    
    /// Advances the a index + 1 in either .right or .left direction
    ///
    /// - Parameters:
    ///   - index: index that should be incremented
    ///   - withDirection: direction index should be incremented in .right or .left
    /// - Returns: returns a int that is 1 great or 1 less than the index
    func advance(index:Int, withDirection:DiscoverSpotlightPageDirection) ->Int {
        var index = index
        
        if withDirection == .left {
            index -= 1
            
            if index < 0 {
                index = self.cells.count - 1
            }
            
        } else {
            index += 1
            
            if index >= self.cells.count {
                index = 0;
            }
        }
        
        return index
    }
    
    
    /// Checks to see if the cell at the current index is visibile on the screen
    ///
    /// - Returns: true or false
    func isCellForCurrentIndexVisible() -> Bool {
        
        let cell = self.cells[self.currentIndex]
        let scrollFrame = CGRect.init(x: self.scrollView.contentOffset.x, y: 0, width: self.scrollView.bounds.size.width, height: self.scrollView.bounds.size.height)
        
        let isVisible = cell.frame.intersects(scrollFrame)
    
        return isVisible
    }
    

    /// Updates the header cell layout based on the scrollviews contentOffset
    func updateHeaderCellLayout() {
        let scrollPositionX:CGFloat = self.scrollView.contentOffset.x
        let maxScrollPosition:CGFloat = self.scrollView.contentSize.width - self.scrollView.bounds.size.width
        let minScrollPosition:CGFloat = 0
        
        // if the scrollPositionX > maxScrollPosition we need to bring the first cell
        // to the front which will add it to the end of the scrollViewContentView subview array
        // we then reset the left constraints of all the cells based on their new position 
        // in the subviews array. Then we set the scrollviews contentOffset.x position to 
        // show the second to last cell which gives us the illusion of a endless carousel
        if scrollPositionX > maxScrollPosition {
            let view = self.scrollViewContentView.subviews.first!
            
            self.scrollViewContentView.bringSubview(toFront: view)
            
            var i = 0
            
            for subview in self.scrollViewContentView.subviews {
                if let subview = subview as? DiscoverySpotlightHeaderCell {
                    subview.leftConstraint?.constant = CGFloat(i) * self.scrollView.bounds.size.width
                }
                
                i += 1
            }
            
            scrollView.contentOffset.x = scrollPositionX - self.scrollView.bounds.size.width
            
        } else if scrollPositionX < minScrollPosition {
            // if the scrollPositionX < maxScrollPosition do the same as outlined above 
            // but place the last subview in the first position of the subviews array
            // and set the scrollviews contentOffset.x to show the
            let view = self.scrollViewContentView.subviews.last!
            self.scrollViewContentView.sendSubview(toBack: view)
            
            var i = 0
            
            for subview in self.scrollViewContentView.subviews {
                if let subview = subview as? DiscoverySpotlightHeaderCell {
                    subview.leftConstraint?.constant = CGFloat(i) * self.scrollView.bounds.size.width
                }
                i += 1
            }
            
            scrollView.contentOffset.x = self.scrollView.bounds.size.width
        }
    }
    
    /// Updates the stackview cell layout based on the scrollview position
    func updateStackViewCellLayout() {
        
        if self.cells.count == 0 {
            return
        }
        
        let scrollPositionX:CGFloat = scrollView.contentOffset.x
        let nextIndex = self.advance(index: self.currentIndex, withDirection: self.scrollViewScrollDirection(scrollView));
        
        self.layoutIfNeeded()
        
        // Get the scroll percentage for the next Cell 0 - 1
        let scrollPercentageNext =  1 - (abs(self.cells[nextIndex].leftConstraint!.constant - scrollPositionX) / scrollView.bounds.size.width)
        
        // Get the scroll percentage for the current cell 1 - 0
        let scrollPercentageCurrent = 1 - (abs(self.cells[self.currentIndex].leftConstraint!.constant - scrollPositionX) / scrollView.bounds.size.width)
 
        if self.isPaging {
            
            if let currentStackCell = self.stackView.arrangedSubviews[self.currentIndex] as? DiscoverySpotlightStackViewCell {
                currentStackCell.updateColorViewWidthConstraint(with: abs(scrollPercentageCurrent))
                
                if self.scrollViewScrollDirection(self.scrollView) == .right {
                    currentStackCell.enableRightConstraint()
                } else {
                    currentStackCell.enableLeftConstraint()
                }
            }
            
            if let nextStackCell = self.stackView.arrangedSubviews[nextIndex] as? DiscoverySpotlightStackViewCell {
                nextStackCell.updateColorViewWidthConstraint(with: abs(scrollPercentageNext))
                
                if self.scrollViewScrollDirection(self.scrollView) == .right {
                    nextStackCell.enableLeftConstraint()
                } else {
                    nextStackCell.enableRightConstraint()
                }
            }
        }
    }
    
}

// ScrollView Delegate
extension DiscoverySpotlightHeaderView: UIScrollViewDelegate {
    
    func scrollViewScrollDirection(_ scrollView:UIScrollView) ->DiscoverSpotlightPageDirection {
        
        return scrollView.contentOffset.x > self.pageStartPosition ? .right : .left
        
    }
    
    func scrollViewDidEndScrolling(_ scrollView:UIScrollView) {
        if self.isPaging {
            
            if !self.isCellForCurrentIndexVisible() {
                self.currentIndex = self.advance(index: self.currentIndex, withDirection: self.scrollViewScrollDirection(scrollView))
            }
            
            for stackViewCell in self.stackView.arrangedSubviews {
                if let stackViewCell = stackViewCell as? DiscoverySpotlightStackViewCell {
                    if stackViewCell != self.stackView.arrangedSubviews[self.currentIndex]  {
                        stackViewCell.updateColorViewWidthConstraint(with: 0)
                    } else {
                        stackViewCell.updateColorViewWidthConstraint(with: 1)
                    }
                }
            }
            
            self.isPaging = false
            self.pageStartPosition = 0
            
            self.startTimer()
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopTimer()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let scrollPositionX:CGFloat = scrollView.contentOffset.x

        self.updateHeaderCellLayout()
        self.updateStackViewCellLayout()
        
        if !self.isPaging {
            self.isPaging = true;
            self.pageStartPosition = scrollPositionX
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidEndScrolling(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.scrollView.isUserInteractionEnabled = true
        self.scrollViewDidEndScrolling(scrollView)
    }
}
