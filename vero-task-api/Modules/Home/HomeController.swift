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
        searchBar.backgroundColor = .systemGray
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.textColor = .black
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.delegate = self
        return searchBar
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
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
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
    }
}

// MARK: - HomeViewModelOutput
extension HomeController: HomeViewModelOutput {
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad list: [Section]) {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
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
    
    @objc func qrScanPressed() {
        viewModel.qrScanPressed()
    }
    
    func setupView() {
        view.backgroundColor = .systemGray
        collectionView.backgroundColor = .systemGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "qrcode.viewfinder"), style: .plain, target: self, action: #selector(qrScanPressed))
        
        view.addSubview(collectionView)
        view.addSubview(searchBar)

        searchBar.snp.makeConstraints() { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(collectionView.snp.top)
        }
        
        collectionView.snp.makeConstraints() { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
    }
    
    @objc func refresh() {
        viewModel.getData()
        DispatchQueue.main.async {
            self.searchBar.text = .empty
        }
        refreshControl.endRefreshing()
    }
    
    @objc
    func searchPressed() {
        viewModel.searchFor(searchBar.text ?? .empty)
        collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    func calculateHeight(inString: String) -> CGFloat{
        let messageString = inString
        let attributes : [NSAttributedString.Key : Any] = [NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue) : UIFont.systemFont(ofSize: 16)]
        let attributedString : NSAttributedString = NSAttributedString(string: messageString, attributes: attributes)
        let rect : CGRect = attributedString.boundingRect(with: CGSize(width: 222.0, height: CGFloat.greatestFiniteMagnitude),
                                                          options: .usesLineFragmentOrigin, context: nil)
        
        let requredSize:CGRect = rect
        return requredSize.height
    }
}

// MARK: - UICollectionViewDelegate
extension HomeController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section < viewModel.getSections().count {
            let section = viewModel.getSections()[indexPath.section]
            let labelHeight1 = calculateHeight(inString: section.task.description)
            let labelHeight2 = calculateHeight(inString: section.task.task)
            let labelHeight3 = calculateHeight(inString: section.task.title)
            let labelHeight4 = calculateHeight(inString: "Description: ")
            let totalHeight = labelHeight1 + labelHeight2 + labelHeight3 + labelHeight4
            return CGSize(width: collectionView.frame.width, height: totalHeight + 20)
        } else {
            return CGSize()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: .zero, bottom: 10, right: .zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
}

// MARK: - HomeCollectionViewCellViewDelegate
extension HomeController: HomeCollectionViewCellViewDelegate {
}

// MARK: - UISearchBarDelegate
extension HomeController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            DispatchQueue.main.async {
                self.viewModel.getData()
                self.collectionView.reloadData()
            }
        } else {
            DispatchQueue.main.async {
                self.viewModel.getData()
                self.searchPressed()
            }
        }
    }
}

extension HomeController: QRScannerDelegate {
    func scannedText(text: String) {
        DispatchQueue.main.async {
            self.searchBar.text = text
            self.viewModel.searchFor(text)
        }
    }
}
