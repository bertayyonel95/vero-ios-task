//
//  HomeViewModel.swift
//  vero-task-api
//
//  Created by Bertay Yönel on 30.12.2023.
//

import Foundation
import CoreData

// MARK: - HomeViewModelInput
protocol HomeViewModelInput {
    // MARK: Properties
    var output: HomeViewModelOutput? { get set }
    func getSections() -> [Section]
    func updateSections(_ sections: [Section])
    func getData()
    func searchFor(_ subString: String)
    func qrScanPressed()
}

// MARK: - HomeViewModelOutput
protocol HomeViewModelOutput: AnyObject {
    func home(_ viewModel: HomeViewModelInput, sectionDidLoad list: [Section])
}

// MARK: - HomeViewModel
final class HomeViewModel: HomeViewModelInput  {
    //MARK: Properties
    private var homeRouter: HomeRouting
    private var tokenAPI: TokenFetchable
    private var taskAPI: TaskFetchable
    private var sections: [Section] = []
    private var token: String = .empty
    private var tasks: [CoreDataPO] = []
    private var cells: [HomeCollectionViewCellViewModel] = []
    var container: NSPersistentContainer!
    weak var output: HomeViewModelOutput?
    
    init(homeRouter: HomeRouting, tokenAPI: TokenFetchable, taskAPI: TaskFetchable) {
        self.homeRouter = homeRouter
        self.tokenAPI = tokenAPI
        self.taskAPI = taskAPI
//        getToken()
//        addCoreData()
    }
    
    func getData() {
        DataHandler.shared.fetchAndUpdate() { data in
            self.generateCellData(dataSet: data)
        }
    }
    
    func getSections() -> [Section] {
        sections
    }
    
    func updateSections(_ sections: [Section]) {
        self.sections = sections
    }
    
    func qrScanPressed() {
        homeRouter.navigateToQRScanner()
    }
    
    func searchFor(_ subString: String) {
        let searchSections = sections
        
        let filteredSections = searchSections.filter { section in
            return section.task.title.range(of: subString, options: .caseInsensitive) != nil || section.task.task.range(of: subString, options: .caseInsensitive) != nil  || section.task.description.range(of: subString, options: .caseInsensitive) != nil || section.task.businessUnit.range(of: subString, options: .caseInsensitive) != nil || section.task.businessUnitKey?.range(of: subString, options: .caseInsensitive) != nil || section.task.wageType.range(of: subString, options: .caseInsensitive) != nil || section.task.parentTaskID.range(of: subString, options: .caseInsensitive) != nil || section.task.preplanningBoardQuickSelect?.range(of: subString, options: .caseInsensitive) != nil || section.task.sort.range(of: subString, options: .caseInsensitive) != nil || section.task.workingTime?.range(of: subString, options: .caseInsensitive) != nil
        }
        
        output?.home(self, sectionDidLoad: filteredSections)
    }
}

// MARK: - Helpers
private extension HomeViewModel {
    func generateCellData(dataSet: [CoreDataPO]) {
        cells = []
        sections = []
        dataSet.forEach { data in
            let cellViewModel = generateViewModel(with: data)
            cells.append(cellViewModel)
        }
        
        cells.forEach { item in
            let section = Section(task: item)
            if !sections.contains(section) { sections.append(section) }
        }
        output?.home(self, sectionDidLoad: sections)
    }
    
    func generateViewModel(with data: CoreDataPO) -> HomeCollectionViewCellViewModel {
        HomeCollectionViewCellViewModel(
            task: data.task,
            title: data.title,
            description: data.taskDescription,
            sort: data.sort,
            wageType: data.wageType,
            businessUnitKey: data.businessUnitKey,
            businessUnit: data.businessUnit,
            parentTaskID: data.parentTaskID,
            preplanningBoardQuickSelect: data.preplanningBoardQuickSelect,
            colorCode: data.colorCode,
            workingTime: data.workingTime,
            isAvailableInTimeTrackingKioskMode: data.isAvailableInTimeTrackingKioskMode
        )
    }
    
    
}
