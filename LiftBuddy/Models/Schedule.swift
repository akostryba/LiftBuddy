//
//  Schedule.swift
//  LiftBuddy
//
//  Created by Andrew Kostryba on 3/13/24.
//

import Foundation

enum Day : String {
    case Monday
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
    func intVal() -> Int {
        switch self {
        case .Monday : return 0
        case .Tuesday : return 1
        case .Wednesday : return 2
        case .Thursday : return 3
        case .Friday : return 4
        case .Saturday : return 5
        case .Sunday : return 6
        }
    }
}

class Schedule {
    
    static let shared  = Schedule().workouts
    
    var workouts : [Day : Workout] = [.Monday : Workout("Rest Day", []), .Tuesday : Workout("Legs", []), .Wednesday : Workout("Chest and Triceps", []), .Thursday : Workout("Back and Biceps", []), .Friday : Workout("Rest Day", []), .Saturday : Workout("Rest Day", []), .Sunday : Workout("Rest Day", [])]
    
    
}

class Workout {
    
    var name : String
    var exercises : [Exercise]
    
    init(_ name: String,_ exercises: [Exercise]) {
        self.name = name
        self.exercises = exercises
    }
    
    func getEstimatedTime() -> Int{
        var sum : Int = 0
        for exercise in exercises{
            sum+=exercise.restTime*exercise.setCount+1
        }
        return sum
    }
    
    func getTotalSetCount() -> Int{
        var sum : Int = 0
        for exercise in exercises{
            sum+=exercise.setCount
        }
        return sum
    }
    
    func addExercise(_ exercise: Exercise){
        exercises.append(exercise)
    }
    
    func removeExercise(_ exercise: Exercise){
        for i in 0...exercises.count-1{
            print(i)
            if exercises[i].name == exercise.name{
                exercises.remove(at: i)
                return
            }
        }
    }
    
    
}


    
