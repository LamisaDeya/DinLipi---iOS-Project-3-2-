//
//  Weather.swift
//  DinLipi
//
//  Created by IQBAL MAHAMUD on 11/11/23.
//

import UIKit

class Weather: UIViewController {

    @IBOutlet weak var dayImg: UIImageView!
    @IBOutlet weak var uv: UILabel!
    
    @IBOutlet weak var cloud: UILabel!
    @IBOutlet weak var pressure: UILabel!
    @IBOutlet weak var updatetimeLabel: UILabel!
 
    @IBOutlet weak var percepLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var feelslike: UILabel!
    
    
    @IBOutlet weak var wLvl: UILabel!
    
    @IBOutlet weak var cLvl: UILabel!
    
    @IBOutlet weak var uvLvl: UILabel!
    
    @IBOutlet weak var weatherUpdateLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()

        // Do any additional setup after loading the view.
    }
    func fetchData()
    {
        let url = URL(string: "https://api.weatherapi.com/v1/current.json?key=f469ecbae77c41e7bcd120037232511&q=Khulna&aqi=no")
        let dataTask = URLSession.shared.dataTask(with: url!, completionHandler:{ (data,response,error) in
            guard let data = data, error == nil else
            {
                print("error")
                return
            }
            var fullWeatherData:WeatherData?
            do
            {
                fullWeatherData = try JSONDecoder().decode(WeatherData.self, from: data)
            }
            catch
            {
                print("Error\(error)")
            }
            DispatchQueue.main.async {
                
                
                
                self.updatetimeLabel.text = "\(fullWeatherData!.current.last_updated)"
                
                self.uv.text = ": \(fullWeatherData!.current.uv)"
                
                if fullWeatherData!.current.uv < 2.00 {
                    self.uvLvl.text = "low"
                    self.uvLvl.textColor = .systemGreen
                }
                
                else if fullWeatherData!.current.uv >= 2.00 && fullWeatherData!.current.uv < 5.00 {
                    self.uvLvl.text = "medium"
                    self.uvLvl.textColor = .systemOrange
                }
                
                else {
                    self.uvLvl.text = "high"
                    self.uvLvl.textColor = .systemRed
                }
                
                self.tempLabel.text = ": \(fullWeatherData!.current.temp_c)"
                self.humidityLabel.text = ": \(fullWeatherData!.current.humidity)"
                self.windLabel.text = ": \(fullWeatherData!.current.wind_kph)"
                self.feelslike.text=": \(fullWeatherData!.current.feelslike_c)"
                
                if fullWeatherData!.current.wind_kph < 6.00 {
                    self.wLvl.text = "calm"
                    self.wLvl.textColor = .systemGreen
                }
                
                else if fullWeatherData!.current.wind_kph >= 6.00 && fullWeatherData!.current.wind_kph < 11.00 {
                    self.wLvl.text = "light breeze"
                    self.wLvl.textColor = .systemTeal
                }
                
                else if fullWeatherData!.current.wind_kph >= 11.00 && fullWeatherData!.current.wind_kph < 19.00 {
                    self.wLvl.text = "gentle breeze"
                    self.wLvl.textColor = .systemYellow
                }
                
                else if fullWeatherData!.current.wind_kph >= 19.00 && fullWeatherData!.current.wind_kph < 24.00 {
                    self.wLvl.text = "fresh"
                    self.wLvl.textColor = .systemOrange
                }
                
                else {
                    self.wLvl.text = "strong"
                    self.wLvl.textColor = .systemRed
                }
                
                
                
                if fullWeatherData!.current.is_day == 1 {
                    self.dayImg.image = UIImage(named: "day")
                } else if fullWeatherData!.current.is_day == 0 {
                    self.dayImg.image = UIImage(named: "night")
                }
                
                self.pressure.text=": \(fullWeatherData!.current.pressure_in)"
                
                self.percepLabel.text=": \(fullWeatherData!.current.precip_in)"
                
                self.cloud.text=": \(fullWeatherData!.current.cloud)"
                
                if fullWeatherData!.current.cloud < 3 {
                    self.cLvl.text = "sunny"
                    self.cLvl.textColor = .systemOrange
                }
                
                else if fullWeatherData!.current.cloud >= 3 && fullWeatherData!.current.cloud < 6 {
                    self.cLvl.text = "partly cloudy"
                    self.cLvl.textColor = .systemYellow
                }
                
                else if fullWeatherData!.current.cloud >= 7 && fullWeatherData!.current.cloud < 8 {
                    self.cLvl.text = "mostly cloudy"
                    self.cLvl.textColor = .systemTeal
                }
                
                else {
                    self.cLvl.text = "cloudy"
                    self.cLvl.textColor = .systemBlue
                }
            }
            
        })
        dataTask.resume()
    }
    
    @IBAction func RefreshF(_ sender: Any) {
        fetchData()
        weatherUpdateLabel.text = "Refreshed!"
    }

}
