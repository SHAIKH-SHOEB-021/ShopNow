//
//  ImageCarouselCollectionViewCell.swift
//  ShopNow
//
//  Created by mayank ranka on 04/07/23.
//

import UIKit
import SDWebImage

class ImageCarouselCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var imagePageControl: UIPageControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadBaseView()
    }
    
    func loadBaseView() {
//        baseView.clipsToBounds = true
//        baseView.layer.cornerRadius = 10.0
//        baseView.layer.borderWidth = 1
//        baseView.layer.borderColor = UIColor.gray.cgColor
    }
    
    func updateCellForProductThumbnail(thumbnailImagemages: String, imageCount: Int) {
        imagePageControl.currentPage = 0
        imagePageControl.numberOfPages = imageCount
        thumbnailImage!.sd_setImage(with: URL(string: thumbnailImagemages))
    }

}
