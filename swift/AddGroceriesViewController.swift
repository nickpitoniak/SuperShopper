//
//  AddGroceriesViewController.swift
//  PantryAid
//
//  Created by AdminNick on 11/5/16.
//  Copyright © 2016 AdminNick. All rights reserved.
//

import UIKit

class AddGroceriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var keywordInput: UITextField!
    @IBOutlet var UPCInput: UITextField!
    @IBOutlet var tableViewTwo: UITableView!
    var tableData: [String] = []
    
    @IBAction func backButton(sender: UIButton) {
        self.performSegueWithIdentifier("showShoppingListVCFromAddGroceries", sender: nil)
    }
    
    func parseNXML(needle: String, haystack: String) -> String {
        let firstBreak = haystack.componentsSeparatedByString("}:\(needle):}")
        if firstBreak.count > 1 {
            let secondBreak = firstBreak[1].componentsSeparatedByString("{:\(needle):{")
            return secondBreak[0]
        }
        return ""
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
    
    func searchByUPC(UPC: String, completion: (result: String) -> Void) {
        let myUrl = NSURL(string: "http://127.0.0.1/pantry/walmartPriceByUpc.php?UPC=\(UPCInput.text!)")
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
                    if RSString.rangeOfString("DNE") != nil {
                        completion(result: "Item not found")
                        return
                    }
                    if RSString == "" {
                        completion(result: "Item not found")
                        return
                    }
                    var name = self.parseNXML("name", haystack: RSString)
                    var image = self.parseNXML("image", haystack: RSString)
                    var price = self.parseNXML("price", haystack: RSString)
                    var arrayString = name + "203598203598" + image + "203598203598" + price + "203598203598" + UPC
                    completion(result: arrayString)
                }
            }
        }
        task.resume()
    }
    
    func searchByKeyword(UPC: String, completion: (result: String) -> Void) {
        let myUrl = NSURL(string: "http://127.0.0.1/pantry/searchWalmartByKeyword.php?keyword=\(keywordInput.text!)")
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
                        var price = self.parseNXML("price", haystack: item)
                        var UPCCode = self.parseNXML("UPCCode", haystack: item)
                        var arrayString = name + "203598203598" + image + "203598203598" + price + "203598203598" + UPCCode
                        print("UPCCode:" + UPCCode)
                        completion(result: arrayString)
                    }
                }
            }
        }
        task.resume()
    }
    
    @IBAction func searchUPC(sender: UIButton) {
        if UPCInput.text == "" {
            self.sendAlert("Error", message: "Input is empty")
            return
        }
        self.tableData.removeAll()
        searchByUPC(UPCInput.text!) {
            (result: String) in
            self.tableData.append(result)
            self.tableViewTwo.reloadData()
            print("RELOADED")
        }
    }
    
    @IBAction func searchKeyword(sender: UIButton) {
        if keywordInput.text == "" {
            self.sendAlert("Error", message: "Input is empty")
            return
        }
        self.tableData.removeAll()
        searchByKeyword(keywordInput.text!) {
            (result: String) in
            self.tableData.append(result)
            self.tableViewTwo.reloadData()
            print("RELOADED")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func sendAlert(subject: String, message: String) {
        let alertController = UIAlertController(title: subject, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addGroceryToList(sender: UIButton!) {
        var index = sender.tag
        addFunc(index) {
            (result: String) in
            print("RELOAD")
            self.tableData.removeAtIndex(index)
            self.tableViewTwo.reloadData()
            self.sendAlert("Success", message: "Item has been added to your grocery list")
        }
    }
    func addFunc(indexInput: Int, completion: (result: String) -> Void) {
    var index = indexInput
    var info = self.tableData[index]
    let infoArray = info.componentsSeparatedByString("203598203598")
    let defaults = NSUserDefaults.standardUserDefaults()
    let name = defaults.stringForKey("username")
    let nameAsString = name! as String
    let myUrl = NSURL(string: "http://127.0.0.1/pantry/addToShoppingListAmAndWalm.php?UPC=\(infoArray[3])&username=\(nameAsString)")
    let request = NSMutableURLRequest(URL: myUrl!)
    request.HTTPMethod = "POST"
    let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
        data, response, error in
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            dispatch_async(dispatch_get_main_queue()) {
                print(responseString! as String)
                completion(result: responseString! as String)
            }
        }
    }
    task.resume()
}

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableViewTwo.dequeueReusableCellWithIdentifier("cellTwo", forIndexPath: indexPath) as! customCellTwo
        if tableData[indexPath.row] == "Item not found" {
            cell.groceryLabel.text = tableData[indexPath.row]
            cell.addGroceryButton.setTitle("", forState: .Normal)
        } else {
            if self.tableData.count > 0 {
                let infoArray = self.tableData[indexPath.row].componentsSeparatedByString("203598203598")
                cell.groceryLabel.text = infoArray[0]
                print("ZERO INDEX: \(infoArray[0])")
                cell.addGroceryButton.tag = indexPath.row
                cell.addGroceryButton.addTarget(self, action: "addGroceryToList:", forControlEvents: UIControlEvents.TouchUpInside)
                self.loadImageFromUrl(infoArray[1], view: cell.imageThumbnail)
        }
        }
        
        return cell
    }

}
