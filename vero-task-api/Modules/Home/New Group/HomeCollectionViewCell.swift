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
        task.textColor = .black
        task.font = .boldSystemFont(ofSize: 16)
        return task
    }()
    
    private lazy var task: UILabel = {
        let task = UILabel()
        task.numberOfLines = 0
        task.lineBreakMode = .byWordWrapping
        task.textColor = .black
        task.font = .systemFont(ofSize: 16)
        return task
    }()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.text = "Title:"
        title.textColor = .black
        title.font = .boldSystemFont(ofSize: 16)
        return title
    }()
    
    private lazy var title: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.lineBreakMode = .byWordWrapping
        title.textColor = .black
        title.font = .systemFont(ofSize: 16)
        return title
    }()
    
    private lazy var descriptionTitle: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Description:"
        descriptionLabel.font = .boldSystemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        return descriptionLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.textColor = .black
        descriptionLabel.sizeToFit()
        return descriptionLabel
    }()
    
    private lazy var colorView: UIView = {
        let colorView = UIView()
        colorView.translatesAutoresizingMaskIntoConstraints = false
        colorView.backgroundColor = .white
        return colorView
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
        if viewModel.colorCode != .empty {
            let hexColor = hexStringToUIColor(hex: viewModel.colorCode)
            colorView.backgroundColor = hexColor
        } else {
            colorView.backgroundColor = .white
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension HomeCollectionViewCell {
    func setupView() {
        contentView.layer.cornerRadius = 8.0
        contentView.backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.addSubview(colorView)
        contentView.addSubview(taskLabel)
        contentView.addSubview(task)
        contentView.addSubview(titleLabel)
        contentView.addSubview(title)
        contentView.addSubview(descriptionTitle)
        contentView.addSubview(descriptionLabel)
        
        colorView.snp.makeConstraints() { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(12)
        }
        
        taskLabel.snp.makeConstraints() { make in
            make.top.leading.equalToSuperview().inset(12)
            make.trailing.equalTo(task.snp.leading)
            make.width.equalTo(40)
            make.bottom.equalTo(titleLabel.snp.top)
//            make.height.equalTo(24)
        }
        
        task.snp.makeConstraints() { make in
            make.leading.equalTo(taskLabel.snp.trailing)
            make.top.equalToSuperview().inset(12)
            make.trailing.equalTo(colorView.snp.leading)
            make.bottom.equalTo(title.snp.top)
        }
        
        titleLabel.snp.makeConstraints() { make in
            make.leading.equalToSuperview().inset(12)
            make.top.equalTo(task.snp.bottom)
            make.trailing.equalTo(title.snp.leading)
            make.width.equalTo(40)
            make.bottom.equalTo(descriptionTitle.snp.top)
//            make.height.equalTo(24)
        }
        
        title.snp.makeConstraints() { make in
            make.leading.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(task.snp.bottom)
            make.trailing.equalTo(colorView.snp.leading)
            make.bottom.equalTo(descriptionTitle.snp.top)
        }
        
        descriptionTitle.snp.makeConstraints() { make in
            make.leading.equalToSuperview().inset(12)
            make.top.equalTo(title.snp.bottom)
            make.trailing.equalTo(colorView.snp.leading)
            make.bottom.equalTo(descriptionLabel.snp.top)
            make.height.equalTo(24)
//            make.height.equalTo(24)
        }
        
        descriptionLabel.snp.makeConstraints() { make in
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalTo(colorView.snp.leading)
            make.top.equalTo(descriptionTitle.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}
