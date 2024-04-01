//
//  ScheduleViewController.swift
//  LiftBuddy
//
//  Created by Andrew Kostryba on 3/6/24.
//

import UIKit

class ScheduleViewController: UIViewController {

    @IBOutlet var workoutViews: [UIView]!
    @IBOutlet var workoutLabels : [UILabel]!
    @IBOutlet var detailLabels : [UILabel]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //Round corners for each workout tab
        for w in workoutViews{
            w.layer.cornerRadius = 5
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for wl in workoutLabels{
            let name = Schedule.shared[Day(rawValue: wl.accessibilityIdentifier!) ?? .Monday]?.name
            wl.text = name
        }
        for dl in detailLabels{
            let time = Schedule.shared[Day(rawValue: dl.accessibilityIdentifier!) ?? .Monday]?.getEstimatedTime()
            let setCount = Schedule.shared[Day(rawValue: dl.accessibilityIdentifier!) ?? .Monday]?.getTotalSetCount()
            dl.text = "\(String(setCount!)) Sets | \(String(time!)) Minutes"
        }
        
        //Adjust workout view color if rest day
        for l in workoutLabels{
            if l.text == "Rest Day"{
                l.superview!.superview!.backgroundColor = UIColor.darkGray
            }
            else{
                l.superview!.superview!.backgroundColor = UIColor.systemBlue
            }
        }
    }
    
    @IBAction func unwindToSchedule(_ sender : UIStoryboardSegue){}

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let target = segue.destination as? EditViewController{
            let button : UIButton = sender as! UIButton
            var workout : Workout
            switch button.tag{
            case 1: workout = Schedule.shared[.Monday]!
            case 2: workout = Schedule.shared[.Tuesday]!
            case 3: workout = Schedule.shared[.Wednesday]!
            case 4: workout = Schedule.shared[.Thursday]!
            case 5: workout = Schedule.shared[.Friday]!
            case 6: workout = Schedule.shared[.Saturday]!
            default: workout = Schedule.shared[.Sunday]!
            }
            target.workout = workout
        }
    }
    

}
