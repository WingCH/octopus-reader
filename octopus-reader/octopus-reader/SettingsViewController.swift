//
//  SettingsViewController.swift
//  octopus-reader
//
//  Created by CHAN Hong Wing on 26/9/2019.
//  Copyright © 2019 CHAN Hong Wing. All rights reserved.
//

import Eureka
import SafariServices

class SettingsViewController: FormViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let octopus_type = UserDefaults.string(forKey: .octopus_type)
        
        
        //https://stackoverflow.com/a/44475213/5588637
        let user_Octopus_type = User_Octopus_type(rawValue: octopus_type ?? "")
        
        
        
        
        form +++ Section(header: NSLocalizedString("octopus", comment: "") , footer: NSLocalizedString("footer", comment: ""))
            <<< ActionSheetRow<String>() {
                $0.title = NSLocalizedString("issuanceYear", comment: "")
                $0.selectorTitle = NSLocalizedString("issuanceYear", comment: "")
                $0.options = [User_Octopus_type.new.getTypeContent(),User_Octopus_type.old.getTypeContent()]
                $0.value = user_Octopus_type?.getTypeContent()
            }.onChange { row in
                print(row.value!)
                UserDefaults.setByContent(content: row.value!, forKey: .octopus_type)
            }
            
            +++ Section("Acknowledgments")
            <<< LabelRow () {
                $0.title = "TRETJapanNFCReader"
            }
            .onCellSelection { cell, row in
                guard let url = URL(string: "https://github.com/treastrain/TRETJapanNFCReader") else { return }
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            }
            <<< LabelRow () {
                $0.title = "Eureka"
            }
            .onCellSelection { cell, row in
                guard let url = URL(string: "https://github.com/xmartlabs/Eureka") else { return }
                let svc = SFSafariViewController(url: url)
                self.present(svc, animated: true, completion: nil)
            }
    }
}
