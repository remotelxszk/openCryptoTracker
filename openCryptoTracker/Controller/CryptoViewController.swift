//
//  ViewController.swift
//  openCryptoTracker
//
//  Created by Dominik on 15/12/2020.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cryptoImage: UIImageView!
    @IBOutlet weak var cryptoLabel: UILabel!
    @IBOutlet weak var cryptoValue: UILabel!
    @IBOutlet weak var cryptoUpDown: UIImageView!
    @IBOutlet weak var cryptoDailyDifference: UILabel!
    @IBOutlet weak var cryptoATH: UILabel!
    
    // UIPicker
    @IBOutlet weak var cryptoPicker: UIPickerView!
    
    var cryptoBackend = CryptoBackend()
    
    // Default Starting Values
    var currentCryptoCurrency = "bitcoin"
    var currentVSCurrency = "usd"
    var currentVSCurrencySymbol = "$"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cryptoBackend.delegate = self
        cryptoPicker.dataSource = self
        cryptoPicker.delegate = self
        
    }
    
}

//MARK: - UIPickerView

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cryptoBackend.cryptoArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currentCryptoCurrency = cryptoBackend.cryptoArray[row].lowercased()
        cryptoBackend.getURLValue(vsCurrency: currentVSCurrency, cryptoCurrency: currentCryptoCurrency)
        return cryptoBackend.cryptoArray[row]
    }
}

//MARK: - UISegmentedControl

extension ViewController {
    
    @IBAction func moneyCurrencyChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
                case 0:
                    currentVSCurrency = "usd"
                    currentVSCurrencySymbol = "$"
                case 1:
                    currentVSCurrency = "eur"
                    currentVSCurrencySymbol = "€"
                case 2:
                    currentVSCurrency = "gbp"
                    currentVSCurrencySymbol = "£"
                case 3:
                    currentVSCurrency = "pln"
                    currentVSCurrencySymbol = "PLN"
                default:
                    currentVSCurrency = "unknown currency"
                    currentVSCurrencySymbol = "error"
                }
        cryptoBackend.getURLValue(vsCurrency: currentVSCurrency, cryptoCurrency: currentCryptoCurrency)
    }
}

//MARK: - CryptoBackendDelegate

extension ViewController: CryptoBackendDelegate {
    
    func didUpdateCrypto(_ cryptoBackend: CryptoBackend, crypto: CryptoModel) {
        DispatchQueue.main.async {
            
            // Check if Cryptocurrency in the PickerView matches before updating UI
            let currentlySelectedCryptoCurrency = cryptoBackend.cryptoArray[self.cryptoPicker.selectedRow(inComponent: 0)]
            if currentlySelectedCryptoCurrency == crypto.id.capitalized {
                
                self.cryptoLabel.text = "\(crypto.cryptoName) (\(crypto.cryptoSymbol))"
                // If imageURL != nil download the image and display it
                if let imageURL = URL(string: crypto.imageURL) {
                    self.cryptoImage.load(imageURL)
                }
                self.cryptoValue.text = "\(crypto.currentPrice) \(self.currentVSCurrencySymbol)"
                self.cryptoATH.text = "All Time High: \(crypto.aTH) \(self.currentVSCurrencySymbol)"
                let dailyPriceChangeString = String(crypto.dailyPriceChange)
                if crypto.valueIsUp { // if cryptocurrency is up
                    self.cryptoUpDown.image = UIImage(systemName: "arrow.up.circle.fill")
                    self.cryptoUpDown.tintColor = .green
                    self.cryptoDailyDifference.text = dailyPriceChangeString
                }
                else { // if cryptocurrency is down
                    self.cryptoUpDown.image = UIImage(systemName: "arrow.down.circle.fill")
                    self.cryptoUpDown.tintColor = .red
                    self.cryptoDailyDifference.text = dailyPriceChangeString
                }
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - LoadImageFromInternetExtension

extension UIImageView {
    func load(_ url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
