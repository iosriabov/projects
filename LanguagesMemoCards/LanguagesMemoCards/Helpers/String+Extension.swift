//
//  String+Extension.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 23.03.2022.
//

import UIKit

extension String {
    func isValid(_ validityType: ValidityType) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""
        switch validityType {
        case .age:
            regex = Regex.age.rawValue
        }
        return NSPredicate(format: format, regex).evaluate(with: self)
    }
    
    enum ValidityType {
        case age
    }
    enum Regex: String {
        case age = "[0-9]{1,2}"
    }
}

extension String {
    func height(withWidth width: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil)
        let height = actualSize.integral.height
        return height
    }
    
    func width(withHeight height: CGFloat, font: UIFont) -> CGFloat {
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let actualSize = self.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font : font], context: nil)
        let width = actualSize.integral.width
        return width
    }
}
