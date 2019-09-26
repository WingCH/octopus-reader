//
//  SettingsViewController.swift
//  octopus-reader
//
//  Created by CHAN Hong Wing on 26/9/2019.
//  Copyright © 2019 CHAN Hong Wing. All rights reserved.
//

import Eureka


class SettingsViewController: FormViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let octopus_type = UserDefaults.string(forKey: .octopus_type)
        

        //https://stackoverflow.com/a/44475213/5588637
        let user_Octopus_type = User_Octopus_type(rawValue: octopus_type ?? "")
           
        

        
        form +++ Section(header: NSLocalizedString("octopus", comment: "") , footer: "Footer Title")
            <<< ActionSheetRow<String>() {
                $0.title = NSLocalizedString("issuanceYear", comment: "")
                $0.selectorTitle = NSLocalizedString("issuanceYear", comment: "")
                $0.options = [User_Octopus_type.new.getTypeContent(),User_Octopus_type.old.getTypeContent()]
                $0.value = user_Octopus_type?.getTypeContent()
            }.onChange { row in
                print(row.value!)
                UserDefaults.setByContent(content: row.value!, forKey: .octopus_type)
            }
            
        +++ Section("Section2")
            <<< DateRow(){
                $0.title = "Date Row"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }
    }
}
