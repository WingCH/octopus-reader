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
    var user_Octopus_type: User_Octopus_type? = nil {
        didSet{
            print(user_Octopus_type!)
        }
    }
    
    
    @IBOutlet weak var balance: UILabel!
    
    @IBOutlet weak var balanceDescription: UITextView!
    
    
    @IBOutlet weak var checkButton: UIButton!
    @IBAction func reCheck() {
        self.reader.get(itemTypes: [.balance])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let octopus_type = UserDefaults.string(forKey: .octopus_type)
        user_Octopus_type = User_Octopus_type(rawValue: octopus_type ?? "")!
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        balanceDescription.text = NSLocalizedString("description", comment: "")
        checkButton.setTitle(NSLocalizedString("check", comment: ""), for: .normal)
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
                var realBalance: Double = 0;
                if self.user_Octopus_type == User_Octopus_type.old {
                    realBalance = (Double(balance) - 350)/10
                }else{
                    realBalance = (Double(balance) - 500)/10
                }
                
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
