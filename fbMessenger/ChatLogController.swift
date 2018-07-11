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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

class ChatLogMessageCell: BaseCell {
    let messgaeTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.text = "text"
        return textView
    }()
    
    override func setupViews() {
        super.setupViews()
        addSubview(messgaeTextView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: messgaeTextView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: messgaeTextView)
    }
}
