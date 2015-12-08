//
//  DrawQuizResult-Creation.swift
//  Sonji
//
//  Created by Daniel Schlaug on 7/12/14.
//  Copyright (c) 2014 Daniel Schlaug. All rights reserved.
//

import Foundation
import CoreData

extension DrawQuizResult {
    
    class func add(        character:Character,
                               score:Float,
                           iteration:Int,
        managedObjectContext context:NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName("DrawQuizResult", inManagedObjectContext: context)
        let newResult: DrawQuizResult = DrawQuizResult(entity: entity!, insertIntoManagedObjectContext: context)
        newResult.score = score
        newResult.character = String(character)
        newResult.date = NSDate()
        newResult.iteration = NSNumber(int: Int32(iteration)) 
        var error: NSError?
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
        }
        if error != nil {
            NSLog("\(error)")
            assert(false, "Saving userDataManagedObject should succeed.")
        }
    }
    
    class func lastNResults(n: Int, ForCharacter character:Character, managedObjectContext context:NSManagedObjectContext) -> [DrawQuizResult] {
        assert(n >= 0)
        let request = NSFetchRequest(entityName: "DrawQuizResult")
        request.predicate = NSPredicate(format: "character = %@", String(character))
        request.fetchLimit = n
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            let results = try context.executeFetchRequest(request) as? [DrawQuizResult]
            if results == nil {
                NSLog("\(results)")
                NSLog("\(request.predicate)")
                return [DrawQuizResult]()
            }
            return results!
        } catch let error as NSError {
            NSLog("Failed to get last result for character: \(character)")
            NSLog("\(error)")
        }
        assert(false)
    }
    
}