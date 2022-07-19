//
//  CompanyList.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 23.03.2022.
//

import Foundation

struct ListOfWordsResponse: Responsable {
    let array: [WordRaw]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode([WordRaw].self)
        array = values
    }
}
