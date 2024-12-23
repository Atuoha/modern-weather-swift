
import UIKit

class WeatherViewController: UIViewController{
    var weather: Weather?
    var items = [[String: String]]()
    @IBOutlet weak var City: UILabel!
    @IBOutlet weak var Country: UILabel!
    @IBOutlet weak var CurrentWeatherImage: UIImageView!
    @IBOutlet weak var CurrentDegree: UILabel!
    @IBOutlet weak var WeatherDesc: UILabel!
    @IBOutlet weak var MinTemp: UILabel!
    @IBOutlet weak var Humidity: UILabel!
    @IBOutlet weak var MaxTemp: UILabel!
    @IBOutlet weak var WindSpeed: UILabel!
    @IBOutlet weak var WeatherLongDesc: UILabel!
    @IBOutlet weak var WeatherImage: UIImageView!
    @IBOutlet weak var ScrollViewContainer: UIScrollView!
    @IBOutlet weak var StackViewContainer: UIStackView!
    @IBOutlet weak var CurrentDate: UILabel!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupItems()
    }
    

    func setupItems() {
        removeAllArrangedSubviews(from: StackViewContainer)
        
        if let weatherData = weather{
            
            
            items = weatherData.list.enumerated().flatMap { (index, wh) -> [[String: String]] in
                return wh.weather.map { weatherItem in
                    
                    let time = wh.dt_txt.components(separatedBy: " ")
                    var timeString = time[1]
                    if timeString.hasSuffix(":00") {
                        timeString = String(timeString.dropLast(3))
                    }
                    
                    let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            
                    let date = dateFormatter.date(from: time[0])
                    let dayFormatter = DateFormatter()
                    dayFormatter.dateFormat = "E, d"
                    var formattedDate = dayFormatter.string(from: date!)
                    let day = Calendar.current.component(.day, from: date!)
                    let suffix = ordinalSuffix(for: day)
                    formattedDate = formattedDate + suffix
                    
                    
                    return [
                        "title": weatherItem.main,
                        "image": weatherItem.icon,
                        "date": formattedDate,
                        "time": timeString
                    ]
                    
                }
            }
            
            for item in items {
                if let itemView = createItemView() {
                    itemView.titleLabel.text = item["title"]
                    itemView.imageView.image = UIImage(named: item["image"]!)
                    itemView.dateLabel.text = item["date"]
                    itemView.timeLabel.text = item["time"]
                    itemView.translatesAutoresizingMaskIntoConstraints = false
                    itemView.widthAnchor.constraint(equalToConstant: 113).isActive = true
                    itemView.heightAnchor.constraint(equalToConstant: 221).isActive = true
                    
                    StackViewContainer.addArrangedSubview(itemView)
                   
                } else {
                    print("Failed to create item view")
                }
          }
        
            City.text = weatherData.city.name
            Country.text = weatherData.city.country
            CurrentDegree.text = String(format: "%.0f°", weatherData.list[0].main.temp)
            WeatherDesc.text = weatherData.list[0].weather[0].main
            MinTemp.text = "\(weatherData.list[0].main.temp_min)C"
            Humidity.text = "\(weatherData.list[0].main.humidity)"
            MaxTemp.text = "\(weatherData.list[0].main.temp_max)C"
            WindSpeed.text = "\(weatherData.list[0].wind.speed)km\\h"
            CurrentWeatherImage.image = UIImage(named: weatherData.list[0].weather[0].icon)
            WeatherLongDesc.text = weatherData.list[0].weather[0].description
            WeatherImage.image = UIImage(named: weatherData.list[0].weather[0].icon)
            CurrentDate.text = getCurrentDateFormatted()
        }
        

    }
    
 
    func createItemView() -> WeatherItem? {
        let nib = UINib(nibName: "WeatherItem", bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil)
        return views.first as? WeatherItem
        
    }
    
    
    func removeAllArrangedSubviews(from stackView: UIStackView) {
        for subview in stackView.arrangedSubviews {
            stackView.removeArrangedSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
            subview.removeFromSuperview()
        }
    }
 

    
    @IBAction func backToSearch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
