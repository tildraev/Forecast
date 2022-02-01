//
//  DayDetailsViewController.swift
//  Forecast
//
//  Created by Karl Pfister on 1/31/22.
//

import UIKit

class DayDetailsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var dayForcastTableView: UITableView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var currentHighLabel: UILabel!
    @IBOutlet weak var currentLowLabel: UILabel!
    @IBOutlet weak var currentDescriptionLabel: UILabel!
    
    var days: [Day] = []
    
    //MARK: - Properties
   
    //MARK: - View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayForcastTableView.dataSource = self
        dayForcastTableView.delegate = self
        dayForcastTableView.allowsSelection = true
        
        NetworkController.fetchDays { days in
            guard let days = days else { return }
            self.days = days
            
            DispatchQueue.main.async {
                self.updateViews(index: 0)
                self.dayForcastTableView.reloadData()
            }
        }
    }
    
    func updateViews(index: Int) {
        let currentDay = days[index]
        cityNameLabel.text = currentDay.cityName
        currentTempLabel.text = "\(currentDay.currentTemp)"
        currentDescriptionLabel.text = currentDay.weatherDescription
        currentLowLabel.text = "\(currentDay.lTemp)"
        currentHighLabel.text = "\(currentDay.hTemp)"
    }
    
}// End of class

//MARK: - Extensions
extension DayDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayForcastTableViewCell else { return UITableViewCell() }
        cell.updateViews(day: days[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.updateViews(index: indexPath.row)
    }
}// End of extension
