//
//  DetailsViewController.swift
//  ShopMyInfluenceTest
//
//  Created by mac on 31/05/2022.
//

import UIKit
import Kingfisher
import FirebaseDatabase

class DetailsViewController: UIViewController {

    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var nameBrand: UILabel!
    @IBOutlet weak var descriptionBrand: UILabel!
    @IBOutlet weak var purchaseTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let imagesDetail = ["eurosign.circle.fill", "money-bag", "sale"]
    let subTitles = ["Chiffre d'affaire", "Commissions", "Nombres de ventes"]
    private let database = Database.database().reference()
    var brandDetail = Brand()
    var purchaseArray = [Purchase]()
    var sumTurnover: Double = 0.0
    var sumCommission: Double = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageDetail.layer.cornerRadius = 20

        // Convert from URL String to Image with KingFisher
        if let imageURL = brandDetail.pic {
            let url = URL(string : imageURL)
            imageDetail.kf.setImage(with: url)
        }
        
        nameBrand.text = brandDetail.name?.capitalized
        descriptionBrand.text = brandDetail.description
        getData()
    }
    
    func getData() {
        let purchaseDB = database.child("conversions").child("purchase")
        purchaseDB.queryOrdered(byChild: "offerId").queryEqual(toValue: brandDetail.offerId).observeSingleEvent(of: .value, with: { snapshot in
            for purchases in snapshot.children.allObjects as! [DataSnapshot] {
                let brandObj = purchases.value as? [String : Any]
                let amount = brandObj?["amount"] as? Double
                let commission = brandObj?["commission"] as? String
                let offerId = brandObj?["offerId"] as? Int
                let createdAt = brandObj?["createdAt"] as? Int
                
                let purchase = Purchase(amount: amount, commission: Double(commission ?? "0.0"), offerId: offerId, createdAt: createdAt)
                
                self.purchaseArray.append(purchase)
                
                let com = Double(commission ?? "0.0")
                self.sumCommission += com ?? 0.0
                self.sumTurnover += amount ?? 0.0
            }
            
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.purchaseTableView.reloadData()
            }
        })
    }
    
    @IBAction func BackClick(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imagesDetail.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PurchaseTableViewCell
        
        if indexPath.row == 0 {
            cell.titleCell.text = String(round(1000 * sumTurnover) / 1000) + "€"
            cell.imageCell.image = UIImage(systemName: imagesDetail[0])
        }
        else if indexPath.row == 1 {
            cell.titleCell.text = String(round(1000 * sumCommission) / 1000) + "€"
            cell.imageCell.image = UIImage(named: imagesDetail[indexPath.row])
        }
        else {
            cell.titleCell.text = String(purchaseArray.count)
            cell.imageCell.image = UIImage(named: imagesDetail[indexPath.row])
        }
        
        cell.subtitleCell.text = subTitles[indexPath.row]
        cell.viewCell.layer.cornerRadius = 10
        
        return cell
    }
    
}
