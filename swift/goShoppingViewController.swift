//
//  goShoppingViewController.swift
//  PantryAid
//
//  Created by AdminNick on 11/6/16.
//  Copyright © 2016 AdminNick. All rights reserved.
//

import UIKit

class goShoppingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var tableData: [String] = []
    
    func parseNXML(needle: String, haystack: String) -> String {
        let firstBreak = haystack.componentsSeparatedByString("}:\(needle):}")
        if firstBreak.count > 1 {
            let secondBreak = firstBreak[1].componentsSeparatedByString("{:\(needle):{")
            return secondBreak[0]
        }
        return ""
    }
    
    func getShoppingList(completion: (result: String) -> Void) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let name = defaults.stringForKey("username")
        let nameAsString = name! as String
        let myUrl = NSURL(string: "http://127.0.0.1/pantry/getUserShoppingList.php?username=\(nameAsString)")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                if error != nil {
                    print("Error: \(error)")
                }
                dispatch_async(dispatch_get_main_queue()) {
                    var RSString = responseString! as String
                    print(RSString)
                    if RSString.rangeOfString("DNE") != nil {
                        completion(result: "Item not found")
                        return
                    }
                    if RSString == "" {
                        completion(result: "Item not found")
                        return
                    }
                    var items = RSString.componentsSeparatedByString("---ITEM---<br>")
                    items.removeAtIndex(0)
                    var count = 0
                    for item in items {
                        var name = self.parseNXML("name", haystack: item)
                        print("NAME:\(name)")
                        var image = self.parseNXML("image", haystack: item)
                        var amazonPrice = self.parseNXML("amazon", haystack: item)
                        var id = self.parseNXML("id", haystack: item)
                        var walmartPrice = self.parseNXML("walmart", haystack: item)
                        var arrayString = name + "203598203598" + image + "203598203598" + amazonPrice + "203598203598" + walmartPrice + "203598203598" + id
                        completion(result: arrayString)
                    }
                }
            }
        }
        task.resume()
    }
    
    func getList() {
        self.tableData.removeAll()
        getShoppingList() {
            (result: String) in
            self.tableData.append(result)
            self.tableView.reloadData()
            print("RELOADED")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getList()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //https://cdn.corporate.walmart.com/resource/assets-bsp3/images/corp/walmart-logo.64968e7648c4bbc87f823a1eff1d6bc7.png
        //https://staticseekingalpha1.a.ssl.fastly.net/images/marketing_images/fair_use_logos_products/sacl_amzn_amazon_6.jpeg
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cellThree", forIndexPath: indexPath) as! customCellThree
        if tableData[indexPath.row] == "Item not found" {
            cell.nameLabel.text = tableData[indexPath.row]
        } else {
            if self.tableData.count > 0 {
                let infoArray = self.tableData[indexPath.row].componentsSeparatedByString("203598203598")
                var amazonPrice = Double(infoArray[2])
                if amazonPrice != nil {
                    amazonPrice  = amazonPrice! / 100
                } else {
                    amazonPrice = 9999999.00
                }
                var walmartPrice = Double(infoArray[3])
                if amazonPrice >= walmartPrice {
                    self.loadImageFromUrl("https://cdn.corporate.walmart.com/resource/assets-bsp3/images/corp/walmart-logo.64968e7648c4bbc87f823a1eff1d6bc7.png", view: cell.brandImageView)
                    cell.priceLabel.text = "$\(walmartPrice!)"
                } else {
                    self.loadImageFromUrl("https://staticseekingalpha1.a.ssl.fastly.net/images/marketing_images/fair_use_logos_products/sacl_amzn_amazon_6.jpeg", view: cell.brandImageView)
                    cell.priceLabel.text = "\(amazonPrice!)"
                }
                print("AMAZON PRICE:\(amazonPrice)")
                print("WALMART PRICE: \(walmartPrice)")
                cell.nameLabel.text = infoArray[0]
                print("ZERO INDEX: \(infoArray[0])")
                self.loadImageFromUrl(infoArray[1], view: cell.productImageView)
            }
        }
        
        return cell
    }
    
    func loadImageFromUrl(url: String, view: UIImageView){
        let url = NSURL(string: url)!
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (responseData, responseUrl, error) -> Void in
            if let data = responseData{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    view.image = UIImage(data: data)
                })
            }
        }
        task.resume()
    }

}
