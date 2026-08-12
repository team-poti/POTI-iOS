//
//  ImagePickerView.swift
//  POTI-iOS
//
//  Created by soomin on 8/7/26.
//

import UIKit

import SnapKit
import Then

final class ImagePickerView: BaseView {
    
    // MARK: - Properties
    
    var onTapAdd: (() -> Void)?
    var onTapDelete: ((Int) -> Void)?
    private var images: [UIImage] = []
    private var canAddImage: Bool { images.count < 5 }
    
    // MARK: - UI Components
    
    private let contentStackView = UIStackView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeCollectionViewLayout())
    private let validationErrorView = ValidationErrorView()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setDelegate()
        register()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    
    override func setStyle() {
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.alignment = .fill
        }
        
        collectionView.do {
            $0.backgroundColor = .clear
            $0.showsHorizontalScrollIndicator = false
            $0.alwaysBounceHorizontal = false
            $0.contentInset = .zero
        }
    }
    
    override func setUI() {
        addSubview(contentStackView)
        contentStackView.addArrangedSubviews(collectionView, validationErrorView)
    }
    
    override func setLayout() {
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.height.equalTo(90)
        }
    }
    
    // MARK: - Private Methods
    
    private func setDelegate() {
        collectionView.dataSource = self
    }
    
    private func register() {
        collectionView.register(ImageAddCell.self)
        collectionView.register(SelectedImageCell.self)
    }
    
    private func makeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90, height: 90)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 0
        return layout
    }
    
    // MARK: - Public Methods
    
    func setImages(_ images: [UIImage]) {
        self.images = Array(images.prefix(5))
        if !self.images.isEmpty {
            hideValidationError()
        }
        collectionView.reloadData()
    }
    
    func showValidationError(_ message: String) {
        validationErrorView.setMessage(message)
    }
    
    func hideValidationError() {
        validationErrorView.setMessage(nil)
    }
}

// MARK: - UICollectionViewDataSource

extension ImagePickerView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        canAddImage ? images.count + 1 : images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if canAddImage, indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageAddCell.identifier, for: indexPath) as? ImageAddCell else {
                return UICollectionViewCell()
            }
            cell.onTapAdd = { [weak self] in self?.onTapAdd?() }
            return cell
        }
        
        let imageIndex = canAddImage ? indexPath.item - 1 : indexPath.item
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedImageCell.identifier, for: indexPath) as? SelectedImageCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(image: images[imageIndex])
        cell.onTapDelete = { [weak self] in self?.onTapDelete?(imageIndex) }
        return cell
    }
}
