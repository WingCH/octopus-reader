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
    var record: Records!

    
    @IBOutlet weak var balance: UILabel!
    
    
    @IBAction func reCheck() {
        self.reader.get(itemTypes: [.balance])
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reader = OctopusReader(viewController: self)
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
                    self.balance.text = "$ -----"
                }
                
                self.transitICCard = nil
            }
        }
    }
    
    func feliCaReaderSession(didRead feliCaCard: FeliCaCard) {
        let transitICCard = feliCaCard as! OctopusCard
        
        DispatchQueue.main.async {
            if let balance = transitICCard.data.balance {
                let realBalance = (Double(balance) - 350)/10
                self.balance.text = "$ \(realBalance)"
                
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    self.record = Records(context: appDelegate.persistentContainer.viewContext)
                    self.record.balance = realBalance
                    self.record.create_date = Date()
                    appDelegate.saveContext()
                }
                

                
                
            } else {
                self.balance.text = "$ -----"
            }
        }
        
        self.transitICCard = transitICCard
    }
    
}
