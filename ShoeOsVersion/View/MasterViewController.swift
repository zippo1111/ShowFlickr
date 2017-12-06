//
//  MasterViewController.swift
//  ShoeOsVersion
//
//  Created by Magnolia on 04.12.2017.
//  Copyright © 2017 Mangust. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MasterViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    
    var titlesAndPhotos:[Photo] = [] // Данные для рядов таблицы

    // MARK:- Rx time
    private let disposeBag = DisposeBag()
    
    // MARK:- Подключение ViewModel
    var viewModel: APISearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tableView.dataSource = nil
//        self.tableView.delegate = nil
        runViewModelOperations()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        addRfereshControl()
        
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- Refresh contolling
    func addRfereshControl() {
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(MasterViewController.doRefreshContent(_:)), for: UIControlEvents.valueChanged)
        
        refreshControl?.attributedTitle = NSAttributedString(string: "Обновление данных...")
        
//        self.tableView.addSubview(refreshControl!)
        
        
    }
    
    //MARK:- Обновление данных
    @IBAction func doRefreshContent(_ sender: Any) {
        
        
        viewModel = APISearchViewModel(word: " ")
        
        viewModel
            .versions
            .drive(onNext: { [unowned self] (_ versions) in
                
                self.tableView .reloadData()
                self.refreshControl?.endRefreshing()
                
            })
            .disposed(by: disposeBag)
        
        
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                controller.viewModel = viewModel // Присоединение ViewModel'и
                
                // Будем скроллить к нужной картинке
                viewModel.photoWeScrollTo = indexPath.row
                
                // Делаем title для вспомогательного окна
//                controller.title = viewModel.viewModelForVersion(at: indexPath.row)!.title
                
            }
        }
    }
    
    private func isViewModelEmpty() -> Bool {
        
        guard let _ = viewModel else {
            return true
        }
        
        return false
        
    }

    //MARK:- Обновление данных + взаимодействие с ViewModel
    private func runViewModelOperations() {
        //getData()
        
        viewModel = APISearchViewModel(word: "")
        
        guard let _ = viewModel else {
            return
        }
        
        searchBar.rx.text
            .subscribe { [unowned self] (query) in
                print("query: ", query.debugDescription)
                
                self.viewModel = APISearchViewModel(word: self.searchBar.text!)
                self.tableView .reloadData()
                
            }
            .disposed(by: disposeBag)
        
        //
        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] in
                self.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        //
        searchBar.rx.cancelButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] in
                self.searchBar.resignFirstResponder()
                self.searchBar.endEditing(true)
                
                print("resigning")
                
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
            
                print("ix: ", indexPath.row)
                self?.tableView.deselectRow(at: indexPath, animated: false)
                
            }).disposed(by: disposeBag)
    }
    
        
        
    func getData() {
        // Никаких данных в поисковой строке
//        viewModel = APISearchViewModel(query: searchBar.rx.text.orEmpty.asDriver())
        
//        viewModel = APISearchViewModel()
        
    }
    
    /*
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let object = objects[indexPath.row] as! NSDate
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    */

}

extension MasterViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isViewModelEmpty() {
            return 1
        }
        
        print("numberOfVersions: ", viewModel.numberOfVersions)
        
        return viewModel.numberOfVersions
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VersionTableViewCell.reuseIdentifier, for: indexPath) as? VersionTableViewCell else { fatalError("Unexpected Table View Cell") }
        
        if isViewModelEmpty() {
            return cell
        }
        
        if let vm = viewModel.viewModelForVersion(at: indexPath.row) {
            
            // Configure Table View Cell
            cell.configure(withViewModel: vm)
            
        }
        
        return cell
        
    }
    
    
}
