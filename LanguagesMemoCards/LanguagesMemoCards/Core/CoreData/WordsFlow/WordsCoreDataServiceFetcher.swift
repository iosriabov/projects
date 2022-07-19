//
//  WordsCoreDataServiceFetcher.swift
//  LanguagesMemoCards
//
//  Created by Владимир Рябов on 10.04.2022.
//

import Foundation
import CoreData

protocol WordsCoreDataServiceFetcherProtocol {
    func getNewWordsPredicate(levelPredicate: NSPredicate) -> NSCompoundPredicate
    func getErrorWordsPredicate(levelPredicate: NSPredicate) -> NSCompoundPredicate
    func getOldWordsPredicate(levelPredicate: NSPredicate, date: Date ) -> NSCompoundPredicate
    func stateErrorPredicate(levelPredicate: NSPredicate) -> NSCompoundPredicate
    func addDescriptorToWordsResult() -> [NSSortDescriptor]
    func countOfErrorAndOldWordsOnTodayInCoreDataFetchRequest(completion: @escaping ((NSFetchRequest<Wordd>) -> ()))
    func countOfNewWordsOnTodayInCoreDataFetchRequest(completion: @escaping ((NSFetchRequest<Wordd>) -> ()))
    func getOldWordsFromCoreDataFetchRequest(completion: @escaping ((NSFetchRequest<Wordd>) -> ()))
}

class WordsCoreDataServiceFetcher: WordsCoreDataServiceFetcherProtocol {
    func getNewWordsPredicate(levelPredicate: NSPredicate) -> NSCompoundPredicate {
        let stateNewWordsPredicate = NSPredicate(format: "%K == %@", #keyPath(Wordd.state), "0")
        let newWordsPredicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [ stateNewWordsPredicate, levelPredicate])
        return newWordsPredicateCompound
    }
    
    func getErrorWordsPredicate(levelPredicate: NSPredicate) -> NSCompoundPredicate {
        let stateErrorWordsPredicate = NSPredicate(format: "%K == %@", #keyPath(Wordd.state), "1")
        let dateToAppearErrorWordsPredicate = NSPredicate(format: "%K <= %@", #keyPath(Wordd.dataToAppear), Date() as NSDate)
        let errorWordsPredicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [stateErrorWordsPredicate, dateToAppearErrorWordsPredicate, levelPredicate])
        return errorWordsPredicateCompound
    }
    
    func getOldWordsPredicate(levelPredicate: NSPredicate, date: Date ) -> NSCompoundPredicate {
        let stateOldWordsPredicate = NSPredicate(format: "%K == %@", #keyPath(Wordd.state), "2")
        let dateToAppearOldWordsPredicate = NSPredicate(format: "%K < %@", #keyPath(Wordd.dataToAppear), date as NSDate )
        let oldWordsPredicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [ stateOldWordsPredicate, dateToAppearOldWordsPredicate, levelPredicate])
        return oldWordsPredicateCompound
    }
    
    func stateErrorPredicate(levelPredicate: NSPredicate) -> NSCompoundPredicate {
        let stateErrorPredicate = NSPredicate(format: "%K == %@", #keyPath(Wordd.state), "1")
        let predicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [ stateErrorPredicate , levelPredicate])
        return predicateCompound
    }
    
    func addDescriptorToWordsResult() -> [NSSortDescriptor]  {
        let dateDescriptor: NSSortDescriptor = NSSortDescriptor(key: #keyPath(Wordd.dataToAppear), ascending: true)
        let stateDescriptor: NSSortDescriptor = NSSortDescriptor(key: #keyPath(Wordd.state), ascending: true)
        let descriptorsCompound = [dateDescriptor,stateDescriptor]
        return descriptorsCompound
    }
    
    func countOfErrorAndOldWordsOnTodayInCoreDataFetchRequest(completion: @escaping ((NSFetchRequest<Wordd>) -> ())) {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let tomorrow = calendar.startOfDay(for: Date().dayAfter)
        let fetch: NSFetchRequest<Wordd> = Wordd.fetchRequest()
        
        
        let newPredicate: NSPredicate = {
            return NSPredicate(format: "state == 1")
        }()
        let oldPredicate: NSPredicate = {
            return NSPredicate(format: "state == 2")
        }()
        
        let dataPredicate: NSPredicate = {
            return NSPredicate(format: "%K < %@", #keyPath(Wordd.dataToAppear), tomorrow as NSDate)
        }()
        
        let predicateCompoundOR = NSCompoundPredicate(orPredicateWithSubpredicates: [newPredicate, oldPredicate])
        
        let predicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateCompoundOR, dataPredicate])
        fetch.predicate = predicateCompound
        completion(fetch)
    }
    
    func countOfNewWordsOnTodayInCoreDataFetchRequest(completion: @escaping ((NSFetchRequest<Wordd>) -> ())) {
        let fetch: NSFetchRequest<Wordd> = Wordd.fetchRequest()
        let newPredicate: NSPredicate = {
            return NSPredicate(format: "state == 0")
        }()
        
        let predicateCompoundOR = NSCompoundPredicate(orPredicateWithSubpredicates: [newPredicate])
        
        let predicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateCompoundOR])
        fetch.predicate = predicateCompound
        completion(fetch)
    }
    
    func getOldWordsFromCoreDataFetchRequest(completion: @escaping ((NSFetchRequest<Wordd>) -> ())) {
        let fetch: NSFetchRequest<Wordd> = Wordd.fetchRequest()
        let newPredicate: NSPredicate = {
            return NSPredicate(format: "state == 2")
        }()
        
        let predicateCompoundOR = NSCompoundPredicate(orPredicateWithSubpredicates: [newPredicate])
        
        let predicateCompound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateCompoundOR])
        fetch.predicate = predicateCompound
        completion(fetch)
    }
}
