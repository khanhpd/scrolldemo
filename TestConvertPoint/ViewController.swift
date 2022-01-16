//
//  ViewController.swift
//  TestConvertPoint
//
//  Created by Khanh Pham on 1/12/22.
//

import UIKit

protocol ViewControllerDelegate: AnyObject {
    func convertPos(mainView: UIView, scrollView: UIScrollView, atIndex index: Int)
    func changeStatus(text: String)
}

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: ViewControllerDelegate?
    
    var trackingTopRect: CGRect {
        
        return CGRect(x: 0,
                      y: 0,
                      width: tableView.frame.width,
                      height: tableView.frame.height)
    }
    
    var trackingBottomRect: CGRect {

        return CGRect(x: 0,
                      y: tableView.frame.height - (tableView.frame.height * 2 / 3),
                      width: tableView.frame.width,
                      height: tableView.frame.height / 3)
    }
    
    var lastContentOffset: CGFloat = 0
    var playingList: [Int: Bool] = [:]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: "hehe")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 800
    }
}
extension ViewController: UITableViewDelegate {

}

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        lastContentOffset = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("pkhanh_contentOffsetY_\(scrollView.contentOffset.y)")
        let isScrollUp = scrollView.contentOffset.y > lastContentOffset
        let contentOffsetY = abs(scrollView.contentOffset.y)
        let visibleCells = tableView.visibleCells
        
        let targetTopCell = visibleCells
            .filter { trackingTopRect.contains(view.convert($0.bounds, from: $0.contentView)) }
            .first
        if let cell = targetTopCell {
            let indexPath = tableView.indexPath(for: cell)
//            print("pkhanh_top1_\(indexPath?.row ?? 0)")
        }
        
        let targetBottomCell = visibleCells
            .filter { view.convert($0.bounds, from: $0.contentView).contains(trackingBottomRect) }
            .first
        if let cell = targetBottomCell {
            let indexPath = tableView.indexPath(for: cell)
//            print("pkhanh_bottom_\(indexPath?.row ?? 0)")
        }
        
        visibleCells.forEach { cell in
            if let cell = cell as? TestTableViewCell, let indexPath = tableView.indexPath(for: cell) {
                let cellRect = tableView.rectForRow(at: indexPath)
                let superView = tableView.superview
                
                let startY = cellRect.minY + cell.videoView.bounds.height * 2 / 3
                let stopY = cellRect.minY + cell.videoView.bounds.height
                
                let videoVideoConverted = cell.convert(cell.videoView.frame, to: superView)
                let videoIntersect = tableView.frame.intersection(videoVideoConverted)
                let visibleHeight = videoIntersect.height
                
                let previousVideoRow = indexPath.row
                
                if visibleHeight >= cell.videoView.frame.height / 3 {
                    if isScrollUp && visibleCells.count > 1 {
                        if let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: 0)) as? TestTableViewCell {
                            let videoVideoConverted = cell.convert(cell.videoView.frame, to: superView)
                            let videoIntersect = tableView.frame.intersection(videoVideoConverted)
                            let visibleHeight = videoIntersect.height
                            
                            if visibleHeight >= cell.videoView.frame.height / 3 {
                                print("pkhanh_STOPPED_\(indexPath.row - 1)")
                                delegate?.changeStatus(text: "STOPPED")
                            }
                        }
                    } else if !isScrollUp && visibleCells.count > 1 {
                        if let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: 0)) as? TestTableViewCell {
                            let videoVideoConverted = cell.convert(cell.videoView.frame, to: superView)
                            let videoIntersect = tableView.frame.intersection(videoVideoConverted)
                            let visibleHeight = videoIntersect.height
                            
                            if visibleHeight >= cell.videoView.frame.height / 3 {
                                print("pkhanh_STOPPED_\(indexPath.row + 1)")
                                delegate?.changeStatus(text: "STOPPED")
                            }
                        }
                    }
                    delegate?.changeStatus(text: "PLAYING")
                    print("pkhanh_PLAYING_\(indexPath.row)")
                } else if visibleHeight == 0 {
                    print("pkhanh_RELEASE_\(indexPath.row)")
                } else {
                    delegate?.changeStatus(text: "STOPPED")
                    print("pkhanh_STOPPED_\(indexPath.row)")
                }
                
                //                if visibleHeight < cell.videoView.frame.height / 3 {
