//
//  CryptoData.swift
//  openCryptoTracker
//
//  Created by Dominik on 16/12/2020.
//

import Foundation

struct CryptoData: Decodable {
    let current_price: Double
    let price_change_24h: Double
    let name: String
    let ath: Double
    let image: String
    let symbol: String
    let id: String
    let market_cap_rank: Int
}
