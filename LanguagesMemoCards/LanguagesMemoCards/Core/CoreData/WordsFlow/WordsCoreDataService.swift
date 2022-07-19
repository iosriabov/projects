//
//  Fetcher.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 30.03.2022.
//

import Foundation
import CoreData

enum Predicate: String {
    case new = "0"
    case error = "1"
    case old = "2"
}

protocol WordsCoreDataServiceProtocol {
    func addNewWords(oldID: Int, newID: Int, level: String)
    func currentWordGet(level: String)
}

final class WordsCoreDataService: WordsCoreDataServiceProtocol {
    var currentWord: Wordd?
    var stateNumber: [String: Int] = ["new" : 0, "error" : 0, "old" : 0]
    lazy var coreDataStack = CoreDataStack(modelName: "Words")
    lazy var wordsCoreDataServiceFetcher = WordsCoreDataServiceFetcher()
    lazy var wordsCoreDataServiceCounter = WordsCoreDataServiceCounter(coreDataStack: coreDataStack, wordsCoreDataServiceFetcher: wordsCoreDataServiceFetcher)
    
    //MARK: - AddNewWords
    func addNewWords(oldID: Int, newID: Int, level: String) {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let todayTime = calendar.startOfDay(for: Date())
        let endOfToday = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: todayTime)
        let fetch: NSFetchRequest<Wordd> = Wordd.fetchRequest()
        
        let newIdPredicate: NSPredicate = {
            return NSPredicate(format: "numberID <= \(newID)")
        }()
        
        let oldIdPredicate: NSPredicate = {
            return NSPredicate(format: "numberID > \(oldID)")
        }()
        
        let levelPredicate: NSPredicate = {
            return NSPredicate(format: "%K == %@", #keyPath(Wordd.level), level)
        }()
        
        let predicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [newIdPredicate, oldIdPredicate, levelPredicate])
        fetch.predicate = predicateCompound
        
        do {
            let results = try coreDataStack.managedContext.fetch(fetch)
            for result in results {
                result.state = "0"
                result.dataToAppear = endOfToday
            }
            try coreDataStack.managedContext.save()
            
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}

//MARK: - GetCurrentWord
extension WordsCoreDataService  {
    func currentWordGet(level: String) {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let tomorrow = calendar.startOfDay(for: Date().dayAfter)
        let fetch: NSFetchRequest<Wordd> = Wordd.fetchRequest()
        let numberOfErrors = wordsCoreDataServiceCounter.countWordsOfLevelWithPredicate(predicate: .error, level: level)
        let numberOfOlds = wordsCoreDataServiceCounter.countWordsOfLevelWithPredicate(predicate: .old, level: level)
        let numberOfNew = wordsCoreDataServiceCounter.countWordsOfLevelWithPredicate(predicate: .new, level: level)
        
        let levelPredicate = NSPredicate(format: "%K == %@", #keyPath(Wordd.level), level)
        
        
        if numberOfNew + numberOfOlds  > 0 {
            let newWordsPredicate = wordsCoreDataServiceFetcher.getNewWordsPredicate(levelPredicate: levelPredicate)
            let errorWordsPredicate = wordsCoreDataServiceFetcher.getErrorWordsPredicate(levelPredicate: levelPredicate)
            let oldWordsPredicate = wordsCoreDataServiceFetcher.getOldWordsPredicate(levelPredicate: levelPredicate, date: tomorrow)
            
            let allWordsPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [errorWordsPredicate, oldWordsPredicate, newWordsPredicate])
            
            fetch.predicate = allWordsPredicate
            fetch.sortDescriptors = wordsCoreDataServiceFetcher.addDescriptorToWordsResult()
            
        } else if numberOfErrors > 0 {
            let errorWordsPredicate = wordsCoreDataServiceFetcher.stateErrorPredicate(levelPredicate: levelPredicate)
            
            let stateErrorDescriptor: NSSortDescriptor = NSSortDescriptor(key: #keyPath(Wordd.dataToAppear), ascending: true)
            fetch.predicate = errorWordsPredicate
            fetch.sortDescriptors = [stateErrorDescriptor]
        } else {
            print("count = 0")
            return
        }
        
        fetch.fetchLimit = 1
        
        do {
            let result = try coreDataStack.managedContext.fetch(fetch)
            if result.count > 0 {
                currentWord = result.first
            } else {
                return
            }
            
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
}






