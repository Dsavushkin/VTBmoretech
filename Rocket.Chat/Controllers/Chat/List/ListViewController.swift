//
//  ListViewController.swift
//  Rocket.Chat
//
//  Created by Vladimir Boyko on 14/09/2019.
//  Copyright © 2019 Rocket.Chat. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let items = ["Хинкали", "Блин с ветчиной", "Грибной крем-суп", "Апельсиновый сок", "Пицца", "Картофель по-деревенски", "Куриная котлета"]
    
    @IBAction func buttonClicked() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ListReady"), object: self, userInfo: nil)
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
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isHighlighted = !(tableView.cellForRow(at: indexPath)?.isHighlighted ?? true)
    }
}
