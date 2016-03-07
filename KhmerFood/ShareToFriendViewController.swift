//
//  ShareToFriendViewController.swift
//  KhmerFood
//
//  Created by Yoman on 3/4/16.
//  Copyright © 2016 Donut. All rights reserved.
//

import UIKit

class ShareToFriendViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate,ConnectionManagerDelegate {

    @IBOutlet var mainScrollVIew: UIScrollView!
    @IBOutlet var txtSearchBar: UISearchBar!
    @IBOutlet var mainTableView: UITableView!
    
    @IBOutlet var mainScrollHeigthConstraint: NSLayoutConstraint!
    
    var testArr = Array<AnyObject>();
    
//    var dicData = NSDictionary()
    
    var resultDicData : NSArray = []
    
    var checkSearch : Bool!
    
    var dicData: NSDictionary = ["COUNT":"6","RECORDS": [
            ["FILE_NM":"","FULL_NAME":"AAA"],
            ["FILE_NM":"","FULL_NAME":"BBB"],
            ["FILE_NM":"","FULL_NAME":"CCC"],
            ["FILE_NM":"","FULL_NAME":"93K Eve"],
            ["FILE_NM":"","FULL_NAME":"Yoman"],
            ["FILE_NM":"","FULL_NAME":"XXX"]
        ] as NSArray]
    
    // MARK: - Request Sever
    func sendRequest(API_NAME:String){
        let conn = ConnectionManager()
        conn.delegate = self
        let dic = NSMutableDictionary()
        dic.setValue("KF_CHECKEXISTFILE", forKey: "API_KEY")
        dic.setValue("IMG_0008.JPG", forKey: "FILE_NAME")
//        let dic1 = NSMutableDictionary()
//        dic1.setValue("tiger11", forKey: "USER_ID")
//        dic.setObject(dic1, forKey: "REQ_DATA")
        conn.sendTranData(dic as [NSObject : AnyObject])
    }
    func returnResultWithData(data: NSData!) {
        do {
            let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String: AnyObject]
            print(jsonDictionary)
        } catch let error {
            print("JSON Serialization failed. Error: \(error)")
        }
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Share To Friend"
        
        checkSearch = false
        
        mainScrollHeigthConstraint.constant = 0
        mainScrollVIew.showsHorizontalScrollIndicator = false
        
        sendRequest("")
    }
    
    // MARK: - Server Action Area
