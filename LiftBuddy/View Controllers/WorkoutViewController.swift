//
//  WorkoutViewController.swift
//  LiftBuddy
//
//  Created by Andrew Kostryba on 3/12/24.
//

import UIKit
import HealthKit

class WorkoutViewController: UIViewController {
    


    @IBOutlet weak var currentExerciseLabel: UILabel!
    @IBOutlet weak var restValueLabel: UILabel!
    @IBOutlet weak var setsValueLabel: UILabel!
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var setsView: UIView!
    @IBOutlet weak var restView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    
    var workout : Workout!
    var current : Int = 0
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var timer = Timer()
    var count = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // style timer view
        timerView.layer.cornerRadius = 5
        
        // start timer
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        
        // style views
        setsView.layer.cornerRadius = 5
        setsView.layer.borderColor = UIColor.white.cgColor
        setsView.layer.borderWidth = 2
        restView.layer.cornerRadius = 5
        restView.layer.borderColor = UIColor.white.cgColor
        restView.layer.borderWidth = 2
        
        // update exercise labels
        updateExerciseLabels()
        
        fetchHeartBPM()
    }
    
    @objc func timerCounter() {
        count = count + 1
        let timeString : String = formatSeconds(seconds: count)
        timerLabel.text = timeString
    }
    
    func updateExerciseLabels(){
        if !workout.exercises.isEmpty{
            exerciseLabel.text = workout.exercises[current].name
            setsValueLabel.text = String(workout.exercises[current].setCount)
            restValueLabel.text = String(workout.exercises[current].restTime)
        }
        else{
            exerciseLabel.text = "Workout Complete"
            setsView.isHidden = true
            restView.isHidden = true
            currentExerciseLabel.text = ""
            timer.invalidate()
        }
    }
    
    func formatSeconds (seconds: Int) -> String{
        
        var timeString = ""
        timeString += String(format: "%02d", seconds/3600)
        timeString += " : "
        timeString += String(format: "%02d", (seconds%3600)/60)
        timeString += " : "
        timeString += String(format: "%02d", (seconds%3600)%60)
        return timeString
        
    }
    
    func fetchHeartBPM(){
        let heartRateType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!
        
        let now = Date()
        let calendar = Calendar.current
        let oneHourAgo = calendar.date(byAdding: .hour, value: -1, to: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: oneHourAgo, end: now, options: .strictStartDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)

        let query = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor])
            {(query, sampleOrNil, errorOrNil) in
            guard let sample = sampleOrNil else {
                return
            }
        
            if sample.count>0{
                let bpm = sample[0] as! HKQuantitySample
                
                DispatchQueue.main.async {
                    // Update the UI here.
                    self.bpmLabel.text = String(Int(bpm.quantity.doubleValue(for: HKUnit(from:"count/min"))))
                }
            }
        }
        
        HealthKitControl.shared.healthStore.execute(query)
            
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        current+=1
        if current < workout.exercises.count{
            exerciseLabel.text = workout.exercises[current].name
            setsValueLabel.text = String(workout.exercises[current].setCount)
            restValueLabel.text = String(workout.exercises[current].restTime)
        }
        else{
            exerciseLabel.text = "Workout Complete"
            setsView.isHidden = true
            restView.isHidden = true
            currentExerciseLabel.text = ""
            timer.invalidate()
        }
    }
    @IBAction func endWorkoutTapped(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        let formattedDate = dateFormatter.string(from: Date())
        
        let newWorkoutLog = WorkoutLog(context: context)
        newWorkoutLog.name = workout.name
        newWorkoutLog.date = formattedDate
        print("Adding")
        
        do{
            try context.save()
        }
        catch{
            //error
            print("Error Saving")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
