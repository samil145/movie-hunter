//
//  CastCollectionView.swift
//  MovieHunter
//
//  Created by Shamil Bayramli on 19.08.24.
//

import UIKit

protocol CastCollectionViewDelegate: AnyObject
{
    func PersonDidTapped(personID: Int)
}

class CastCollectionView: UIView {
    
    var castAndCrew: [CastCollectionModel] = []
    
    weak var delegate: CastCollectionViewDelegate?
    
    let collectionView: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 215)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(CastCell.self, forCellWithReuseIdentifier: CastCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = self.bounds
    }
    
    func configure(castAndCrew: [CastCollectionModel])
    {
        self.castAndCrew = castAndCrew
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.collectionView.reloadData()
        }
    }
    
}

extension CastCollectionView: UICollectionViewDelegate, UICollectionViewDataSource
{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.identifier, for: indexPath) as? CastCell else { return UICollectionViewCell() }
        
        cell.configure(posterURL: castAndCrew[indexPath.item].posterURL, name: castAndCrew[indexPath.item].name, roleName: castAndCrew[indexPath.item].roleName)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castAndCrew.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let personID = castAndCrew[indexPath.item].id
        delegate?.PersonDidTapped(personID: personID)
    }
}
