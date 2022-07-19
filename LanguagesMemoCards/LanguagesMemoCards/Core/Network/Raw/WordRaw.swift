//
//  WordRaw.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 23.03.2022.
//

import Foundation

struct WordRaw: Codable, Responsable {
    let word: String
    let meanings:[Meanings]
}

struct Meanings: Codable, Responsable {
    let partOfSpeech: String?
    let definitions: [Definitions]
}

struct Definitions: Codable, Responsable {
    let definition: String
    let example: String?
}
