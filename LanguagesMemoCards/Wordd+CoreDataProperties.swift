//
//  Wordd+CoreDataProperties.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 28.03.2022.
//
//

import Foundation
import CoreData


extension Wordd {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wordd> {
        return NSFetchRequest<Wordd>(entityName: "Wordd")
    }

    @NSManaged public var detailEnglish: String?
    @NSManaged public var detailRussian: String?
    @NSManaged public var englishWord: String?
    @NSManaged public var level: String?
    @NSManaged public var numberID: Int32
    @NSManaged public var russianWord: String?
    @NSManaged public var state: String?
    @NSManaged public var dataToAppear: Date?

}

extension Wordd : Identifiable {

}
