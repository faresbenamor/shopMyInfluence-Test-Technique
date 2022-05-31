//
//  BrandCollectionViewCell.swift
//  ShopMyInfluenceTest
//
//  Created by mac on 30/05/2022.
//

import UIKit

class BrandCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var brandLogo: UIImageView!
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
              UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.transform = self.transform.scaledBy(x: 0.95, y: 0.95)
                })
            }
            else {
                UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
                })
            }
        }
    }
}

