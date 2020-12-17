//
//  CryptoBackend.swift
//  openCryptoTracker
//
//  Created by Dominik on 15/12/2020.
//

import Foundation

protocol CryptoBackendDelegate {
    func didUpdateCrypto(_ cryptoBackend: CryptoBackend, crypto: CryptoModel)
    func didFailWithError(error: Error)
}

struct CryptoBackend {
    
    var baseAPIURL = "https://api.coingecko.com/api/v3/"
    let cryptoArray = ["Bitcoin", "Ethereum", "Litecoin", "Monero", "Chainlink", "Tether", "Dash", "Aave", "Ripple", "Dogecoin"]
    var delegate: CryptoBackendDelegate?
    
    func getURLValue(vsCurrency: String, cryptoCurrency: String) {
        let apiURL = "\(baseAPIURL)coins/markets?vs_currency=\(vsCurrency)&ids=\(cryptoCurrency)"
        getRequest(apiURL)
    }
    func getRequest(_ urlString: String) {
        // 1 Create a URL
        if let url = URL(string: urlString) {
            // 2 Create a URL Session
            let session = URLSession(configuration: .default)
            // 3 Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let crypto = parseJSON(safeData) {
                        delegate?.didUpdateCrypto(self, crypto: crypto)
                    }
                }
            }
            // 4 Start the task
            task.resume()
        }
    }
    func parseJSON(_ cryptoData: Data) -> CryptoModel?{
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([CryptoData].self, from: cryptoData)
            let name = decodedData[0].name
            let priceChange = decodedData[0].price_change_24h
            let currentPrice = decodedData[0].current_price
            let aTH = decodedData[0].ath
            let imageURL = decodedData[0].image
            let symbol = decodedData[0].symbol.uppercased()
            let id = decodedData[0].id
            
            let crypto = CryptoModel(currentPrice: currentPrice, cryptoName: name, dailyPriceChange: priceChange, aTH: aTH, imageURL: imageURL, cryptoSymbol: symbol, id: id)
            
            return crypto
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
