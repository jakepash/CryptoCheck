//
//  ViewController.swift
//  CryptoCheck
//
//  Created by Adam Eliezerov on 3/5/18.
//  Copyright © 2018 labbylabs. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

// api to use
//https://min-api.cryptocompare.com/data/pricehistorical?fsym=BTC&tsyms=USD&ts=1355270400
// ts = unix time historical data...
// let url = "https://min-api.cryptocompare.com/data/pricehistorical?fsym="+currencies[indexPath.row]+"&tsyms=USD&ts="+String(Int(unix))
// pull to refresh not working

var currencies = ["BTC","ETH","XRP","DASH","LTC"] // array of cryptocurrencies

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var tableview: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(currencies.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let cellCheck = currencies[indexPath.row]
        cell.currencyName.textColor = UIColor.white
        cell.backgroundColor = UIColor(red:0.02, green:0.31, blue:0.40, alpha:1.0)
        let url = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=\(cellCheck)&tsyms=USD"
        print(url)
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.data != nil {
                    let json = JSON(data: response.data!)
                    let percentChange = json["RAW"][cellCheck]["USD"]["CHANGEPCT24HOUR"].double
                    
                    
                    
                    if percentChange != nil {
                        cell.currencyName.text = cellCheck
                        let finalPercent = Double(round(1000*percentChange!)/1000)
                        print("percent change:\(finalPercent),currency: \(cellCheck)")
                        if finalPercent > 0{
                            cell.percentChange.textColor = UIColor.green
                            cell.posnegArrow.image = UIImage(named: "greenArrow")
                            cell.percentChange.text = "+\(finalPercent)"
                        }else {
                            cell.percentChange.textColor = UIColor.red
                            cell.posnegArrow.image = UIImage(named: "redArrow")
                            cell.percentChange.text = "\(finalPercent)"
                        }
                        
                    }
                }
                
        }// alamofire request
        
    
        return(cell)
    
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableview.backgroundColor = UIColor(red:0.02, green:0.31, blue:0.40, alpha:1.0)
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        self.tableview?.addSubview(refreshControl)
    }
    
    @objc func refresh(sender:AnyObject) {
        self.refreshControl.endRefreshing()
        self.tableview.reloadData()
        
    }

    @IBAction func addButton(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add Currency", message: "", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = ""
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if currencies.contains((textField?.text)!){
                print("You already have that currency")
            } else {
            let url = "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=\(textField?.text ?? "")&tsyms=USD"
            print(url)
            Alamofire.request(url, method: .get)
                .responseJSON { response in
                    if response.data != nil {
                        let json = JSON(data: response.data!)
                        let percentChange = json["RAW"][(textField?.text)!]["USD"]["CHANGEPCT24HOUR"].double
                        if percentChange != nil {
                            currencies.append((textField?.text)!)
                            self.tableview.reloadData()
                        }
                    }
            }
            }
            
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
        
    }




}
