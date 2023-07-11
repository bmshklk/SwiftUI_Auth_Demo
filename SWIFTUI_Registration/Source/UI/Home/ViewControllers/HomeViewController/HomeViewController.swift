//
//  HomeViewController.swift
//  MainTarget
//
//  Created by o.sander on 29.06.2023.
//  
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Int, HomeItemVM>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, HomeItemVM>
    typealias MenuAction = (_ controller: HomeViewController) -> Void
    var menuAction: MenuAction?

    @IBOutlet private var menuButton: UIButton!
    @IBOutlet private var collectionView: UICollectionView!

    private lazy var datasource: DataSource = {
        DataSource(collectionView: collectionView) { collectionView, indexPath, model in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "home_item_cell", for: indexPath)
            cell.contentConfiguration = UIHostingConfiguration(content: {
                HomeItemCell(item: model)
            })
            cell.backgroundColor = .clear
            return cell
        }
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func handleMenuTap(sender: UIButton) {
        menuAction?(self)
    }
}

// MARK: -
// MARK: Private
private extension HomeViewController {

    func setupUI() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "home_item_cell")
        view.backgroundColor = UIColors.backgoundColor
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.backgroundColor = UIColors.backgoundColor
        collectionView.setCollectionViewLayout(HomeViewController.layout(), animated: false)
        let snapshot = snapshot(with: HomeItemVM.items)
        datasource.apply(snapshot, animatingDifferences: false)
        menuButton.tintColor = UIColors.primary
    }

    func snapshot(with cellVMs: [HomeItemVM]) -> Snapshot {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(cellVMs)
        return snapshot
    }
}

extension HomeViewController {
    static func layout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0 / 4.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.top = 10
        section.contentInsets.leading = 20
        section.contentInsets.trailing = 20
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
