//
//  WordsCoreDataServiceCounter.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 10.04.2022.
//

import Foundation
import CoreData

protocol WordsCoreDataServiceCounterProtocol {
    func countWordsOfLevelWithPredicate(predicate: Predicate, level: String) -> Int
    func countOfNewAndOldWordsOnTodayInCoreData(completion: @escaping ((Int) -> ()))
    func countOfNewWordsOnTodayInCoreData(completion: @escaping ((Int) -> ()))
    func getOldWordsFromCoreData(completion: @escaping (([Wordd]) -> ()))
}

class WordsCoreDataServiceCounter: WordsCoreDataServiceCounterProtocol {
    var coreDataStack: CoreDataStack
    var wordsCoreDataServiceFetcher: WordsCoreDataServiceFetcher
    
    init(coreDataStack: CoreDataStack, wordsCoreDataServiceFetcher: WordsCoreDataServiceFetcher) {
        self.coreDataStack = coreDataStack
        self.wordsCoreDataServiceFetcher = wordsCoreDataServiceFetcher
    }
    
    func countWordsOfLevelWithPredicate(predicate: Predicate, level: String) -> Int {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let tomorrow = calendar.startOfDay(for: Date().dayAfter)
        let statePredicate: NSPredicate = {
            return NSPredicate(format: "%K == %@", #keyPath(Wordd.state), predicate.rawValue)
        }()
        let levelPredicate: NSPredicate = {
            return NSPredicate(format: "%K == %@", #keyPath(Wordd.level), level)
        }()
        let datePredicate = NSPredicate(format: "%K < %@", #keyPath(Wordd.dataToAppear), tomorrow as NSDate)
        let fetch: NSFetchRequest<Wordd> = Wordd.fetchRequest()
        let predicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [statePredicate, datePredicate, levelPredicate])
        fetch.predicate = predicateCompound
        let countNew = try! coreDataStack.managedContext.count(for: fetch)
        return countNew
    }
    
    func countOfNewAndOldWordsOnTodayInCoreData(completion: @escaping ((Int) -> ())) {
        wordsCoreDataServiceFetcher.countOfErrorAndOldWordsOnTodayInCoreDataFetchRequest { fetch in
            do {
                let results = try self.coreDataStack.managedContext.fetch(fetch)
                if results.count > 0 {
                    completion(results.count)
                } else {                   
                    return
                }
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
        }
    }
    
    func countOfNewWordsOnTodayInCoreData(completion: @escaping ((Int) -> ())) {
        wordsCoreDataServiceFetcher.countOfNewWordsOnTodayInCoreDataFetchRequest { fetch in
            do {
                let results = try self.coreDataStack.managedContext.fetch(fetch)
                if results.count > 0 {
                    completion(results.count)
                } else {
                    return
                }
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
        }
    }
    
    func getOldWordsFromCoreData(completion: @escaping (([Wordd]) -> ())) {
        wordsCoreDataServiceFetcher.getOldWordsFromCoreDataFetchRequest { fetch in
            do {
                let results = try self.coreDataStack.managedContext.fetch(fetch)
                if results.count > 0 {
                    completion(results)
                } else {
                    return
                }
            } catch let error as NSError {
                print("Fetch error: \(error) description: \(error.userInfo)")
            }
        }
    }
}
