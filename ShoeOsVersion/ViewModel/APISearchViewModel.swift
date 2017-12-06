//
//  APISearchViewModel.swift
//  ShoeOsVersion
//
//  Created by Magnolia on 04.12.2017.
//  Copyright © 2017 Mangust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import CoreData

class APISearchViewModel {
    
    // MARK:- Helper для работы с моделью(API)
    private lazy var dataManager = {
        return DataManager(baseURL: API.AuthenticatedBaseURL)
    }()
    
    var photosManagedObject: [PhotoEntity] = []
    private let entityName: String = "PhotoEntity"
    private let modelPropertyName: String = "photoName"
    private let modelPropertyImg: String = "photoUrl"
    
    // Добавлено для избавления от dataSource и delegate таблицы
    // MARK: Outputs
    //public var VersionsDataSource : Observable<[Version]>
    
    var photoWeScrollTo: Int = 0
    
    // MARK: - Properties
    private let _querying = Variable<Bool>(false)
    private let _versions = Variable<[Photo]>([])
    
    var querying: Driver<Bool> { return _querying.asDriver() }
    var versions: Driver<[Photo]> { return _versions.asDriver() }
    
    // MARK: -
    var hasVersions: Bool { return numberOfVersions > 0 }
    var numberOfVersions: Int { return _versions.value.count}
    
    // MARK: -22
    var queryingDidChange: ((Bool) -> ())?
    
    // MARK: -
    private let disposeBag = DisposeBag()
    
    // MARK: - Initialization
//    init(query: Driver<String>) {
//
//        query
//            .throttle(0.5)
//            .distinctUntilChanged()
//            .drive(onNext: { [weak self] (word) in
//
//                self?.getDataUsingAPI(word: word)
//
//            })
//            .disposed(by: disposeBag)
//    }

    init(word: String) {
        
        self.getDataUsingAPI(word: word)
        
    }
    
    // MARK: - Public Interface
    
    func Version(at index: Int) -> Photo? {
        
        guard index < _versions.value.count else { return nil }
        return _versions.value[index]
        
    }
    
    func viewModelForVersion(at index: Int) -> VersionsViewModel? {
        
        guard let version = Version(at: index) else { return nil }
        return VersionsViewModel(title: version.title, imageUrl: version.imgUrl)
        
    }
    
    // MARK: - Helper Methods
    // Обращение к модели
    func getDataUsingAPI(word: String?) {
        
//        guard let word = word,
//            word.count > 2 else {
//                _versions.value = []
//                return
//        }
        
        print("wordValue:", word ?? "NET", ":")
        
        if word != " " {
            
            //  READ FROM DB (II)
            readFromDB(searchByWord: word!)
            
            print("_versions.value: ", _versions.value)
            return
            
        } else { // Пробел => перезагрузка вьюхи
            _querying.value = true
            
            // Запуск сбора данных
            dataManager.operationForWord(word: word!) { (response, error) in
                if let error = error {
                    print(error)
                } else if let response = response {
                    
                    print("resp: ", response.photosModel)
                    
                    self._querying.value = false
                    self._versions.value = response.photosModel
                    
                    // WRITE TO DB (I)
                    self.saveToDB(responseObject: response.photosModel)
                    
                }
                
            }
        }
        
    }
    
    //MARK:- DB Helper
    func saveToDB(responseObject: [Photo]) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: entityName,
                                       in: managedContext)!
        
        let model = NSManagedObject(entity: entity,
                                    insertInto: managedContext)
        
        
        
//        nameKey: String,
//        nameValue: String,
//        imgKey: String,
//        imgValue: String
        
        for respObj in responseObject {
            
            // 3
            model.setValue(respObj.title, forKeyPath: modelPropertyName)
            model.setValue(respObj.imgUrl, forKeyPath: modelPropertyImg)
            
            // 4
            do {
                
                try managedContext.save()
                photosManagedObject.append(model as! PhotoEntity)
                
            } catch let error as NSError {
                
                print("Could not save. \(error), \(error.userInfo)")
                
            }
        
        }
    
        
    }
    
    // Mapping
    
    func readFromDB(searchByWord: String) {
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        print("searchByWord: ", searchByWord)
        
        if searchByWord != "" {
            fetchRequest.predicate = NSPredicate(format: "photoName CONTAINS[c] %@", searchByWord)
        }
        

        //3
        do {
            
            photosManagedObject = try managedContext.fetch(fetchRequest) as! [PhotoEntity]
            
            for photoModel in photosManagedObject {
                
                let photoObject = Photo(title: photoModel.photoName!,
                                        imgurl: photoModel.photoUrl!)
                
                self._versions.value.append(photoObject)
                
                //print(photoModel.photoName ?? "")
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    // Mark:- Filter array Helper
    func getFilteredByWordArray(findWord:String, inArray:[Photo]) -> [Photo] {
        return inArray
            .filter { $0
                .title
                .range(
                    of: findWord,
                    options: .caseInsensitive) != nil
        }
    }
   
}
