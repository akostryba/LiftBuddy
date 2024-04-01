//
//  HomeViewController.swift
//  LiftBuddy
//
//  Created by Andrew Kostryba on 3/5/24.
//

import UIKit
import HealthKit

class HomeViewController: UIViewController {

    @IBOutlet weak var quoteSourceLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var stepView: UIView!
    @IBOutlet weak var calorieView: UIView!
    @IBOutlet weak var calorieCountLabel: UILabel!
    @IBOutlet weak var startWorkoutButton: UIButton!
    @IBOutlet weak var stepCountLabel: UILabel!
    
    var workout : Workout!
    
    
    func fetchStepCountToday(){
        let stepType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let now = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
    
        let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, statisticsOrNil, errorOrNil) in
            guard let statistics = statisticsOrNil else {
                // Handle any errors here.
                return
            }
            
            let stepSum = statistics.sumQuantity()
            print("\(stepSum!)")
            
            DispatchQueue.main.async {
                // Update the UI here.
                self.stepCountLabel.text = String(Int(stepSum!.doubleValue(for: HKUnit.count())))
            }
        }
        
        HealthKitControl.shared.healthStore.execute(query)
            
    }
    
    
    func fetchCalorieCountToday(){
        let calorieType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        
        let now = Date()
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
    
        let query = HKStatisticsQuery(quantityType: calorieType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, statisticsOrNil, errorOrNil) in
            guard let statistics = statisticsOrNil else {
                // Handle any errors here.
                return
            }
            
            let calorieSum = statistics.sumQuantity()
            print("\(calorieSum!)")
            
            DispatchQueue.main.async {
                // Update the UI here.
                self.calorieCountLabel.text = String(Int(calorieSum!.doubleValue(for: HKUnit.kilocalorie())))
            }
        }
        
        HealthKitControl.shared.healthStore.execute(query)
            
    }
    
    func getWeekday() -> String{
        // Create a data object to get device time
        let currentDate = Date()
        
        // Determine day of the week
        let weekdayIndex = Calendar.current.component(.weekday, from: currentDate)
        let weekday = Calendar.current.weekdaySymbols[weekdayIndex-1]
        return weekday
    }
    
    func configureRestDay(){
        let weekday = getWeekday()
        
        workout = Schedule.shared[Day(rawValue: weekday) ?? .Monday]
        if workout.name == "Rest Day"{
            startWorkoutButton.configuration?.subtitle = ""
            startWorkoutButton.configuration?.title = "Rest Day"
            startWorkoutButton.configuration?.baseBackgroundColor = UIColor.systemIndigo
            startWorkoutButton.isUserInteractionEnabled = false
        }
        else{
            startWorkoutButton.configuration?.title = "Start Workout"
            startWorkoutButton.configuration?.baseBackgroundColor = UIColor.systemTeal
            startWorkoutButton.isUserInteractionEnabled = true
            startWorkoutButton.configuration?.subtitle = workout?.name
        }
    }
    
    func getTimeOfDay() -> String{
        // Create a data object to get device time
        let currentDate = Date()
        
        // Create a date formatter to extract the hour value from currentDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        
        // Determine time of day
        var timeOfDay : String = ""
        if let hourVal = Int(dateFormatter.string(from: currentDate)){
            if hourVal<12{
                timeOfDay = "Morning"
            }
            else if hourVal<18{
                timeOfDay = "Afternoon"
            }
            else if hourVal<21{
                timeOfDay = "Evening"
            }
            else{
                timeOfDay = "Night"
            }
        }
        
        return timeOfDay
    }
    
    func pickRandomQuote(){
        let quote = quotes[Int.random(in: 0..<10)]
        quoteLabel.text = quote.quote
        quoteSourceLabel.text = quote.source
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Style Views
        stepView.layer.cornerRadius = 5
        stepView.layer.borderColor = UIColor.systemBlue.cgColor
        stepView.layer.borderWidth = 2
        
        calorieView.layer.cornerRadius = 5
        calorieView.layer.borderColor = UIColor.systemOrange.cgColor
        calorieView.layer.borderWidth = 2

    
        
        // Update greetingLabel
        let timeOfDay = getTimeOfDay()
        greetingLabel.text = "Good \(timeOfDay),"
        
        // Update workout name label
        configureRestDay()
        
        // Update quote labels
        pickRandomQuote()
        
        // ask for read access to user health data
        HealthKitControl.shared.requestAuthorization()
        
        // Update health tracking labels
        fetchStepCountToday()
        fetchCalorieCountToday()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureRestDay()
    }
    
    @IBAction func unwindToHome(_ sender : UIStoryboardSegue){}
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let target = segue.destination as? WorkoutViewController{
            target.workout = workout
        }
    }
    
    


}

