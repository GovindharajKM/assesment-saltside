//
//  UserDetailModel+CoreDataClass.swift
//  
//
//  Created by Govindharaj Murugan on 10/01/21.
//
//

import Foundation
import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let managedContext = appDelegate.persistentContainer.viewContext

@objc(UserDetailModel)
public class UserDetailModel: NSManagedObject {

    func insertAllListToDB(_ arrItem : [UserDetails]) {
        
        // Insert New Entry in table
        for item in arrItem {
            if !self.isExist(url: item.image) {
                let itemObj = NSEntityDescription.insertNewObject(forEntityName: "UserDetailModel", into: managedContext)
                self.insertManagedObject(itemObj, item: item)
            }
        }
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func isExist(url: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetailModel")
        fetchRequest.predicate = NSPredicate(format: "imageUrl = %@",url)

        let res = try! managedContext.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }
    
    private func insertManagedObject(_ itemObj: NSManagedObject, item: UserDetails) {
        
        itemObj.setValue(item.image, forKey: "imageUrl")
        itemObj.setValue(item.title, forKey: "title")
        itemObj.setValue(item.userDetailDescription, forKey: "userDescription")
    }
    
    func fetchAllListFromDB() -> [UserDetails] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetailModel")
        
        var arrFetchedItem = [UserDetails]()
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if let arrItem = results as? [UserDetailModel] {
                for item in arrItem {
                    arrFetchedItem.append(self.convertFetchedObject(user: item))
                }
            }
            return arrFetchedItem
            
        } catch let error as NSError {
            print("Could not fetch : \(error), \(error.userInfo)")
        }
        return arrFetchedItem
    }
    
    func getLimitedEntryFromDB(_ fetchOffSet: Int) -> [UserDetails] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetailModel")
        fetchRequest.fetchLimit = 30
        fetchRequest.fetchOffset = fetchOffSet
        
        var arrFetchedItem = [UserDetails]()
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if let arrItem = results as? [UserDetailModel] {
                for item in arrItem {
                    arrFetchedItem.append(self.convertFetchedObject(user: item))
                }
            }
            return arrFetchedItem
            
        } catch let error as NSError {
            print("Could not fetch : \(error), \(error.userInfo)")
        }
        return arrFetchedItem
    }
    
    func convertFetchedObject(user: UserDetailModel) -> UserDetails {
        var userObj = UserDetails()
        userObj.image = user.imageUrl ?? ""
        userObj.title = user.title ?? ""
        userObj.userDetailDescription = user.userDescription ?? ""
        return userObj
    }
    
    
    func deleteAllChatUsers() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserDetailModel")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(deleteRequest)
            try managedContext.save()
        } catch let error as NSError {
            print("Could not Delete : \(error), \(error.userInfo)")
        }
    }
    
}

extension UserDetailModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetailModel> {
        return NSFetchRequest<UserDetailModel>(entityName: "UserDetailModel")
    }

    @NSManaged public var imageUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var userDescription: String?

}
