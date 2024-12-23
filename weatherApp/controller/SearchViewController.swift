
import UIKit
import Foundation

class SearchViewController: UIViewController, UISearchBarDelegate{
    private var debounceTimer: Timer?
    var weather: Weather?
    @IBOutlet weak var SearchBar: UISearchBar!
    @IBOutlet weak var ResultImage: UIImageView!
    @IBOutlet weak var ResultLabel: UILabel!
    @IBOutlet weak var NavigateBTN: UIButton!
    @IBOutlet weak var LoadingSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        NavigateBTN.isHidden = true
        SearchBar.delegate = self
        LoadingSpinner.isHidden = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            
            if searchText.count >= 3 {
                self.clearInputError(searchBar: searchBar)
                self.searchWeather(for: searchText, searchBar: searchBar)
            } else {
                self.clearResults()
            }
        }
        
    }
    
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
          guard let searchText = searchBar.text, !searchText.isEmpty else {
              return
          }
        searchWeather(for: searchText,searchBar: searchBar)
        
      }
    
    private func searchWeather(for city: String, searchBar: UISearchBar) {
        loading(city: city)
        
       
        let urlString = "\(AppStrings.BASE_URL)data/2.5/forecast?q=\(city)&appid=\(AppStrings.API_KEY)"
        print("URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        

        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Error fetching data: \(error)")
                DispatchQueue.main.async {
                    self.error(city: city)
                }
                return
            }
            
           
            guard let data = data else {
                DispatchQueue.main.async {
                    self.error(city: city)
                }
                return
            }
            
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(Weather.self, from: data)
                self.weather = weatherData
               
                DispatchQueue.main.async {
                    self.fetched(city: city, searchBar: searchBar)
                    print("Weather data: \(weatherData)")
                }
            } catch {
                
                print("Error decoding weather data: \(error)")
                DispatchQueue.main.async {
                    self.error(city: city)
                }
            }
        }.resume()
    }

    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        if searchBar.text == "" {
            setInputError(searchBar: searchBar)
            return false
        }else{
            clearInputError(searchBar: searchBar)
            return true
        }
    }
        
    private func clearResults() {
        LoadingSpinner.isHidden = true
        ResultLabel.text = "Enter a city name to see the weather details"
        ResultImage.image = UIImage(named: "location")
        NavigateBTN.isHidden = true
    }
    
    
    private func loading(city: String){
        LoadingSpinner.isHidden = false
        LoadingSpinner.startAnimating()
        ResultLabel.text = "Searching weather details for \(city)..."
        ResultImage.image = UIImage(named: "loading")
    }
    
    private func fetched(city:String, searchBar: UISearchBar){
        searchBar.resignFirstResponder()
        LoadingSpinner.isHidden = true
        ResultLabel.text = "Found weather details for \(city)"
        ResultImage.image = UIImage(named: "found")
        NavigateBTN.isHidden = false
    }
    
    private func error(city: String){
        LoadingSpinner.isHidden = true
        ResultLabel.text = "Failed to find weather details for \(city)"
        ResultImage.image = UIImage(named: "not_found")
        NavigateBTN.isHidden = true
    }
    
    private func serverError(city: String){
        LoadingSpinner.isHidden = true
        ResultLabel.text = "Request invalid, unable to find weather details for \(city)"
        ResultImage.image = UIImage(named: "404")
        NavigateBTN.isHidden = true
    }
    
    private func setInputError(searchBar: UISearchBar){
        searchBar.placeholder = "Please enter a city name"
        searchBar.layer.borderColor = UIColor.red.cgColor
        searchBar.layer.borderWidth = 1.0
        searchBar.layer.cornerRadius = 12.0
        searchBar.clipsToBounds = true
        NavigateBTN.isHidden = true
    }
    
    private func clearInputError(searchBar: UISearchBar){
        searchBar.placeholder = "Enter city"
        searchBar.layer.borderColor = UIColor.clear.cgColor
        searchBar.layer.borderWidth = 0
        searchBar.layer.cornerRadius = 0
        searchBar.clipsToBounds = false
    }
    
    
    
    @IBAction func navigateToWeather(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToWeather", sender: self)
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "goToWeather"{
            let weatherVC = segue.destination as! WeatherViewController
            weatherVC.weather = weather
            weatherVC.modalPresentationStyle = .fullScreen
        }
    }
    
    
}
