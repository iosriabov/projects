//
//  DataProvider.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 10.04.2022.
//

import Foundation
import CoreData

protocol DataProviderProtocol {
    func checkIfThereAreWordsOfThisLevelInCoreData(level: String, completion: @escaping((Bool) ->()))
    func loadWordsOfTheLevelFromCoreData(level: String, completion: @escaping(() ->()))
}

final class DataProvider: DataProviderProtocol {
    lazy var coreDataStack = CoreDataStack(modelName: "Words")
    lazy var dataProviderFetcher = DataProviderFetcher()
    lazy var dataProviderCounter = DataProviderCounter(dataProviderFetcher: dataProviderFetcher, coreDataStack: coreDataStack)
    
    func checkIfThereAreWordsOfThisLevelInCoreData(level: String, completion: @escaping ((Bool) -> ())) {
        var isZero = false
        dataProviderFetcher.checkIfThereAreWordsOfThisLevelInCoreDataFetchRequest(level: level) { fetch in
            do {
                let results = try self.coreDataStack.managedContext.fetch(fetch)
                if results.count > 0 {
                    isZero = false
                    completion(isZero)
                } else {
                    isZero = true
                    completion(isZero)
                }
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
        }
    }
    
    func loadWordsOfTheLevelFromCoreData(level: String, completion: @escaping (() -> ())) {
        checkIfThereAreWordsOfThisLevelInCoreData(level: level) { isThereWords in
            if isThereWords {
                self.dataProviderFetcher.checkIfThereAreWordsOfThisLevelInCoreDataFetchRequest(level: level) { [weak self] fetch in
                    guard let self = self else {return}
                    do {
                        let path = Bundle.main.path(forResource: level, ofType: "plist")
                        let dataArray = NSArray(contentsOfFile: path!)!
                        
                        for dict in dataArray {
                            let entity = NSEntityDescription.entity(forEntityName: "Wordd", in: self.coreDataStack.managedContext)!
                            let word = Wordd(entity: entity, insertInto: self.coreDataStack.managedContext)
                            let btDict = dict as! [String: Any]
                            let numberID = btDict["NumberID"] as! String
                            word.numberID = Int32(numberID)!
                            word.englishWord = btDict["EnglishWord"] as? String
                            word.russianWord = btDict["RussianWord"] as? String
                            word.level = btDict["Level"] as? String
                            word.detailEnglish = btDict["DetailEnglish"] as? String
                            word.detailRussian = btDict["DetailRussian"] as? String
                        }
                        try self.coreDataStack.managedContext.save()
                        
                    } catch let error as NSError {
                        print("Fetch error: \(error) description: \(error.userInfo)")
                    }
                }
            } else {
                return
            }
        }
    }
}







