//
//  FriendsControllerHelper.swift
//  fbMessenger
//
//  Created by Tongtong Liu on 7/5/18.
//  Copyright © 2018 Tongtong Liu. All rights reserved.
//

import UIKit
import CoreData

extension FriendsViewController {
    
    
    func setupData() {
        clearData()
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let flora = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        flora.name = "Flora Liu"
        flora.profileImageName = "flora"
        
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = flora
        message.text = "Hi! This is Flora! Your friend's message and something else..."
        message.date = Date() as NSDate
        
        let yueyang = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        yueyang.name = "Yueyang Jiang"
        yueyang.profileImageName = "yueyang"
        
        let messageJYY = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        messageJYY.friend = yueyang
        messageJYY.text = "Hi! This is JYY! Your friend's message and something else..."
        messageJYY.date = Date() as NSDate
        
        messages = [message, messageJYY]
        
        do {
            try(context.save())
        } catch let error {
            print(error)
        }
        
        
        loadData()
    }
    
    func loadData() {
        let deleagte = UIApplication.shared.delegate as! AppDelegate
        let context = deleagte.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Message.fetchRequest()
        do {
            messages = try(context.fetch(fetchRequest)) as? [Message]
        } catch let error {
            print(error)
        }
        
    }
    
    func clearData() {
        let deleagte = UIApplication.shared.delegate as! AppDelegate
        let context = deleagte.persistentContainer.viewContext
        
        do {
            let fetchFriendRequest: NSFetchRequest<NSFetchRequestResult> = Friend.fetchRequest()
            let fetchMessageRequest: NSFetchRequest<NSFetchRequestResult> = Message.fetchRequest()
        
            let friends = try(context.fetch(fetchFriendRequest)) as? [Friend]
            let messages = try(context.fetch(fetchMessageRequest)) as? [Message]
            
            for friend in friends! {
                context.delete(friend)
            }
            
            for message in messages! {
                context.delete(message)
            }
            
            try context.save()
            
        } catch let error {
            print(error)
        }
        
    }
}
