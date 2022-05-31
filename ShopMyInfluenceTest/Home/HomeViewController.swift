//
//  HomeViewController.swift
//  ShopMyInfluenceTest
//
//  Created by mac on 29/05/2022.
//

import UIKit
import FirebaseDatabase
import Kingfisher


class HomeViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var leadingUnderline: NSLayoutConstraint!
    @IBOutlet weak var brandCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let database = Database.database().reference()
    var brandsArray = [Brand]()
    var brandsArrayFiltred = [Brand]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customSegmentedControl()
        getData()
    }
    
    func customSegmentedControl() {
        segmentedControl.backgroundColor = .white
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.label], for: .normal)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.customBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)], for: .selected)
        segmentedControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentedControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    func getData() {
        database.child("brands").observeSingleEvent(of: .value, with: { snapshot in
            
            for brands in snapshot.children.allObjects as! [DataSnapshot] {
                let brandObj = brands.value as? [String : Any]
                let id = brandObj?["offerId"] as? Int
                let name = brandObj?["name"] as? String
                let description = brandObj?["description"] as? String
                let picture = brandObj?["pic"] as? String
                let premium = brandObj?["premium"] as? Int
                let isNew = brandObj?["isNew"] as? Int
                
                let brand = Brand(offerId: id, name: name, description: description, pic: picture, premium: premium, isNew: isNew)
                
                self.brandsArray.append(brand)
            }
            DispatchQueue.main.async { [unowned self] in
                brandsArrayFiltred = brandsArray.filter {$0.premium == 1}
                activityIndicator.stopAnimating()
                brandCollectionView.reloadData()
            }
        })
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        brandsArrayFiltred = brandsArrayFiltred.filter { $0.name == searchBar.text?.lowercased() }
        brandCollectionView.reloadData()
    }

    @IBAction func segmentedClick(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            brandsArrayFiltred = brandsArray.filter {$0.premium == 1}
            leadingUnderline.constant = 0
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            brandCollectionView.reloadData()
        }
        else {
            brandsArrayFiltred = brandsArray
            leadingUnderline.constant = segmentedControl.frame.width / 2
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
            })
            brandCollectionView.reloadData()
        }
    }
}

// MARK: CollectionView DataSource and Delegate

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandsArrayFiltred.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = brandCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! BrandCollectionViewCell
        
        cell.brandLogo.layer.cornerRadius = 20
        
        // Convert from URL String to Image with KingFisher
        if let imageURL = brandsArrayFiltred[indexPath.item].pic {
            let url = URL(string : imageURL)
            cell.brandLogo.kf.setImage(with: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetails" {
            let indexPath = brandCollectionView.indexPathsForSelectedItems?.first?.item
            let detailsItem = segue.destination as? DetailsViewController
            detailsItem?.brandDetail = brandsArrayFiltred[indexPath!]
        }
    }
    
    // MARK: CollectionView DelegateFlowLayout
    
     // Show 3 cells per row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 4

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }

    // Space between rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
}

extension UIColor {
    public static var customBlue = UIColor(red: 0.10, green: 0.71, blue: 0.89, alpha: 1.00)
}
