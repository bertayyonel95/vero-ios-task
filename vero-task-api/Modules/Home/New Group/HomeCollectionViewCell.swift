//
//  HomeCollectionViewCell.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 31.12.2023.
//

import UIKit
import SnapKit

// MARK: - HomeCollectionViewCellViewDelegate
protocol HomeCollectionViewCellViewDelegate: AnyObject {
}
// MARK: - HomeCollectionViewCell
final class HomeCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    private var viewModel: HomeCollectionViewCellViewModel?
    
    static let identifier = "HomeCollectionViewCell"
    weak var delegate: HomeCollectionViewCellViewDelegate?
    
    private lazy var taskLabel: UILabel = {
        let task = UILabel()
        task.text = "Task:"
        return task
    }()
    
    private lazy var task: UILabel = {
        let task = UILabel()
        return task
    }()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Title:"
        return title
    }()
    
    private lazy var title: UILabel = {
        let title = UILabel()
        return title
    }()
    
    private lazy var descriptionTitle: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Description:"
        return descriptionLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        return descriptionLabel
    }()
    
    // MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helpers
    override func prepareForReuse() {
        task.text = nil
        title.text = nil
        descriptionLabel.text = nil
    }
    
    func configure(with viewModel: HomeCollectionViewCellViewModel) {
        self.viewModel = viewModel
        task.text = viewModel.task
        title.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}

extension HomeCollectionViewCell {
    func setupView() {
        
        addSubview(taskLabel)
        addSubview(task)
        addSubview(titleLabel)
        addSubview(title)
        addSubview(descriptionTitle)
        addSubview(descriptionLabel)
        taskLabel.snp.makeConstraints() { make in
            make.top.leading.equalToSuperview()
        }
        
        task.snp.makeConstraints() { make in
            make.leading.equalTo(taskLabel.snp.trailing)
            make.top.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints() { make in
            make.leading.equalToSuperview()
            make.top.equalTo(taskLabel.snp.bottom)
        }
        
        title.snp.makeConstraints() { make in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(task.snp.bottom)
        }
        
        descriptionTitle.snp.makeConstraints() { make in
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
        }
        
        descriptionLabel.snp.makeConstraints() { make in
            make.leading.equalTo(descriptionTitle.snp.trailing)
            make.top.equalTo(title.snp.bottom)
        }
    }
}
