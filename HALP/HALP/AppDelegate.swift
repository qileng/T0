//
//  AppDelegate.swift
//  HALP
//

//  Created by Qihao Leng Haozhi Flik Huon Zach Sun 4/27/18.

//  Copyright © 2018 Team Zero. All rights reserved.
//
//  Anagha - test for pushing to github <<DELETE THIS>>
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    var client: MSClient?
//    var query:  MSQuery?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        self.client = MSClient(
//            applicationURLString:"https://halpt0.azurewebsites.net"
//        )
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//       //self.store = MSCoreDataStore(managedObjectContext: managedObjectContext)
//        let client = delegate.client!
//        let item = ["id":"3", "username": "test user 2"]
//        let userTable = client.table(withName: "User")
//        let taskTable = client.table(withName: "Task")
////
//        itemTable.insert(item){
//            (insertedItem, error) in
//            if (error != nil) {
//                print("\n")
//                print("Error" + error.debugDescription);
//            }
//        }
//
//        let predicate = NSPredicate(format: "username == 'test user 2'@");
//        let query = itemTable.query(with: predicate)
//        itemTable.pull(with: query, queryId: "AllRecords"){
//                (error)  -> Void in
//            if (error != nil) {
//                print("\n")
//                print("Error" + error.debugDescription);
//            }
//        }
        //let item2 = ["id":"1","username": "test user 2"]
        
//        query = itemTable.queryWithPredicate(){
//            (item2, error) in
//        if (error != nil) {
//            print("\n")
//            print("Error" + error.debugDescription);
//            }
//        }
        // read with query string, try to load the data from the same user .
//        let readId = ["id":"1"]
//        itemTable.readWithId(readId){
//            (query, error) in
//            if (error != nil) {
//                print("\n")
//                print("Error" + error.debugDescription);
//            }
//        }
        
//        itemTable.delete(item){
//            (deletedItem, error) in
//            if (error != nil) {
//                print("\n")
//                print("Error" + error.debugDescription);
//            }
//        }
//        let item2 = ["id":"1", "password": "test password"]
//        itemTable.update(item2){
//            (deletedItem, error) in
//            if (error != nil) {
//                print("\n")
//                print("Error" + error.debugDescription);
//            }
//        }
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(_ application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}
    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "HALPT0", withExtension: "momd")!
        print("created managedObjectModel")
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("HALP.sqlite")
        print("getting url")
        print(url)
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            let options = [ NSInferMappingModelAutomaticallyOption : true,
                            NSMigratePersistentStoresAutomaticallyOption : true]
           // print("trying to add persistant store")
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: options)
            //print("done to add persistant store")
        } catch var error1 as NSError {
            error = error1
            coordinator = nil
            
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        print("coordinator")
        if coordinator == nil {
            print("nil")
            return nil
        }
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
}

