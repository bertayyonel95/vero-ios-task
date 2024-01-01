//
//  HomeController.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 30.12.2023.
//

import UIKit
import SnapKit

// MARK: - HomeController
final class HomeController: UIViewController {
    // MARK: Typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Section, HomeCollectionViewCellViewModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, HomeCollectionViewCellViewModel>
    
    private var viewModel: HomeViewModelInput
    private var snapshot = NSDiffableDataSourceSnapshot<Section, HomeCollectionViewCellViewModel>()
    private lazy var dataSource = generateDatasource()
    
    private let refreshControl = UIRefreshControl()
    
    // MARK: Views
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.searchTextField.placeholder = "Search"
        searchBar.showsBookmarkButton = true
        searchBar.backgroundImage = UIImage()
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.minimumLineSpacing = 20
        collectionViewLayout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.width/3)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.backgroundColor = .red
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.alwaysBounceVertical = true
        collectionView.refreshControl = refreshControl
        return collectionView
    }()
    
    init(viewModel: HomeViewModelInput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: .main)
        self.viewModel.output = self
    }
    
    // MARK: deinit
    deinit {
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.loadView()
        setupView()
        viewModel.getData()
    }
}

// MARK: - HomeViewModelOutput
extension HomeController: HomeViewModelOutput {
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad list: [Section]) {
        DispatchQueue.main.async {
            viewModel.updateSections(list)
            self.applySnapshot(animatingDifferences: false)
        }
    }
    
}

extension HomeController {
    func generateDatasource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, cellViewModel) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {
                    return .init(frame: .zero)
                }
                cell.delegate = self
                cell.configure(with: cellViewModel)
                return cell
            })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections(viewModel.getSections())
        viewModel.getSections().forEach { section in
            snapshot.appendItems([section.task], toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func setupView() {
        view.backgroundColor = .red
        collectionView.backgroundColor = .blue
        
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints() { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc func refresh() {
        viewModel.refreshData()
        refreshControl.endRefreshing()
        viewModel.getData()
    }
}

// MARK: - UICollectionViewDelegate
extension HomeController: UICollectionViewDelegate {
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeController: UICollectionViewDelegateFlowLayout {
}

// MARK: - HomeCollectionViewCellViewDelegate
extension HomeController: HomeCollectionViewCellViewDelegate {
}

// MARK: - UISearchBarDelegate
extension HomeController: UISearchBarDelegate {
}
