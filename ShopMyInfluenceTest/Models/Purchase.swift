//
//  Purchase.swift
//  ShopMyInfluenceTest
//
//  Created by mac on 31/05/2022.
//

import Foundation
import UIKit

struct Purchase: Codable {
    var amount: Double?
    var commission: Double?
    var offerId: Int?
    var createdAt: Int?
}
