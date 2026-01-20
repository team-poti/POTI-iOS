//
//  ImagePickerView.swift
//  POTI-iOS
//
//  Created by 박정환 on 1/14/26.
//

import UIKit
 
import SnapKit
import Then

final class ImagePickerView: BaseView {
    
    // MARK: - Property

    var onTapAdd: (() -> Void)?
    var onTapDelete: ((Int) -> Void)?

    private var images: [UIImage] = []
    private let maxImageCount = 5

    // MARK: - UI Components

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceHorizontal = false
        cv.contentInset = .zero
        return cv
    }()

    // MARK: - Custom Method
    
    override func setUI() {
        addSubview(collectionView)

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(AddCell.self)
        collectionView.register(ImageCell.self)
    }

    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    // MARK: - Custom Method

    func setImages(_ images: [UIImage]) {
        self.images = images
        collectionView.reloadData()
    }
}

 // MARK: - delegate Method

extension ImagePickerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count < maxImageCount ? (1 + images.count) : images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if images.count < maxImageCount, indexPath.item == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddCell.identifier, for: indexPath) as! AddCell
            cell.onTapUpload = { [weak self] in
                self?.onTapAdd?()
            }
            return cell
        }

        let imageIndex = images.count < maxImageCount ? indexPath.item - 1 : indexPath.item
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as! ImageCell
        cell.configure(image: images[imageIndex])
        cell.onTapDelete = { [weak self] in
            self?.onTapDelete?(imageIndex)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
}
