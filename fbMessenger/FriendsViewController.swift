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
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.register(FriendsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
}

class FriendsCell: BaseCell {
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
    
    let imageIcon: UIImageView = {
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
        containerView.addSubview(imageIcon)
        
        containerView.addConstraintsWithFormat(format: "H:|[v0][v1(80)]-12-|", views: nameLable, timeLable)
        containerView.addConstraintsWithFormat(format: "H:|[v0]-8-[v1(20)]-12-|", views: messageLable, imageIcon)
        containerView.addConstraintsWithFormat(format: "V:|[v0][v1(24)]|", views: nameLable, messageLable)
        containerView.addConstraintsWithFormat(format: "V:|[v0(20)]", views: timeLable)
        
        containerView.addConstraintsWithFormat(format: "V:[v0(20)]|", views: imageIcon)
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

