//
//  ViewController.swift
//  carousel_Collectionview
//
//  Created by 박성영 on 2021/11/13.
//

import UIKit


//let reuseIdentifier = "Cell"

class ViewController: UIViewController {
    
 
//    var images: [String] = Bundle.main.paths(forResourcesOfType: "png", inDirectory: "Images")

    var images : [UIColor] = [.red,.yellow,.blue,.green,.orange]
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.register(CollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cellIdentifier")
        collectionView.backgroundView = nil
        collectionView.backgroundColor = UIColor.black
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
    }
    
    func photoForIndexPath(_ indexPath: IndexPath) -> UIColor {
        return images[indexPath.row]
    }
    
    
    func reversePhotoArray( startIndex:Int, endIndex:Int){
        if startIndex >= endIndex{
            return
        }
        //swap(&images[startIndex], &images[endIndex])
        images.swapAt(startIndex, endIndex)
        
        reversePhotoArray( startIndex: startIndex + 1, endIndex: endIndex - 1)
    }
    
}


extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! CollectionViewCell
        
        
        cell.backgroundColor = photoForIndexPath(indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("index = ",indexPath)
    }

    
    //원래는  scrollViewDidEndDecelerating 이거 였는데 초기에 뒤로가기가 안돼서 추가하였음
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Calculate where the collection view should be at the right-hand end item
        let fullyScrolledContentOffset:CGFloat = collectionView.frame.size.width * CGFloat(images.count - 1)
        if (scrollView.contentOffset.x >= fullyScrolledContentOffset) {
            
            // user is scrolling to the right from the last item to the ‘fake’ item 1.
            // reposition offset to show the ‘real’ item 1 at the left-hand end of the collection view
            if images.count>2{
                reversePhotoArray( startIndex: 0, endIndex: images.count - 1)
                reversePhotoArray( startIndex: 0, endIndex: 1)
                reversePhotoArray( startIndex: 2, endIndex: images.count - 1)
                let indexPath : IndexPath = IndexPath(row: 1, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            }
        }
        else if (scrollView.contentOffset.x == 0){
            
            if images.count>2{
                reversePhotoArray( startIndex: 0, endIndex: images.count - 1)
                reversePhotoArray( startIndex: 0, endIndex: images.count - 3)
                reversePhotoArray( startIndex: images.count - 2, endIndex: images.count - 1)
                let indexPath : IndexPath = IndexPath(row: images.count - 2, section: 0)
                collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 414, height: 300)
    }
    
}
