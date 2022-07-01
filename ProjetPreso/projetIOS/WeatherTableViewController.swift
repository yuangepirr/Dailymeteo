//
//  WeatherTableViewController.swift
//  projetIOS
//
//  Created by Gepir on 29/06/2022.
//

import UIKit
import CoreLocation

class WeatherTableViewController: UIViewController, UITableViewDelegate, CLLocationManagerDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView!
    
    var models = [ForecastDayData]()
    var hourlyModels = [hourData]()
    var current : CurrentWeather?
    var currentLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        
        tableView.register(HourlyCellTableViewCell.nib(), forCellReuseIdentifier: HourlyCellTableViewCell.indentifer)
        tableView.register(weatherTableViewCell.nib(), forCellReuseIdentifier: weatherTableViewCell.indentifer)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setLocation()
    }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationAuthorization()
        } else{
            print("Vous devez autoriser la localisation GPS pour utiliser l'application")
        }
    }
    
    func setUpLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied:
            print("Vous devez autoriser la localisation GPS pour utiliser l'application")
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            print("Vous devez autoriser la localisation GPS pour utiliser l'application")
            break
        case .authorizedAlways:
            break
            
        }
    }
    
    // Location
    func setLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    //verify differents permissions
    func locationManager(_ manager:CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if currentLocation == nil {
            currentLocation = locations.first
            locationManager.stopUpdatingHeading()
            requestWeatherLocation()
        }
    }
    func requestWeatherLocation(){
        let long = currentLocation?.coordinate.longitude
        let lat = currentLocation?.coordinate.latitude
        let url = "https://api.weatherapi.com/v1/forecast.json?key=5a1f1e1507b14579bc0132127222006&q=\(lat!),\(long!)&days=10&aqi=yes&alerts=yes"
        
        print("\(lat),\(long)")
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: {data, response, error in
            // validation
            guard let data = data, error == nil else{
                print("something went wrong")
                return
            }
            //convert data to models / some object
            var json : weatherResponse?
            do{
                json = try JSONDecoder().decode(weatherResponse.self, from: data)
            }
            catch{
                print ("error : \(error)")
            }
            
            guard let result = json else{
                return
            }
            let entries = result.forecast.forecastday
            self.models.append(contentsOf: entries)
            
            let current = result.current
            self.current = current
            let hourlyModel = entries[0].hour
            self.hourlyModels.append(contentsOf: hourlyModel)
            //update user interface
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            
        }).resume()
    }
    

    //MARK: -- table
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            // collectiontable
            return 1
        }
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyCellTableViewCell.indentifer, for: indexPath) as! HourlyCellTableViewCell
            cell.configure(with: hourlyModels)
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: weatherTableViewCell.indentifer, for : indexPath) as! weatherTableViewCell
        cell.configure(with: models[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}
