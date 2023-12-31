//
//  Section.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 31.12.2023.
//

import Foundation

final class Section: Hashable {
    // MARK: Properties
    let task: HomeCollectionViewCellViewModel
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.task == rhs.task
    }
    // MARK: init
    public init(task: HomeCollectionViewCellViewModel) {
        self.task = task
    }
    // MARK: Helpers
    func hash(into hasher: inout Hasher) {
        hasher.combine(task)
    }
}
