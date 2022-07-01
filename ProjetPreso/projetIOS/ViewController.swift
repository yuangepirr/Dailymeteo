//
//  ViewController.swift
//  projetIOS
//
//  Created by YUAN Rong on 04/05/2022.
//

import UIKit
import CoreLocation
//location: CoreLocation
//table view
//custom cell : collection view
//API

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var icon: UIImageView!
    var current : CurrentWeather?
    var currentLocation: CLLocation?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var temperatureCurrent: UILabel!
    @IBOutlet weak var weatherCurrent: UILabel!
    @IBOutlet weak var cityCurrent: UILabel!
    @IBOutlet weak var temperatureTomorrow: UILabel!
    @IBOutlet var iconTomorrow: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        checkLocationServices()
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
            let current = result.current
            let location = result.location
            self.current = current
            print (result.current.last_updated_epoch)
            //update user interface
            DispatchQueue.main.async {
                let condition = entries.first?.day.condition.text
                self.updateImage(condition: condition!,icon: self.icon)
                self.updateWeather(condition: condition!)
                self.cityCurrent.text = location.name
                self.temperatureCurrent.font = UIFont(name: "Chalkduster", size: 40.0)
                self.temperatureCurrent.text = "\(Int(current.temp_c))°"
                self.temperatureCurrent.text = "\(Int(current.temp_c))°"
                let tomorrow = entries[1].day
                self.temperatureTomorrow.text = "\(Int(tomorrow.avgtemp_c))°"
                let conditionTomorrow = tomorrow.condition.text
                self.updateImage(condition: conditionTomorrow,icon:self.iconTomorrow)
                
            }
            
            
        }).resume()
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

    // icon
    func updateImage(condition: String, icon: UIImageView){
        self.icon.contentMode = .scaleAspectFit
        
        let meteo = condition.lowercased()
        
        if meteo.contains("cloudy"){
            icon.image = UIImage(named: "Cloud")
        }
        else if meteo.contains("rain"){
            icon.image = UIImage(named: "Rain")
        }
        else if meteo.contains("clear"){
            icon.image = UIImage(named: "Clear")
        }
        else {
            icon.image = UIImage(named: "Sun")
        }
        
    }
    // WeatherCurrent
    func updateWeather(condition:String){
        let weathercurrent = condition.lowercased()
                          
        if weathercurrent.contains("cloudy"){
            weatherCurrent.font = UIFont(name: "Chalkduster", size: 20.0)
            weatherCurrent.text = "Nuageux"
        }
        else if weathercurrent.contains("rain"){
            weatherCurrent.font = UIFont(name: "Chalkduster", size: 20.0)
            weatherCurrent.text = "Pluie"
        }
        else if weathercurrent.contains("clear"){
            weatherCurrent.font = UIFont(name: "Chalkduster", size: 20.0)
            weatherCurrent.text = "Clair"
        }
        else {
            weatherCurrent.font = UIFont(name: "Chalkduster", size: 20.0)
            weatherCurrent.text = "Ensoleillé"
        }
    }
    
    //tempetature current
    func TemptatureCurrent(){
        
    }
    
}


//data API
struct weatherResponse: Codable {
    let location: LocationResponse
    let current : CurrentWeather
    let forecast : ForecastWeather
}
struct LocationResponse: Codable {
    let lat : CGFloat
    let lon : CGFloat
    let name : String
    let tz_id : String
}
struct CurrentWeather: Codable{
    let last_updated_epoch : CGFloat
    let condition : Condition
    let temp_c : Double
    let wind_kph : Double
    let humidity : Double
    let uv : Double
}
struct Condition: Codable{
    let text: String
}
struct ForecastWeather: Codable{
    let forecastday : [ForecastDayData]
}
struct ForecastDayData: Codable{
    let date : String
    let date_epoch : CGFloat
    let day : dayData
    let astro : astroData
    let hour : [hourData]
}
struct dayData: Codable{
    let maxtemp_c : CGFloat
    let avgtemp_c : CGFloat
    let mintemp_c : CGFloat
    let maxwind_kph : CGFloat
    let avghumidity : CGFloat
    let avgvis_miles : CGFloat
    let condition : Condition
    let uv : Double
}
struct astroData : Codable{
    let sunrise : String
    let sunset : String
}
struct hourData: Codable{
    let time : String
    let temp_c : Double
    let condition : Condition
}
