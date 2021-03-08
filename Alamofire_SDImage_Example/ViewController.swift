//
//  ViewController.swift
//  Alamofire_SDImage_Example
//
//  Created by Can on 4.03.2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage


class ViewController: UIViewController {
    
    let wikipediaURL = "https://en.wikipedia.org/w/api.php"
    let image = UIImage(named: "a")

    @IBOutlet weak var xsearchField: UITextField!
    @IBOutlet weak var xarticleImage: UIImageView!
    @IBOutlet weak var xarticleLabel: UILabel!
    
    private var search = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        xarticleImage.contentMode = .scaleAspectFit
    }
    
    @IBAction func xsearchPressed(_ sender: UIButton) {
        let parameters: [String: String] = [
            "format": "json",
            "action": "query",
            "prop": "extracts|pageimages",
            "exintro": "",
            "explaintext": "",
            "indexpageids": "",
            "redirects": "1",
            "pithumbsize": "500",
            "titles": xsearchField.text!
        ]
        if (xsearchField.text != ""){
            AF.request(wikipediaURL, method: HTTPMethod.get, parameters: parameters).responseJSON { response in
                switch response.result {
                
                case .success(let value):
                    
                    let json = JSON(value)
                    
                    let firstPage = json["query"]["pageids"][0].stringValue
                    let firstResult = json["query"]["pages"][firstPage]
                    
                    print("Result: \(firstResult)")
                    
                    DispatchQueue.main.async {
                        self.xarticleLabel.text = firstResult["extract"].stringValue
                        self.xarticleLabel.textAlignment = NSTextAlignment.left;
                        
                        if let imageUrl = URL(string: firstResult["thumbnail"]["source"].stringValue) {
                            self.xarticleImage.sd_setImage(with: imageUrl, completed: nil)
                            self.xarticleImage.isHidden = false
                            
                        }
                        if self.xarticleLabel.text!.isEmpty == true {
                            self.xarticleLabel.text = "İçerik metni bulunamadi"
                            self.xarticleLabel.textAlignment = NSTextAlignment.center;
                            self.xarticleImage.image = self.image
                            self.show_alert(title: String("Hata"), msg: String("İlgili icerik bulunamadi"))
                            self.title = "Not Found"
                        }
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
            title = xsearchField.text
            xsearchField.text = ""
        } else {
            title = "Search"
            show_alert(title: "Hata", msg: "Aranilacak Kelimeyi Girin")
            
        }
            
        
    }
    
    @objc func show_alert(title: String, msg : String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}


