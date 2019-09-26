//
//  UserDefaults.swift
//  octopus-reader
//
//  Created by CHAN Hong Wing on 26/9/2019.
//  Copyright © 2019 CHAN Hong Wing. All rights reserved.
//

import UIKit

enum User_Octopus_type:String {
    case new
    case old
    
    func getTypeContent() -> String {
        switch self {
        case .new:
            return NSLocalizedString("after2017", comment: "")
        case .old:
            return NSLocalizedString("before2017", comment: "")
        }
    }
    
}

//https://www.jianshu.com/p/3796886b4953
extension UserDefaults {
    enum SaveKeys: String {
        case octopus_type
    }
    
    static func set(value: String, forKey key: SaveKeys) {
        let key = key.rawValue
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func setByContent(content: String, forKey key: SaveKeys) {
        switch content {
        case User_Octopus_type.new.getTypeContent():
            UserDefaults.standard.set(User_Octopus_type.new.rawValue, forKey: key.rawValue)
        case User_Octopus_type.old.getTypeContent():
            UserDefaults.standard.set(User_Octopus_type.old.rawValue, forKey: key.rawValue)
        default:
            return;
        }
    }
    
    static func string(forKey key: SaveKeys) -> String? {
        let key = key.rawValue
        return UserDefaults.standard.string(forKey: key)
    }
}
