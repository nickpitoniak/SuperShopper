//
//  ShoppingListViewController.swift
//  PantryAid
//
//  Created by AdminNick on 11/5/16.
//  Copyright © 2016 AdminNick. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    
    var tableData: [String] = []
    
    @IBAction func toAddFromList(sender: UIButton) {
        self.performSegueWithIdentifier("showAddGroceriesVC", sender: nil)
    }

    func parseNXML(needle: String, haystack: String) -> String {
        let firstBreak = haystack.componentsSeparatedByString("}:\(needle):}")
        if firstBreak.count > 1 {
            let secondBreak = firstBreak[1].componentsSeparatedByString("{:\(needle):{")
            return secondBreak[0]
        }
        return ""
    }
    
    @IBAction func goShoppingButton(sender: UIButton) {
        if(self.tableData.count == 0 || self.tableData[0] == "Item not found") {
            self.sendAlert("Error", message: "You do not have any items on your shopping list")
        } else {
            self.performSegueWithIdentifier("toGoShoppingVcFromListVC", sender: nil)
        }
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
        self.getList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    func deleteItem(sender: UIButton!) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let name = defaults.stringForKey("username")
        let nameAsString = name! as String
        var index = sender.tag
        let infoArray = self.tableData[index].componentsSeparatedByString("203598203598")
        var UPC = infoArray[4]
        self.deleteFromFoodWatch(UPC, username: nameAsString) {
            (result: String) in
            let successSplit = result.componentsSeparatedByString("Success")
            if successSplit.count > 1 {
                self.tableData.removeAtIndex(sender.tag)
                self.tableView.reloadData()
                self.sendAlert("Success", message: "Item has been added to your grocery list")
            } else {
                self.sendAlert("Error", message: "Unable to delete item")
            }
        }
    }
    func deleteFromFoodWatch(UPC: String, username: String, completion: (result: String) -> Void) {
        let myUrl = NSURL(string: "http://127.0.0.1/pantry/deleteListItem.php?username=\(username)&UPC=\(UPC)")
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cellOne", forIndexPath: indexPath) as! customCellOne
        if self.tableData[0] != "Item not found" {
        print(">>\(self.tableData[0])<<")
            let infoArray = self.tableData[indexPath.row].componentsSeparatedByString("203598203598")
            var name = infoArray[0]
            var image = infoArray[1]
            var amazonPrice = infoArray[2]
            var walmartPrice = infoArray[3]
            var UPC = infoArray[4]
        
            cell.groceryNameLabel.text = name
            cell.deleteGroceryButton.tag = indexPath.row
            cell.deleteGroceryButton.addTarget(self, action: "deleteItem:", forControlEvents: UIControlEvents.TouchUpInside)
            self.loadImageFromUrl(image, view: cell.imageThumbnail)
        } else {
            cell.groceryNameLabel.text = "No items in list"
            cell.deleteGroceryButton.setTitle("", forState: .Normal)
        }
        
        return cell
        
    }
    
    func sendAlert(subject: String, message: String) {
        let alertController = UIAlertController(title: subject, message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

}
