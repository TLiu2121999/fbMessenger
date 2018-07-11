//
//  ChatLogController.swift
//  fbMessenger
//
//  Created by Tongtong Liu on 7/10/18.
//  Copyright © 2018 Tongtong Liu. All rights reserved.
//

import UIKit
class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    var messages: [Message]?
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            messages = friend?.messages?.allObjects as? [Message]
            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogMessageCell
        cell.messgaeTextView.text = messages?[indexPath.item].text
        
        if let messageText = messages?[indexPath.item].text, let profileImageName = messages?[indexPath.item].friend?.profileImageName {
            cell.profileImageView.image = UIImage(named: profileImageName)
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            cell.messgaeTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
            cell.textBubbleView.frame = CGRect(x: 48, y: 0, width: estimatedFrame.width + 16 + 8, height: estimatedFrame.height + 20)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let messageText = messages?[indexPath.item].text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(8, 0, 0, 0)
    }
}

class ChatLogMessageCell: BaseCell {
    let messgaeTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "text"
        textView.backgroundColor = .clear
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(textBubbleView)
        addSubview(messgaeTextView)
        
        addSubview(profileImageView)
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
        profileImageView.backgroundColor = .red
    }
}
