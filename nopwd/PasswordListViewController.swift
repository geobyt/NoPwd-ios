//
//  PasswordListViewController.swift
//  nopwd
//
//  Created by George on 3/15/15.
//  Copyright (c) 2015 George. All rights reserved.
//

import UIKit

class PasswordListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    //var someData: [(String, String)] = []// = [{"facebook", "fb"}, {"gmail", "gm"}, {"brickset", "bs"}]
    var filePath: String?
    var userName: String?
    var pwdDictionary: NSDictionary?
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, user userName: String?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.userName = userName
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: "PasswordListTableViewCell", bundle: nil), forCellReuseIdentifier: "PasswordListTableViewCell")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self

        //someData.append("facebook", "fb")
        //someData.append("gmail", "gm")
        //someData.append("brickset", "bs")
        
        //self.tableView.reloadData()
        
        self.setupUserDirectory()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        var addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addPassword")
        navigationItem.rightBarButtonItem = addButton
        
        self.prepareData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setupUserDirectory()
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documents: AnyObject = paths[0]

        self.filePath = documents.stringByAppendingPathComponent(self.userName!)
        var fileManager: NSFileManager = NSFileManager.defaultManager()

        if (fileManager.fileExistsAtPath(self.filePath!))
        {
            print("Directory already present.")
        }
        else
        {
            var error: NSError?
            fileManager.createDirectoryAtPath(self.filePath!, withIntermediateDirectories: true, attributes: nil, error: &error)
            
            if error != nil
            {
                println("Unable to create directory for user.")
            }
        }
    }
    
    func prepareData()
    {
        //self.someData = []
        pwdDictionary = NSDictionary()
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        
        var error: NSError?
        let contents = fileManager.contentsOfDirectoryAtPath(self.filePath!, error: &error)
        
        if (contents?.count > 0 && error == nil)
        {
            println(NSString(format: "Contents of the user's directory: %@", contents!))
            
            for fileName in contents! as [String]
            {
                if ![fileName.rangeOfString(".securedData")?].isEmpty
                {
                    var file: String = self.filePath!.stringByAppendingPathComponent(fileName)
                    //var data: NSData = NSData.dataWithContentsOfMappedFile("")
                    let data = NSData(contentsOfFile: file)
                    var decryptedData = RNDecryptor.swiftDecryptData(data, password:"A_SECRET_PASSWORD", error: nil)
                    
                    self.pwdDictionary = self.parseJSON(decryptedData)
                }
                else
                {
                    println("This file is not secured.")
                }
            }
        }
        else if contents?.count <= 0
        {
            if error == nil
            {
                println("The user's directory is empty.")
            }
            else
            {
                println("Unable to read the contents of the user's directory.")
            }
        }
    }
    
    func addPassword()
    {
        let addPasswordListView = AddPasswordViewController(nibName: "AddPasswordViewController", bundle: nil, user: self.userName, path: self.filePath, pwds: pwdDictionary!)
        self.navigationController?.pushViewController(addPasswordListView, animated: true)
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary
    {
        var error: NSError?
        
        var pwdDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        println(pwdDictionary)
        
        return pwdDictionary
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pwdDictionary!.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("PasswordListTableViewCell", forIndexPath: indexPath) as PasswordListTableViewCell
        
        var allKeys = self.pwdDictionary!.allKeys as Array
        var entity = allKeys[indexPath.row] as String
        
        cell.entityLabel.text = entity
        cell.passwordLabel.text = self.pwdDictionary?[entity] as? String
        
        return cell
    }
}
