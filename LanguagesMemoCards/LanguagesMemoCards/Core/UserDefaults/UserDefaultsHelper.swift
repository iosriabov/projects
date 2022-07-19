//
//  UserDefaultsHelper.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 09.04.2022.
//

enum UserDefaultKeys: String, CaseIterable {
    case isTranslateFirst
    case timeForQuestion
    case timeForAnswer
}

protocol UserDefaultsHelperPtorocol {
    static func setData<T>(value: T, key: UserDefaultKeys)
    static func getData<T>(type: T.Type, forKey: UserDefaultKeys) -> T?
    static func removeData(key: UserDefaultKeys)
}

import Foundation

final class UserDefaultsHelper: UserDefaultsHelperPtorocol {
    static func setData<T>(value: T, key: UserDefaultKeys) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key.rawValue)
    }
    static func getData<T>(type: T.Type, forKey: UserDefaultKeys) -> T? {
        let defaults = UserDefaults.standard
        let value = defaults.object(forKey: forKey.rawValue) as? T
        return value
    }
    static func removeData(key: UserDefaultKeys) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: key.rawValue)
    }
}

