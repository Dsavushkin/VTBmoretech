//
//  ListViewController.swift
//  Rocket.Chat
//
//  Created by Vladimir Boyko on 14/09/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit
import SwiftyJSON

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct Item {
        let name: String
        let price: Double
    }
    
    let items: Array<Item> = [Item(name: "Блин с ветчиной", price: 120) ,Item(name: "Грибной крем-суп", price: 300) , Item(name: "Апельсиновый сок", price: 80), Item(name: "Пицца Маргарита", price: 500),Item(name:"Картофель фри", price: 125) , Item(name: "Куриная котлета", price: 150)]

    @IBOutlet var sumLabel: UILabel?
    @IBOutlet var tableView: UITableView?
    @IBAction func buttonClicked() {
        
        let activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.center = self.view.center
        activityView.startAnimating()
        
        self.view.addSubview(activityView)
        
        let selection = tableView?.visibleCells.map({ (cell) -> String in
            let text = cell.textLabel?.text ?? ""
            if cell.isHighlighted == true {
                 return text
            }
            return ""
        }).filter({$0.count > 0 })
        let text = "Были выбраны: \(selection?.joined(separator: ", ") ?? "") Итого: \(sumLabel!.text!)"
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ListReady"), object: self, userInfo: ["text": text])
        
        let json: [String: Any] = ["addresses": [],
            "deviceId": "test_device_id",
            "deviceType": 1]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "http://89.208.84.235:31080/api/v1/session")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("32852185-988b-4de6-8df3-7dd340942cf0", forHTTPHeaderField: "FPSID")
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")

        guard let sum = sumLabel!.text?.components(separatedBy: " ")[0], let cur = Double(sum) else {return}
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                
                let json: [String: Any] = [  "amount": cur,
                                             "currencyCode": 810,
                                             "description": "test description",
                                             "number": JSON(responseJSON)["data"].rawString()!,
                                             "payer": "ab0ae25f2dfb1832961f051e0050087fd9d76885",
                                             "recipient": "3c63a8ea371fa1c582cb6f158f8c8be7cf17cba5"]
                
                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                
                let url = URL(string: "http://89.208.84.235:31080/api/v1/invoice")!
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.httpBody = jsonData
                request.setValue("32852185-988b-4de6-8df3-7dd340942cf0", forHTTPHeaderField: "FPSID")
                request.setValue("application/json", forHTTPHeaderField:"Content-Type")
                
                let sessionConfig = URLSessionConfiguration.default
                sessionConfig.timeoutIntervalForRequest = 30.0
                sessionConfig.timeoutIntervalForResource = 60.0
                let session = URLSession(configuration: sessionConfig)
                
                let task = URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let data = data, error == nil else {
                        print(error?.localizedDescription ?? "No data")
                        return
                    }
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    if let responseJSON = responseJSON as? [String: Any] {
                        print(responseJSON)
                        DispatchQueue.main.async {
                        activityView.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
                
                task.resume()
                
            }
        }
        
        task.resume()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        cell.textLabel?.text = items[indexPath.item].name
        cell.detailTextLabel?.text = String(items[indexPath.item].price)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = !(tableView.cellForRow(at: indexPath)?.isHighlighted ?? true)
        if let title = sumLabel!.text?.components(separatedBy: " ")[0], let cur = Double(title) {
            sumLabel!.text = "\(cur + items[indexPath.item].price) ₽"
        }
    }
}
