//
//  HealthKitControl.swift
//  LiftBuddy
//
//  Created by Andrew Kostryba on 3/12/24.
//

import Foundation
import HealthKit

class HealthKitControl {
    
    static let shared = HealthKitControl()
    
    var healthStore : HKHealthStore = HKHealthStore()
    
    
    
    func requestAuthorization(){
        let readTypes: Set<HKObjectType> =  [HKObjectType.quantityType(forIdentifier: .heartRate)!,
                                            HKObjectType.quantityType(forIdentifier: .stepCount)!,
                                             HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!]
                
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if success {
                print("Authorization granted.")
            }
            else {
                print("Authorization failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    

    

    
}
