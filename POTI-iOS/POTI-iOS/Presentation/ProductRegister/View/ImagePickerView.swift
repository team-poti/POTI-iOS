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

    private let errorStackView = UIStackView()
    private let errorIconView = UIImageView()
    private let errorLabel = UILabel()

    private var errorStackHeightConstraint: Constraint?
    private var collectionBottomConstraint: Constraint?
    private var errorBottomConstraint: Constraint?

    // MARK: - Custom Method
    
    override func setUI() {
        addSubviews(collectionView, errorStackView)

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AddCell.self)
        collectionView.register(ImageCell.self)

        errorStackView.do {
            $0.axis = .horizontal
            $0.spacing = 0
            $0.alignment = .center
            $0.distribution = .fill
            $0.isHidden = true
        }

        errorIconView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = .icnNotice
            $0.tintColor = .sementicRed
        }

        errorLabel.do {
            $0.font = PotiFontManager.body14m.font
            $0.textColor = .sementicRed
            $0.numberOfLines = 0
        }
        
        errorStackView.addArrangedSubviews(errorIconView, errorLabel)
    }

    override func setLayout() {
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(90)
            collectionBottomConstraint = $0.bottom.equalToSuperview().constraint
        }

        errorIconView.snp.makeConstraints {
            $0.size.equalTo(24)
        }

        errorStackView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            errorStackHeightConstraint = $0.height.equalTo(0).priority(999).constraint
            errorBottomConstraint = $0.bottom.equalToSuperview().constraint
        }

        errorBottomConstraint?.deactivate()
    }

    // MARK: - Custom Method

    func setImages(_ images: [UIImage]) {
        self.images = images
        collectionView.reloadData()
    }

    func showError(_ message: String) {
        errorLabel.text = message
        errorStackView.isHidden = false

        collectionBottomConstraint?.deactivate()
        errorBottomConstraint?.activate()
        errorStackHeightConstraint?.deactivate()

        setNeedsLayout()
        superview?.layoutIfNeeded()
    }

    func hideError() {
        errorLabel.text = nil

        errorStackHeightConstraint?.activate()

        errorBottomConstraint?.deactivate()
        collectionBottomConstraint?.activate()

        errorStackView.isHidden = true

        setNeedsLayout()
        superview?.layoutIfNeeded()
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
