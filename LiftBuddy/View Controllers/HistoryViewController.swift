//
//  HistoryViewController.swift
//  LiftBuddy
//
//  Created by Andrew Kostryba on 3/13/24.
//

import UIKit

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var models = [WorkoutLog]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.layer.cornerRadius = 5

        
        getAllWorkouts()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllWorkouts()
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(models.count)
        return models.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workout = models[indexPath.row]
        print(workout)
        let cell = tableView.dequeueReusableCell(withIdentifier: "workout", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = "Date: \(workout.date ?? "No Date")"
        cell.detailTextLabel?.text = "Workout Completed: \(workout.name ?? "No Name")"

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func getAllWorkouts(){
        do{
            models = try context.fetch(WorkoutLog.fetchRequest()).reversed()
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
            print(models.count)
        }
        catch{
            //error
            print("error")
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
