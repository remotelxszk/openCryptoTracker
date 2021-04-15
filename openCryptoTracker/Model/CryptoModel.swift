//
//  CryptoModel.swift
//  openCryptoTracker
//
//  Created by Dominik on 16/12/2020.
//

import Foundation

struct CryptoModel {
    let currentPrice: Double
    let cryptoName: String
    let dailyPriceChange: Double
    let aTH: Double
    let imageURL: String
    let cryptoSymbol: String
    let id: String
    let marketCapRank: Int
    
    var valueIsUp: Bool {
        if dailyPriceChange < 0{
            return false
        } else {
            return true
        }
    }
}
