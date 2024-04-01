//
//  EditViewController.swift
//  LiftBuddy
//
//  Created by Andrew Kostryba on 3/7/24.
//

import UIKit

class EditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{


    @IBOutlet weak var restDaySwitch: UISwitch!
    @IBOutlet weak var restTimeSlider: UISlider!
    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var setCountLabel: UILabel!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var setStepper: UIStepper!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var categoryPicker: UIPickerView!
    
    let categories = ["chest", "arms", "shoulders", "legs", "back", "abs"]
    
    var workout = Schedule.shared[.Monday]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //style text fields
        for tf in textFields{
            tf.layer.borderColor = UIColor.darkGray.cgColor
            tf.layer.borderWidth = 2
        }
        
        //style picker
        categoryPicker.layer.cornerRadius = 5
        
        //style stepper
        setStepper.layer.cornerRadius = 5
        
        //style add button
        addButton.layer.cornerRadius = 5
        
        //enable rest day switch if rest day
        if workout.name == "Rest Day"{
            restDaySwitch.isOn = true
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //fill in text fields
        for tf in textFields{
            if tf.accessibilityIdentifier == "Workout_Title"{
                tf.text = workout.name
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
        }
        
        //label.font = UIFont.systemFont(ofSize: 18)
        label.font = UIFont(name: "Futura", size: 18)
        label.textColor = UIColor.systemTeal
        label.text = categories[row]
        label.textAlignment = .center
        return label
    }
    
    func disableEdit(){
        for tf in textFields{
            tf.isEnabled = false
        }
        categoryPicker.isUserInteractionEnabled = false
        setStepper.isEnabled = false
        restTimeSlider.isEnabled = false
    }
    
    func enableEdit(){
        for tf in textFields{
            tf.isEnabled = true
        }
        categoryPicker.isUserInteractionEnabled = true
        setStepper.isEnabled = true
        restTimeSlider.isEnabled = true
    }
    
    @IBAction func restDaySwitchTapped(_ sender: UISwitch) {
        if sender.isOn{
            disableEdit()
            workout.name = "Rest Day"
            workout.exercises.removeAll()
            for tf in textFields{
                if tf.accessibilityIdentifier == "Workout_Title"{
                    tf.text = "Rest Day"
                }
            }
        }
        else{
            enableEdit()
            workout.name = ""
        }
    }
    

    @IBAction func backgroundTapped(_ sender: UIControl) {
        for tf in textFields{
            if tf.isFirstResponder{
                tf.resignFirstResponder()
            }
        }
    }
    
    @IBAction func sliderDragged(_ sender: UISlider) {
        sliderLabel.text = String(Int(sender.value)) + ":00"
    }
    
    @IBAction func setStepperTapped(_ sender: UIStepper) {
        setCountLabel.text = String(Int(sender.value))
    }
    
    @IBAction func addTapped(_ sender: UIButton) {
        var name : String = ""
        for tf in textFields{
            if tf.accessibilityIdentifier == "Exercise_Title"{
                name = tf.text!
                tf.text = ""
            }
        }
        let category = categories[categoryPicker.selectedRow(inComponent: 0)]
        let restTime = Int(restTimeSlider.value)
        let setCount = Int(setCountLabel.text!)!
        let exercise = Exercise(name: name, category: category, restTime: restTime, setCount: setCount)
        workout.addExercise(exercise)
        
        restTimeSlider.value = 3
        sliderLabel.text = "3:00"
        categoryPicker.selectRow(0, inComponent: 0, animated: true)
        setCountLabel.text = "1"
        setStepper.value = 1
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        var title : String = ""
        for tf in textFields{
            if tf.accessibilityIdentifier == "Workout_Title"{
                title = tf.text!
            }
        }
        workout.name = title
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let target = segue.destination as? ExerciseListViewController{
            target.workout = workout
        }
    }


}
