//
//  MyViewController.swift
//  octopus-reader
//
//  Created by CHAN Hong Wing on 25/9/2019.
//  Copyright © 2019 CHAN Hong Wing. All rights reserved.
//

import UIKit
import CoreNFC

class ViewController: UIViewController, FeliCaReaderSessionDelegate {
    var reader: OctopusReader!
    var transitICCard: OctopusCard?
    
    func feliCaReaderSession(didRead feliCaCard: FeliCaCard) {
        let transitICCard = feliCaCard as! OctopusCard
        
        DispatchQueue.main.async {
            if var balance = transitICCard.data.balance {
                //The real balance is (balance - Offset) / 10
                //(e.g. (4557 - 350) / 10 = HK$420.7 )
                balance = (balance - 350)/10
                print(balance)
//                self.balanceLabel.text = "$ \(balance)"
            } else {
//                self.balanceLabel.text = "$ -----"
            }
//            self.idmLabel.text = "IDm: \(transitICCard.data.idm)"
//            self.systemCodeLabel.text = "System Code: \(transitICCard.data.systemCode.string)"
        }
        
        self.transitICCard = transitICCard
    }
    
    func japanNFCReaderSession(didInvalidateWithError error: Error) {
        if let readerError = error as? NFCReaderError {
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(
                    title: "Session Invalidated",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                    //                    self.balanceLabel.text = "¥ -----"
                    //                    self.idmLabel.text = "IDm: "
                    //                    self.systemCodeLabel.text = "System Code: "
                }
                
                self.transitICCard = nil
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = OctopusReader(viewController: self)
        self.reader.get(itemTypes: [.balance])
        // Do any additional setup after loading the view.
    }
    
    
    
}
