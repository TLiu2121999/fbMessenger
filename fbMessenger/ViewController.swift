//
//  ViewController.swift
//  fbMessenger
//
//  Created by Tongtong Liu on 6/28/18.
//  Copyright © 2018 Tongtong Liu. All rights reserved.
//

import UIKit

class FriendsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        setupData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        if let message = messages?[indexPath.item] {
            cell.message = message
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        let chatLogController = ChatLogController(collectionViewLayout: layout)
        chatLogController.friend = messages?[indexPath.item].friend
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        backgroundColor = .blue
    }
}

class MessageCell: BaseCell {
    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 0, green: 134/255, blue: 249/255, alpha: 1) : .white
            nameLable.textColor = isHighlighted ? .white : .black
            messageLable.textColor = isHighlighted ? .white : .black
            timeLable.textColor = isHighlighted ? .white : .black
        }
    }
    
    var message: Message? {
        didSet {
            nameLable.text = message?.friend?.name
            messageLable.text = message?.text
            
            if let profileImageName = message?.friend?.profileImageName {
                profileImageView.image = UIImage(named: profileImageName)
                hasReadImageView.image = UIImage(named: profileImageName)
            }
            
            if let date = message?.date {
                let formatter = DateFormatter()
                formatter.dateFormat = "h:mm a"
                
                let secondPerDay: Double = 60 * 60 * 24
                let elapsedTime = Date().timeIntervalSince(date as Date)
                if (elapsedTime > 7 * secondPerDay) {
                    formatter.dateFormat = "MM/dd/yy"
                } else if (elapsedTime > secondPerDay) {
                    formatter.dateFormat = "EEE"
                }
                
                timeLable.text = formatter.string(from: date as Date)
            }
        }
    }
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    let nameLable: UILabel = {
        let nameLabel = UILabel()
        nameLabel.text = "Tongtong Liu"
        nameLabel.font = .systemFont(ofSize: 18)
        return nameLabel
    }()
    
    let messageLable: UILabel = {
        let messageLable = UILabel()
        messageLable.text = "Your friend's message and something else..."
        messageLable.textColor = .darkGray
        messageLable.font = .systemFont(ofSize: 14)
        return messageLable
    }()
    
    let timeLable: UILabel = {
        let timeLable = UILabel()
        timeLable.text = "12:20 pm"
        timeLable.font = .systemFont(ofSize: 16)
        timeLable.textAlignment = .right
        return timeLable
    }()
    
    let hasReadImageView: UIImageView = {
        let imageIcon = UIImageView()
        imageIcon.image = UIImage(named: "flora")
        imageIcon.contentMode = .scaleToFill
        imageIcon.layer.cornerRadius = 10
        imageIcon.layer.masksToBounds = true
        return imageIcon
    }()
    
    override func setupViews() {
        addSubview(profileImageView)
        addSubview(dividerLineView)
        setupContainerView()
        
        profileImageView.image = UIImage(named: "flora")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        dividerLineView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraintsWithFormat(format: "H:|-12-[v0(68)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(68)]", views: profileImageView)
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        
        addConstraintsWithFormat(format: "H:|-82-[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerLineView)
    }
    
    private func setupContainerView() {
        let containerView = UIView()
        addSubview(containerView)
        
        addConstraintsWithFormat(format: "H:|-90-[v0]|", views: containerView)
        addConstraintsWithFormat(format: "V:[v0(60)]", views: containerView)
        
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        containerView.addSubview(nameLable)
        containerView.addSubview(messageLable)
        containerView.addSubview(timeLable)
        containerView.addSubview(hasReadImageView)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLable, timeLable)
        containerView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLable, hasReadImageView)
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLable, messageLable)
        containerView.addConstraintsWithFormat(format: "V:|[v0(20)]", views: timeLable)
        
        containerView.addConstraintsWithFormat(format: "V:[v0(20)]|", views: hasReadImageView)
        print(Date.init())
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewDict = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewDict[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewDict))
    }
}



