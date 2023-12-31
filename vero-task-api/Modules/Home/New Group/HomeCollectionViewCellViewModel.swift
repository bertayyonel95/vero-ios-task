//
//  HomeCollectionViewCellViewModel.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 31.12.2023.
//

import Foundation

// MARK: - HomeCollectionViewCellViewModel
struct HomeCollectionViewCellViewModel: Hashable, Codable {
    // MARK: Properties
    let task: String
    let title: String
    let description: String
    let sort: String
    let wageType: String
    let businessUnitKey: String?
    let businessUnit: String
    let parentTaskID: String
    let preplanningBoardQuickSelect: String?
    let colorCode: String
    let workingTime: String?
    let isAvailableInTimeTrackingKioskMode: Bool
}
