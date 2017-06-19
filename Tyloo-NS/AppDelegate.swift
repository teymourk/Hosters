//
//  AppDelegate.swift
//  Tyloo-NS
//
//  Created by Kiarash Teymoury on 6/11/16.
//  Copyright © 2016 Kiarash Teymoury. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import FirebaseInstanceID
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var Home:HomePage?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //let formatter = DateFormatter()
        // formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        //let olddate = formatter.date(from: "2017-01-01 7:00:00 +0000") //This Will Be Date of launch
        
        let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .horizontal
        
        window?.rootViewController = UINavigationController(rootViewController: HomeAudit(collectionViewLayout: layout))
        
        //Tabbar Changes
        UITabBar.appearance().tintColor = orange
        UITabBar.appearance().barTintColor = darkGray
        
        //NavigationBar Changes
        UINavigationBar.appearance().barTintColor =  darkGray
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "Prompt", size:20)!]

        //UINavigationShadow
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        application.statusBarStyle = .lightContent
        
        //deleteRecords()
        loadDataFromFacebook(date: Date())
        
        if Reachability.isInternetAvailable() {
            
        }
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let handled: Bool = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        // Add any custom logic here.
        return handled
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        FIRMessaging.messaging().disconnect()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        CoreDataStack.coreData.saveContext()
    }
    
    fileprivate func checkDataExistince() {
        
        let request: NSFetchRequest<Events> = Events.fetchRequest()
        
        do {
            
            let eventCount = try context.count(for: request)
            
            if eventCount == 0 {
                
                loadDataFromFacebook(date: Date())
            }
            
        } catch {
            fatalError("Error In Counting # Of Events")
        }
    }
    
    fileprivate func loadDataFromFacebook(date:Date) {
        
        let parameters = ["fields": "cover, attending_count, can_guests_invite, description, name, id, maybe_count, noreply_count, interested_count, start_time , end_time, declined_count, owner, place, rsvp_status, guest_list_enabled"]
        
        var types = ["not_replied", "attending", "maybe"]
        
        for i in 0..<types.count {
            
            let type = types[i]
            
            FBSDKGraphRequest(graphPath: "/me/events/\(type)", parameters: parameters).start { (connection, results, error) in
                
                if error != nil {
                    print(error ?? "")
                    return
                }
                
                if let result = results as? NSDictionary, let dataArray = result["data"] as? NSArray {
                    
                    for arrayObj in dataArray {
                        
                        if let eventsDic = arrayObj as? NSDictionary {
                            
                            _ = Events.handleInitzialingEventsData(dictionary: eventsDic)
                        }
                    }
                }
            }
        }
    }
    
    func deleteRecords() {
        
        let eventsRequest:NSFetchRequest<Events> = Events.fetchRequest()
        
        var deleteRequest:NSBatchDeleteRequest
        var deleteResults:NSPersistentStoreResult
        
        do {
            
            deleteRequest = NSBatchDeleteRequest(fetchRequest: eventsRequest as! NSFetchRequest<NSFetchRequestResult>)
            deleteResults = try context.execute(deleteRequest)
            
        } catch {
            fatalError("Failed To Remove Existing Record")
        }
    }
}

let context = CoreDataStack.coreData.persistentContainer.viewContext
