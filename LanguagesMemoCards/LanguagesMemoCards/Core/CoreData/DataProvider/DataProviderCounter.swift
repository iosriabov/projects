//
//  DataProviderCounter.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 10.04.2022.
//

import Foundation

protocol DataProviderCounterProtocol {
    func countOfWordsOfLevel(level: String, completion: @escaping ((Int) -> ()))
    func countOfWordsWithoutDataOfLevelInCoreData(level: String, completion: @escaping ((Int) -> ()))
    func numberOfUnexploredCards(level: String, completion: @escaping ((Int) -> ()))
}

final class DataProviderCounter: DataProviderCounterProtocol {
    var dataProviderFetcher: DataProviderFetcherProtocol
    var coreDataStack: CoreDataStack
    
    init(dataProviderFetcher: DataProviderFetcherProtocol, coreDataStack: CoreDataStack) {
        self.dataProviderFetcher = dataProviderFetcher
        self.coreDataStack = coreDataStack
    }
    func countOfWordsOfLevel(level: String, completion: @escaping ((Int) -> ())) {
        dataProviderFetcher.levelWordsFetchRequest(level: level) { fetch in
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
    
    func countOfWordsWithoutDataOfLevelInCoreData(level: String, completion: @escaping ((Int) -> ())) {
        dataProviderFetcher.countOfWordsWithoutDataOfLevelInCoreDataFetchRequest(level: level) { fetch in
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
    
    func numberOfUnexploredCards(level: String, completion: @escaping ((Int) -> ())) {
        countOfWordsOfLevel(level: level) { allWordsOfThisLevel in
            self.countOfWordsWithoutDataOfLevelInCoreData(level: level) { numberOfWordsWithoutDate in
                completion(allWordsOfThisLevel - numberOfWordsWithoutDate )
            }
        }
    } 
}
