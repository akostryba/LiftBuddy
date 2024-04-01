//
//  WorkoutLog+CoreDataProperties.swift
//  LiftBuddy
//
//  Created by Andrew Kostryba on 3/14/24.
//
//

import Foundation
import CoreData


extension WorkoutLog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutLog> {
        return NSFetchRequest<WorkoutLog>(entityName: "WorkoutLog")
    }

    @NSManaged public var name: String?
    @NSManaged public var date: String?

}

extension WorkoutLog : Identifiable {

}
