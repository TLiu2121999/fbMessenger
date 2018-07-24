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
        
        //=========== Flora ==============
        let flora = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        flora.name = "Flora Liu"
        flora.profileImageName = "flora"
        
        createMessageWithText(text: "Hi! Hi! This is Flora! Your friend's message and something else...", friend: flora, context: context, minutesAgo: 3)
        
        //=========== Yueyang ==============
        let yueyang = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        yueyang.name = "Yueyang Jiang"
        yueyang.profileImageName = "yueyang"
        
        createMessageWithText(text: "Hi! This is JYY! Your friend's message and something else...", friend: yueyang, context: context, minutesAgo: 3)
        createMessageWithText(text: "Hi Good Morning! 我是一只小猪", friend: yueyang, context: context, minutesAgo: 2)
        createMessageWithText(text: "Hi What do you want to eat! 我是猪八噜咕噜鸡", friend: yueyang, context: context, minutesAgo: 1)
        
        //=========== Trump ==============
        let trump = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        trump.name = "Donald Trump"
        trump.profileImageName = "trump"
        
        createMessageWithText(text: "You are FIRED!", friend: trump, context: context, minutesAgo: 8 * 24 * 60)
        
        //=========== Steve ==============
        createSteveMessageWithContext(context: context)
        
        do {
            try(context.save())
        } catch let error {
            print(error)
        }
        
        loadData()
    }
    
    private func createSteveMessageWithContext(context: NSManagedObjectContext) {
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: context) as! Friend
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve"
        
        createMessageWithText(text: "Good Morning!", friend: steve, context: context, minutesAgo: 1)
        createMessageWithText(text: "Good Morning! Do you like to buy an Apple Product?", friend: steve, context: context, minutesAgo: 1)
        createMessageWithText(text: "Good Afternoon! Do you like to buy an Apple Product? Do you like to buy an Apple Product? Do you like to buy an Apple Product? Do you like to buy an Apple Product? Do you like to buy an Apple Product?", friend: steve, context: context, minutesAgo: 1)
        createMessageWithText(text: "Good Morning!", friend: steve, context: context, minutesAgo: 1)
        createMessageWithText(text: "Good Morning! Do you like to buy an Apple Product?", friend: steve, context: context, minutesAgo: 1)
        createMessageWithText(text: "Good Afternoon! Do you like to buy an Apple Product? Do you like to buy an Apple Product? Do you like to buy an Apple Product? Do you like to buy an Apple Product? Do you like to buy an Apple Product?", friend: steve, context: context, minutesAgo: 1)
        createMessageWithText(text: "Good Morning!", friend: steve, context: context, minutesAgo: 1)
        createMessageWithText(text: "Good Morning! Do you like to buy an Apple Product?", friend: steve, context: context, minutesAgo: 1)
        createMessageWithText(text: "Good Afternoon! Do you like to buy an Apple Product? Do you like to buy an Apple Product? Do you like to buy an Apple Product? Do you like to buy an Apple Product? Do you like to buy an Apple Product?", friend: steve, context: context, minutesAgo: 1)
        
        createMessageWithText(text: "Yeap! Totally! Can't wait for iPhone 2000!", friend: steve, context: context, minutesAgo: 1, isSender: true)
        
    }
    
    private func createMessageWithText(text: String, friend: Friend, context: NSManagedObjectContext, minutesAgo: Double, isSender: Bool = false) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.friend = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60)
        message.isSender = isSender as NSNumber
    }
    
    func loadData() {
        let deleagte = UIApplication.shared.delegate as! AppDelegate
        let context = deleagte.persistentContainer.viewContext
        
        if let friends = fetchFriends() {
            messages = [Message]()
            
            for friend in friends {
                let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Message.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                fetchRequest.predicate = NSPredicate(format: "friend.name = %@", friend.name!)
                fetchRequest.fetchLimit = 1
                
                do {
                    let fetchedMessages = try(context.fetch(fetchRequest)) as! [Message]
                    messages?.append(contentsOf: fetchedMessages)
                } catch let error {
                    print(error)
                }
            }
            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
        }
    }
    
    private func fetchFriends() -> [Friend]? {
        let deleagte = UIApplication.shared.delegate as! AppDelegate
        let context = deleagte.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Friend.fetchRequest()
        do {
            return try(context.fetch(fetchRequest)) as? [Friend]
        } catch let error {
            print(error)
        }
        
        return nil
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