//    func SendTrat(API_NAME:String){
//        let dataDicSend = NSMutableDictionary()
//        
//        if(API_NAME == "CAMCHAT_LSTFRNDCRM"){
//            dataDicSend.setValue(API_NAME,                          forKey: "KEY")
//            dataDicSend.setValue(SingleTonManager.ShareSingleTonManager().userID,      forKey: "USR_ID")
//        }else if(API_NAME == ""){
//            
//            
//        }
//        super.sendTransaction(dataDicSend as [NSObject : AnyObject])
//    }
//    override func returnTransaction(responseDictionary: [NSObject : AnyObject]!, success: Bool) {
//        if(success){
//            if(responseDictionary == nil){
//                return
//            }
//            if(responseDictionary["KEY_API"] as! String == "CAMCHAT_LSTFRNDCRM"){
//                
//                dicData = responseDictionary
//                print(dicData)
//                mainTableView.reloadData()
//            }else {
//                
//            }
//        }else{
//            SysUtils.showMessage("Check your information Again")
//        }
//    }
    
    // MARK: - Header View Management
    // MARK: -
    func headerDelItem() {
        var userSelectImageV    : UIImageView
        var sectionTitleBt      : UIButton
        var userTitleLabel      : UILabel
        var userDelImageV       : UIImageView
        
        var dataIncreaseInt = 0
        
        for _ in testArr.reverse() {
            userSelectImageV = view.viewWithTag(15000 + dataIncreaseInt) as! UIImageView!
            sectionTitleBt   = view.viewWithTag(20000 + dataIncreaseInt) as! UIButton!
            userTitleLabel   = view.viewWithTag(25000 + dataIncreaseInt) as! UILabel!
            userDelImageV    = view.viewWithTag(30000 + dataIncreaseInt) as! UIImageView
            
            sectionTitleBt.removeFromSuperview()
            userTitleLabel.removeFromSuperview()
            userDelImageV.removeFromSuperview()
            userSelectImageV.removeFromSuperview()
            
            dataIncreaseInt++
        }
        mainScrollVIew.contentSize = CGSizeMake(11 +  CGFloat(66 * dataIncreaseInt), 90)
        
    }
    
    func headerBtAction(sender:UIButton) {
        headerDelItem()
        testArr.removeAtIndex(sender.tag - 20000)
        headerAddItem()
        
    }
    func headerAddItem() {
        var userSelectImageV    : UIImageView
        var sectionTitleBt      : UIButton
        var userTitleLabel      : UILabel
        var userDelImageV       : UIImageView
        
        var dataIncreaseInt = 0

        for _ in testArr.reverse() {
            userSelectImageV = UIImageView(frame:  CGRectMake(16.0 + CGFloat(66 * dataIncreaseInt), 12, 40, 40))
            if(AppUtils.isNull(testArr[dataIncreaseInt]["FILE_NM"])){
                userSelectImageV.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage(named: "no_image.jpeg"))
            }else{
                userSelectImageV.sd_setImageWithURL(NSURL(string: "Testing"), placeholderImage: UIImage(named: "no_image.jpeg"))
            }
            userSelectImageV.backgroundColor      = UIColor.clearColor()
            userSelectImageV.tag                  = 15000 + dataIncreaseInt
            userSelectImageV.layer.masksToBounds  = true;
            userSelectImageV.layer.cornerRadius   = 20;
            userSelectImageV.layer.borderColor    = UIColor.blackColor().CGColor
            userSelectImageV.layer.borderWidth    = 1
            mainScrollVIew.addSubview(userSelectImageV)
 
            sectionTitleBt                      = UIButton(frame:  CGRectMake(16.0 + CGFloat(66 * dataIncreaseInt), 1, 41, 41))
            sectionTitleBt.backgroundColor      = UIColor.clearColor()
            sectionTitleBt.addTarget(self, action: Selector("headerBtAction:"), forControlEvents: .TouchUpInside)
            sectionTitleBt.tag                  = 20000 + dataIncreaseInt
            mainScrollVIew.addSubview(sectionTitleBt)
            
            userTitleLabel                      = UILabel(frame: CGRectMake(6 + CGFloat(66 * dataIncreaseInt), 53, 61, 16))
            userTitleLabel.font                 = UIFont(name: "Helvetica", size: 11)
            userTitleLabel.textColor            = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1.0)
            userTitleLabel.backgroundColor      = UIColor.clearColor()
            userTitleLabel.textAlignment        = .Center
            userTitleLabel.tag                  = 25000 + dataIncreaseInt
            userTitleLabel.text                 = testArr[dataIncreaseInt].valueForKey("FULL_NAME") as? String
            mainScrollVIew.addSubview(userTitleLabel)
            
            userDelImageV = UIImageView(frame:  CGRectMake(41 + CGFloat(66 * dataIncreaseInt), 5, 20, 20))
            userDelImageV.backgroundColor       = UIColor.whiteColor()
            let userSelectDelImage              = UIImage(named: "pop_close_btn.png")
            userDelImageV.image                 = userSelectDelImage;
            userDelImageV.tag                   = 30000 + dataIncreaseInt
            mainScrollVIew.addSubview(userDelImageV)
            
            
            dataIncreaseInt++
        }
        mainScrollVIew.contentSize = CGSizeMake(11 +  CGFloat(66 * dataIncreaseInt), 60)
        
        if(testArr.count > 0){
            mainScrollHeigthConstraint.constant = 70
        }else{
            mainScrollHeigthConstraint.constant = 0
        }
        mainTableView.reloadData()
    }
    
    // MARK: - Search Delegate Method -
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        
        searchBar.setShowsCancelButton(true, animated: false)
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        
        filterContentForSearchText(searchText)
    }
    func filterContentForSearchText(searchText: String) {
        if(searchText == ""){
            checkSearch = false
        }else{
            let arr:NSArray = dicData["RECORDS"] as! NSArray
            let pre : NSPredicate = NSPredicate(format: "FULL_NAME CONTAINS[c] %@", searchText)
            resultDicData = arr.filteredArrayUsingPredicate(pre)
            checkSearch = true
        }
        mainTableView.reloadData()
    }
    
    // MARK: - UITableView Method Area
    // MARK: -
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int                       {
        if (checkSearch == false){
            if(dicData.count != 0){
                if(dicData["COUNT"]?.integerValue! != 0){
                    return (dicData["COUNT"]?.integerValue!)!
                }
            }
        }else{
            return resultDicData.count
        }
        return 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("addNewChatCell", forIndexPath: indexPath) as! AddNewChatCellView
        cell.btnCheck.addTarget(self, action: "TickImageAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        if (checkSearch == false){
            if(dicData.count != 0){
                if(dicData["COUNT"]?.integerValue! != 0){
                    
                    cell.btnCheck.selected = false
                    for dataDic in testArr {
                        if dataDic["FULL_NAME"] == dicData["RECORDS"]![indexPath.row]["FULL_NAME"]{
                            cell.btnCheck.selected = true
                        }
                    }
                    
                    
                    cell.lblName.text = dicData["RECORDS"]![indexPath.row].valueForKey("FULL_NAME") as? String
                    
                    if(AppUtils.isNull(dicData["RECORDS"]![indexPath.row]["FILE_NM"])){
                        cell.imageMe.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage(named: "person_icon.png"))
                    }else{
                        cell.imageMe.sd_setImageWithURL(NSURL(string: "Testing"), placeholderImage: UIImage(named: "person_icon.png"))
                    }
                }
            }
        }else{
            
            cell.btnCheck.selected = false
            for dataDic in testArr {
                if dataDic["FULL_NAME"] == resultDicData[indexPath.row]["FULL_NAME"]{
                    cell.btnCheck.selected = true
                }
            }
            cell.lblName.text = resultDicData[indexPath.row].valueForKey("FULL_NAME") as? String
           
            if(AppUtils.isNull(resultDicData[indexPath.row]["FILE_NM"])){
                cell.imageMe.sd_setImageWithURL(NSURL(string: ""), placeholderImage: UIImage(named: "person_icon.png"))
            }else{
                cell.imageMe.sd_setImageWithURL(NSURL(string: "Testing"), placeholderImage: UIImage(named: "person_icon.png"))
            }
        }
        
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)                  {
        headerDelItem()
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let cell = mainTableView.cellForRowAtIndexPath(indexPath)
        let checkedButton = cell!.contentView.viewWithTag(22) as? UIButton
        
        if(checkedButton!.selected == false){
            checkedButton?.selected = true
            if (checkSearch == false){
                testArr.append(dicData["RECORDS"]![indexPath.row])
            }else{
                testArr.append(resultDicData[indexPath.row])
            }
        }else{
            checkedButton?.selected = false
            
            var selectCellArrInt : Int = 0;
            for dataDic in testArr {
                if (checkSearch == false){
                    if dataDic.objectForKey("FULL_NAME") as? String == dicData["RECORDS"]![indexPath.row]["FULL_NAME"]{
                        testArr.removeAtIndex(selectCellArrInt)
                    }
                }else{
                    if dataDic.objectForKey("FULL_NAME") as? String == resultDicData[indexPath.row]["FULL_NAME"]{
                        testArr.removeAtIndex(selectCellArrInt)
                    }
                }
                selectCellArrInt++
            }
        }
        if(testArr.count > 0){
            mainScrollHeigthConstraint.constant = 70
        }else{
            mainScrollHeigthConstraint.constant = 0
        }
        
        headerAddItem()
        
    }
    
    // MARK: - Button Action
    // MARK: -
    func TickImageAction(sender: UIButton)      {
        self.headerDelItem()
        
        let touchPoint = sender.convertPoint(CGPointZero, toView: mainTableView)
        let indexPath = mainTableView.indexPathForRowAtPoint(touchPoint)
        
        let cell = mainTableView.cellForRowAtIndexPath(indexPath!)
        let checkedButton = cell!.contentView.viewWithTag(22) as? UIButton
        
        if(checkedButton!.selected == false){
            checkedButton?.selected = true
            
            if (checkSearch == false){
                testArr.append(dicData["RECORDS"]![indexPath!.row])
            }else{
                testArr.append(resultDicData[indexPath!.row])
            }
            
        }else{
            checkedButton?.selected = false
            
            var selectCellArrInt : Int = 0;
            for dataDic in testArr {
                if (checkSearch == false){
                    if dataDic.objectForKey("FULL_NAME") as? String == dicData["RECORDS"]![indexPath!.row]["FULL_NAME"] {
                        testArr.removeAtIndex(selectCellArrInt)
                    }
                }else{
                    if dataDic.objectForKey("FULL_NAME") as? String == resultDicData[indexPath!.row]["FULL_NAME"]{
                        testArr.removeAtIndex(selectCellArrInt)
                    }
                }
                selectCellArrInt++
            }
        }
        
        if(testArr.count > 0){
            mainScrollHeigthConstraint.constant = 70
        }else{
            mainScrollHeigthConstraint.constant = 0
        }
        
        headerAddItem()
    }
    @IBAction func BackAction(sender: UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}

class AddNewChatCellView: UITableViewCell {
    
    @IBOutlet var btnCheck: UIButton!
    @IBOutlet var imageMe: UIImageView!
    @IBOutlet var lblName: UILabel!
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
}