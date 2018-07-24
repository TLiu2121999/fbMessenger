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
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    lazy var sendButton: UIButton = {
    
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your message ..."
        return textField
    }()
    
    var bottomConstrain: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(simulateMessage))
        
        tabBarController?.tabBar.isHidden = true
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        
        layoutTextView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            let isKeyboardShowing = notification.name == .UIKeyboardWillShow
            bottomConstrain?.constant = isKeyboardShowing ? -(keyboardFrame?.height)! : 0
            UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: {(completed) in
                if isKeyboardShowing {
                    let indexPath = NSIndexPath(item: (self.messages?.count)! - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: false)
                    
                }
            })
        }
    }
    
    @objc func dismissKeyboard() {
        inputTextField.resignFirstResponder()
    }
    
    @objc func simulateMessage() {
        
    }
    
    @objc func handleSend() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let message = FriendsViewController.createMessageWithText(text: inputTextField.text!, friend: friend!, context: context , minutesAgo: 0, isSender: true)
        do {
            try context.save()
            
            messages?.append(message)
            let item = (messages?.count)! - 1
            let insertionIndexPath = NSIndexPath(item: item, section: 0)
            collectionView?.insertItems(at: [insertionIndexPath as IndexPath])
            collectionView?.scrollToItem(at: insertionIndexPath as IndexPath, at: .bottom, animated: true)
            inputTextField.text = nil
        } catch let error {
            print(error)
        }
    }
    
    func layoutTextView() {
        view.addSubview(messageInputContainerView)
        messageInputContainerView.translatesAutoresizingMaskIntoConstraints = false
        
//        var bottomAnchor = view.bottomAnchor
//        if #available(iOS 11.0, *) {
//            bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
//        }
//        bottomConstrain = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
//
//        NSLayoutConstraint.activate([
//            messageInputContainerView.topAnchor.constraint(equalTo: bottomAnchor, constant: -48),
//            messageInputContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            messageInputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            messageInputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomConstrain!
//        ])

        
        
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)
        bottomConstrain = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstrain!)
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        messageInputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: sendButton)
        
        messageInputContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)
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
        
        if let message = messages?[indexPath.item], let messageText = message.text, let profileImageName = message.friend?.profileImageName {
            cell.profileImageView.image = UIImage(named: profileImageName)
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            guard message.isSender != nil else { return cell }
            if !message.isSender!.boolValue {
                cell.messgaeTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 10)
                
                cell.profileImageView.isHidden = false
                cell.bubbleImageView.image = ChatLogMessageCell.leftBubbleImage
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                
            } else {
                cell.messgaeTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 26, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
                
                cell.profileImageView.isHidden = true
                cell.bubbleImageView.image = ChatLogMessageCell.rightBubbleImage
                cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
                cell.messgaeTextView.textColor = .white
            }
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
        //view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    static let leftBubbleImage = UIImage(named: "chaticon")?.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    
    static let rightBubbleImage = UIImage(named: "iconsent")?.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    
    let bubbleImageView: UIImageView = {
        let view = UIImageView()
        view.image = ChatLogMessageCell.leftBubbleImage
        view.tintColor = UIColor(white: 0.90, alpha: 1)
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
        
        textBubbleView.addSubview(bubbleImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
}
