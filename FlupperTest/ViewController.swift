//
//  ViewController.swift
//  FlupperTest
//
//  Created by Sunil Kumar on 13/08/20.
//  Copyright © 2020 UttamTech. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK:- Outlets & Variables
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    var articleArray = NSMutableArray()
    var ArrayFromDB = NSMutableArray()
    var articalModelArr : [ArticalDataModel]?
    
    //MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register Cell
        tableView.register(UINib(nibName: "DataTableViewCell", bundle: nil), forCellReuseIdentifier: "DataTableViewCell")
        
        //Fetch data from Service or Coredata
        if let serviceResponce = UserDefaults.standard.object(forKey: "serviceResponce") as? String, serviceResponce == "true"
        {
            retrieveDataFromDB()
        }else{
            GetDataFronService()
        }
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
    }
    
    //MARK:- Pull To Refress
    @IBAction func refreshData(_ sender: UIButton)
    {
        self.refreshControl.endRefreshing()
    }
    
    
    //MARK:- TableView Delegates & Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articalModelArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataTableViewCell", for: indexPath) as! DataTableViewCell
        if articalModelArr!.count > 0{
            cell.idLbl.text = self.articalModelArr?[indexPath.row].id
            cell.nameLbl.text = self.articalModelArr?[indexPath.row].name
            cell.authorLbl.text = self.articalModelArr?[indexPath.row].author
            cell.titleLbl.text = self.articalModelArr?[indexPath.row].title
            cell.descriptionLbl.text = self.articalModelArr?[indexPath.row].descriptions
            cell.nameLbl.text = self.articalModelArr?[indexPath.row].name
            cell.imagetoUrl.sd_setImage(with: URL(string: (self.articalModelArr?[indexPath.row].urlToImage)!), placeholderImage: UIImage(named: "placeholder"))
        }
        cell.selectionStyle = .none
        return cell
    }
    
    //MARK:- Get Data From WebService
    func GetDataFronService()
    {
        let baseUrl = "http://newsapi.org/v2/everything?q=bitcoin&from=2020-07-13&sortBy=publishedAt&apiKey=9726891545dd4be58139d8346d0d4e30"
        let param = NSMutableDictionary()
        AF.request(baseUrl, method: .get, parameters: param as AnyObject as? [String : AnyObject])
            .responseJSON
            { response in
                print(response)
                switch response.result {
                case .success(let value as [String: Any]):
                    print(value)
                    let data = value as NSDictionary
                    let articleArr = data.object(forKey: "articles") as! NSArray
                    self.articleArray = articleArr.mutableCopy() as! NSMutableArray
                    print(self.articleArray.count)
                    UserDefaults.standard.set("true", forKey: "serviceResponce")
                    UserDefaults.standard.synchronize()
                    self.SendDataInDB()
                case .failure(let error):
                    print(error)
                default:
                    fatalError("received non-dictionary JSON response")
                }
        }
    }
    
    //MARK:- Send Data In CoreData
    func SendDataInDB(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "ArticalDataTable", in: managedContext)!
        for i in 0..<articleArray.count {
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            let data = articleArray.object(at: i) as! NSDictionary
            if let id = (data.object(forKey: "source") as! NSDictionary).object(forKey: "id") as? String{
                user.setValue(id, forKeyPath: "id")
            }else{
                user.setValue("N/A", forKeyPath: "id")
            }
            if let name = (data.object(forKey: "source") as! NSDictionary).object(forKey: "name") as? String{
                user.setValue(name, forKeyPath: "name")
            }else{
                user.setValue("N/A", forKeyPath: "name")
            }
            if let author = (data.object(forKey: "author") as? String){
                user.setValue(author, forKeyPath: "author")
            }else{
                user.setValue("N/A", forKeyPath: "author")
            }
            if let title = (data.object(forKey: "title") as? String){
                user.setValue(title, forKeyPath: "title")
            }else{
                user.setValue("N/A", forKeyPath: "title")
            }
            if let description = (data.object(forKey: "description") as? String){
                user.setValue(description, forKeyPath: "descriptions")
            }else{
                user.setValue("N/A", forKeyPath: "descriptions")
            }
            if let urlToImage = (data.object(forKey: "urlToImage") as? String){
                user.setValue(urlToImage, forKeyPath: "urlToImage")
            }else{
                user.setValue("N/A", forKeyPath: "urlToImage")
            }
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        retrieveDataFromDB()
    }
    
    //MARK:- Recieve Data from CoreData
    func retrieveDataFromDB() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ArticalDataTable")
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "id") as! String
                let name = data.value(forKey: "name") as! String
                let author = data.value(forKey: "author") as! String
                let title = data.value(forKey: "title") as! String
                let descriptions = data.value(forKey: "descriptions") as! String
                let urlToImage = data.value(forKey: "urlToImage") as! String
                
                let tempDict = NSMutableDictionary()
                tempDict.setValue(id, forKey: "id")
                tempDict.setValue(name, forKey: "name")
                tempDict.setValue(author, forKey: "author")
                tempDict.setValue(title, forKey: "title")
                tempDict.setValue(descriptions, forKey: "descriptions")
                tempDict.setValue(urlToImage, forKey: "urlToImage")
                
                ArrayFromDB.add(tempDict)
            }
        } catch {
            print("Failed")
        }
        
        //MARK:- Send Data in Model
        self.articalModelArr = ArticalDataModel.modelsFromDictionaryArray(array: ArrayFromDB)
        tableView.reloadData()
    }
}

