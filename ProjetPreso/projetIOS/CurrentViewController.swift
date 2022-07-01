//
//  CurrentViewController.swift
//  projetIOS
//
//  Created by Gepir on 30/06/2022.
//

import UIKit
import CoreLocation

class CurrentViewController: UIViewController , UITableViewDelegate, CLLocationManagerDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView : UITableView!
    @IBOutlet weak var alertCurrent: UILabel!
    
    var models = [ForecastDayData]()
    var current : CurrentWeather?
    var currentLocation: CLLocation?
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkLocationServices()
        
        tableView.register(currentTableViewCell.nib(), forCellReuseIdentifier: currentTableViewCell.indentifer)
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
        let url = "https://api.weatherapi.com/v1/forecast.json?key=5a1f1e1507b14579bc0132127222006&q=\(lat!),\(long!)&days=1&aqi=yes&alerts=yes"
        
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
            print (result.current.last_updated_epoch)
            //update user interface
            DispatchQueue.main.async {
                self.tableView.reloadData()
                let condition = entries.first?.day.condition.text
                self.updateAlert(condition: condition!)
            }
            
            
        }).resume()
    }
    

    //MARK: -- table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: currentTableViewCell.indentifer, for : indexPath) as! currentTableViewCell
        cell.configure(with: models[indexPath.row])
        //cell.configureastro(with: current)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }

    func updateAlert(condition : String){
        let weathercurrent = condition.lowercased()
                          
        if weathercurrent.contains("cloudy"){
            alertCurrent.font = UIFont(name: "Chalkduster", size: 20.0)
            alertCurrent.text = "Soyez prudent en conduisant :)"
        }
        else if weathercurrent.contains("rain"){
            alertCurrent.font = UIFont(name: "Chalkduster", size: 20.0)
            alertCurrent.text = "N'oubliez pas votre parapluie!"
        }
        else {
            alertCurrent.font = UIFont(name: "Chalkduster", size: 20.0)
            alertCurrent.text = "Il fait beaux aujourd'hui :) "
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
