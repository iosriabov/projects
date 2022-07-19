//
//  DataProviderFetcher.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 10.04.2022.
//

import Foundation
import CoreData

protocol DataProviderFetcherProtocol {
    func checkIfThereAreWordsOfThisLevelInCoreDataFetchRequest(level: String, completion: @escaping((NSFetchRequest<Wordd>) ->()))
    func countOfWordsWithoutDataOfLevelInCoreDataFetchRequest(level: String, completion: @escaping ((NSFetchRequest<Wordd>) -> ()))
    func levelWordsFetchRequest(level: String, completion: @escaping ((NSFetchRequest<Wordd>) -> ()))
    
}

final class DataProviderFetcher: DataProviderFetcherProtocol {
    func levelWordsFetchRequest(level: String, completion: @escaping ((NSFetchRequest<Wordd>) -> ())) {
        let fetch: NSFetchRequest<Wordd> = Wordd.fetchRequest()
        let levelPredicate: NSPredicate = {
            return NSPredicate(format: "%K == %@", #keyPath(Wordd.level), level)
        }()
        let predicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [ levelPredicate])
        fetch.predicate = predicateCompound
        completion(fetch)
    }
    
    func checkIfThereAreWordsOfThisLevelInCoreDataFetchRequest(level: String, completion: @escaping ((NSFetchRequest<Wordd>) -> ())) {
        let fetch: NSFetchRequest<Wordd> = Wordd.fetchRequest()
        let levelPredicate: NSPredicate = {
            return NSPredicate(format: "%K == %@", #keyPath(Wordd.level), level)
        }()
        
        let nonZeroPredicate: NSPredicate = {
            return NSPredicate(format: "englishWord != nil")
        }()
        
        let predicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [nonZeroPredicate, levelPredicate])
        fetch.predicate = predicateCompound
        completion(fetch)
    }
    
    func countOfWordsWithoutDataOfLevelInCoreDataFetchRequest(level: String, completion: @escaping ((NSFetchRequest<Wordd>) -> ())) {
        let fetch: NSFetchRequest<Wordd> = Wordd.fetchRequest()
        let levelPredicate: NSPredicate = {
            return NSPredicate(format: "%K == %@", #keyPath(Wordd.level), level)
        }()
        
        let nonZeroPredicate: NSPredicate = {
            return NSPredicate(format: "englishWord != nil")
        }()
        
        let dataPredicate: NSPredicate = {
            return NSPredicate(format: "dataToAppear != nil")
        }()
        
        let predicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [nonZeroPredicate, levelPredicate, dataPredicate])
        fetch.predicate = predicateCompound
        completion(fetch)
    }
    
    func getOldWordsOnTodayInCoreDataFetchRequest(completion: @escaping ((NSFetchRequest<Wordd>) -> ())) {
        let fetch: NSFetchRequest<Wordd> = Wordd.fetchRequest()
        let newPredicate: NSPredicate = {
            return NSPredicate(format: "state == 1")
        }()
        
        let predicateCompoundOR = NSCompoundPredicate(orPredicateWithSubpredicates: [newPredicate])
        let predicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateCompoundOR])
        fetch.predicate = predicateCompound
        completion(fetch)
    }
}
