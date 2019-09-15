//
//  ListViewController.swift
//  Rocket.Chat
//
//  Created by Vladimir Boyko on 14/09/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    struct Item {
        let name: String
        let price: Double
    }
    
    let items: Array<Item> = [Item(name: "Блин с ветчиной", price: 120) ,Item(name: "Грибной крем-суп", price: 300) , Item(name: "Апельсиновый сок", price: 80), Item(name: "Пицца Маргарита", price: 500),Item(name:"Картофель фри", price: 125) , Item(name: "Куриная котлета", price: 150)]

    @IBOutlet var sumLabel: UILabel?
    @IBOutlet var tableView: UITableView?
    @IBAction func buttonClicked() {
        
        let selection = tableView?.visibleCells.map({ (cell) -> String in
            let text = cell.textLabel?.text ?? ""
            if cell.isHighlighted == true {
                 return text
            }
            return ""
        }).filter({$0.count > 0 })
        let text = "Были выбраны: " + (selection?.joined(separator: ", ") ?? "")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ListReady"), object: self, userInfo: ["text": text])
        dismiss(animated: true, completion: nil)
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