//                    delegate?.changeStatus(text: "STOPPED")
//                    print("pkhanh_STOPPED_\(indexPath.row)")
//                } else if stopY < contentOffsetY {
//                    delegate?.changeStatus(text: "RELEASE")
//                    print("pkhanh_RELEASE_\(indexPath.row)")
//                } else if visibleHeight >= cell.videoView.frame.height / 3 {
//                    if isScrollUp {
//                        if let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row - 1, section: 0)) as? TestTableViewCell {
//                            print("pkhanh_STOPPED_\(indexPath.row - 1)")
//                            delegate?.changeStatus(text: "STOPPED")
//                        }
//                    } else {
//                        if let cell = tableView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: 0)) as? TestTableViewCell {
//                            print("pkhanh_STOPPED_\(indexPath.row + 1)")
//                            delegate?.changeStatus(text: "STOPPED")
//                        }
//                    }
//                    delegate?.changeStatus(text: "PLAYING")
//                    print("pkhanh_PLAYING_\(indexPath.row)")
//                }
                
//                if visibleHeight > cell.videoView.frame.height / 3 {
//                    if isScrollUp && indexPath.last ?? 0 % 2 == 1 ||
//                        isScrollUp && indexPath.first == 0 {
//                        delegate?.changeStatus(text: "PLAYING")
//                    } else if !isScrollUp && indexPath.first ?? 0 % 2 == 0 {
//                        delegate?.changeStatus(text: "PLAYING")
//                    } else {
//                        delegate?.changeStatus(text: "STOPPED")
//                    }
//                }
//                else if isScrollUp && cellRect.height < contentOffsetY {
//                    print("pkhanh_release_\(indexPath.row)")
//                    delegate?.changeStatus(text: "RELEASE")
//                } else {
//                    delegate?.changeStatus(text: "STOPPED")
//                }
            }
        }
//        for(UITableViewCell *cell in [tblMessages visibleCells])
//            {
//                if([cell isKindOfClass:[VideoMessageCell class]])
//                {
//                    NSIndexPath *indexPath = [tblMessages indexPathForCell:cell];
//                    CGRect cellRect = [tblMessages rectForRowAtIndexPath:indexPath];
//                    UIView *superview = tblMessages.superview;
//
//                    CGRect convertedRect=[tblMessages convertRect:cellRect toView:superview];
//                    CGRect intersect = CGRectIntersection(tblMessages.frame, convertedRect);
//                    float visibleHeight = CGRectGetHeight(intersect);
//
//                    if(visibleHeight>VIDEO_CELL_SIZE*0.6) // only if 60% of the cell is visible
//                    {
//                        // unmute the video if we can see at least half of the cell
//                        [((VideoMessageCell*)cell) muteVideo:!btnMuteVideos.selected];
//                    }
//                    else
//                    {
//                        // mute the other video cells that are not visible
//                        [((VideoMessageCell*)cell) muteVideo:YES];
//                    }
//                }
//            }
        
//
        
        
        /* Solution 1
        if visibleCells.count > 0, let cell = visibleCells[0] as? TestTableViewCell {
            let targetCell = view.convert(cell.videoView.frame, from: cell.contentView)//.contains(trackingTopRect)
            let topRect = CGRect(x: 0,
                                 y: 0,
                                 width: cell.videoView.frame.width,
                                 height: cell.videoView.frame.height * 1 / 3)
            let target1 = targetCell.contains(topRect)
            if target1 {
                let indexPath = tableView.indexPath(for: cell)
                print("pkhanh_top_play \(indexPath?.row ?? 0)")
            } else {
                let indexPath = tableView.indexPath(for: cell)
                print("pkhanh_top_stop \(indexPath?.row ?? 0)")
            }
        }
        
        if visibleCells.count > 1, let cell = visibleCells[1] as? TestTableViewCell {
            let targetCell = view.convert(cell.videoView.frame, from: cell.contentView)//.contains(trackingTopRect)
            let bottomRect = CGRect(x: 0,
                                 y: tableView.frame.height - (tableView.frame.height * 1 / 3),
                                 width: cell.videoView.frame.width,
                                 height: cell.videoView.frame.height * 1 / 3)
            let target1 = targetCell.contains(bottomRect)
            if target1 {
                let indexPath = tableView.indexPath(for: cell)
                print("pkhanh_top_play \(indexPath?.row ?? 0)")
            } else {
                let indexPath = tableView.indexPath(for: cell)
                print("pkhanh_top_stop \(indexPath?.row ?? 0)")
            }
        }
        End solution 1 */
        
//        CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
//              CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
//              NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
//              NSLog(@"%@",visibleIndexPath);
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "hehe", for: indexPath) as? TestTableViewCell else {
            return UITableViewCell()
        }
        let topText = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
        let bottomText = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
        cell.configure(topTitle: topText, title: "Indexpath \(indexPath.row)\n \(bottomText)", vc: self)
        return cell
    }
}
