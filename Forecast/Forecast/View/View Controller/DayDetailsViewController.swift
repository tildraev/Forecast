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
    
    //MARK: - Properties
    var days: [Day] = []
    
    //MARK: - View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Conform to the TBVS Protocols
        dayForcastTableView.delegate = self
        dayForcastTableView.dataSource = self
        
        DayContoller.fetchDays { tempDays in
            guard let days = tempDays else {return}
            self.days = days
            DispatchQueue.main.async {
                self.updateViews()
                self.dayForcastTableView.reloadData()
            }
        }
    }
    
    func updateViews() {
        let currentDay = days[0]
        cityNameLabel.text = currentDay.cityName
        currentDescriptionLabel.text = currentDay.description
        currentTempLabel.text = "\(currentDay.temp)F"
        currentLowLabel.text = "\(currentDay.lowTemp)F"
        currentHighLabel.text = "\(currentDay.highTemp)F"
    }
}

//MARK: - Extenstions
extension DayDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "dayCell", for: indexPath) as? DayForcastTableViewCell else {return UITableViewCell()}
        let day = days[indexPath.row]
        cell.updateViews(day: day)
        return cell
    }
}
