//
//  ViewController.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 19.10.2020.
//

import UIKit

class ViewController: UIViewController {

    let moviePopularEndPoint : String = "/movie/popular?language=en-US"
    let movieSearchEndPoint : String = "/search/movie?language=en-US"
    
    var collectionview : UICollectionView?
    
    var barbuttonRight : UIBarButtonItem?
    
    var isListView : Bool = true
    
    var page : Int = 0
    
    var moviesResults : [Result] = []
    
    var isSearching : Bool = false
    var moviesResultsSearch : [Result] = []
    
    @IBOutlet weak var collectionviewASD : UICollectionView?
    
    // MARK: - LIFCE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = "Movies"
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        if page < 1 {
            self.loadData()
        }
    }
    
    // MARK: - UI SETUPS...
    func setupUI() {
        self.setupCollectionView(islistview: true)
        
        self.setupNavigationBar()
    }
    
    func setupNavigationBar() {
        
        self.navigationController?.navigationBar.topItem?.title = "Movies"
        
        self.navigationController?.navigationBar.barTintColor = Colors().banabiColor
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        self.rightBarbuttonItem(imagename: "grid")
        self.leftBarbuttonItem(imagename: "Search")
    }
    
    func setupCollectionView(islistview:Bool) {
        
        isListView = islistview
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        if islistview {
            layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
            layout.itemSize = CGSize(width: self.view.frame.size.width,
                                     height: 120)
            layout.scrollDirection = .vertical
            
            self.rightBarbuttonItem(imagename: "grid")
            
        } else {
            layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5)
            layout.itemSize = CGSize(width: (self.view.frame.size.width-25)/2,
                                     height: 160)
            layout.scrollDirection = .vertical
           
            self.rightBarbuttonItem(imagename: "list")
        }
        
        self.collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        self.collectionview?.backgroundColor = .white
        
        self.collectionview?.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.collectionview ?? UICollectionView())
        
        var yAxis : NSLayoutYAxisAnchor?
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            yAxis = guide.bottomAnchor
        } else {
            yAxis = bottomLayoutGuide.bottomAnchor
        }
        self.collectionview?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        self.collectionview?.bottomAnchor.constraint(equalTo: yAxis!, constant: 0.0).isActive = true
        self.collectionview?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        self.collectionview?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        
        // COLLECTION VIEW SET DELEGATE & DATA SORUCE...
        self.collectionview?.delegate = self
        
        self.collectionview?.dataSource = self
        
        // COLLECTION VIEW REGISTER CELLS.....
        self.collectionview?.register(UINib.init(nibName: "CollectionViewCellList", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCellList")
        
        self.collectionview?.register(UINib.init(nibName: "CollectionViewCellGrid", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCellGrid")
        
    }
    
    func rightBarbuttonItem(imagename: String) {
        
        let barbuttonitem = UIBarButtonItem.barButton(self,
                                                  action: #selector(rightBarbuttonAction),
                                                  imageName: imagename)
        
        self.navigationItem.rightBarButtonItem = barbuttonitem
    }
    
    func leftBarbuttonItem(imagename: String) {
        
        let barbuttonitem : UIBarButtonItem?
        
        if imagename == "Search" {
            barbuttonitem = UIBarButtonItem.barButton(self,
                                                      action: #selector(searchBarbuttonAction),
                                                      imageName: imagename)
        } else {
            barbuttonitem = UIBarButtonItem.barButton(self,
                                                      action: #selector(cancelBarbuttonAction),
                                                      imageName: imagename)
        }
        
        self.navigationItem.leftBarButtonItem = barbuttonitem
    }
    
    func buttonBottom() {
        let button : UIButton = UIButton()
        button.addTarget(self, action: #selector(loadData), for: .touchUpInside)
        button.tag = 99
        button.setTitle("LOAD MORE", for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.5)
        button.backgroundColor = .darkGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.zPosition = 1
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        self.collectionview?.addSubview(button)
        
        button.leadingAnchor.constraint(equalTo: self.view!.leadingAnchor, constant: 10.0).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view!.trailingAnchor, constant: -10.0).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view!.bottomAnchor, constant: -23.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        
    }
    
    func removeButtonBottom() {
        guard let button = self.view.viewWithTag(99) as? UIButton else { return }
        
        button.removeFromSuperview()
    }
    
    var textfieldSearch : UITextField!
    func searchViewAdd() {
        
        self.collectionview?.allowsSelection = false
        self.collectionview?.isScrollEnabled = false
        
        let viewCover : UIView = UIView()
        viewCover.tag = 90
        viewCover.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        viewCover.frame = self.view.bounds
        viewCover.layer.zPosition = 1
        self.collectionview?.addSubview(viewCover)
        
        let viewSearch : UIView = UIView()
        viewSearch.backgroundColor = Colors().banabiColor
        viewSearch.tag = 98
        viewSearch.layer.zPosition = 1
        viewSearch.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewSearch)
        
        viewSearch.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        viewSearch.topAnchor.constraint(equalTo: (self.navigationController?.navigationBar.bottomAnchor)!, constant: 0.0).isActive = true
        viewSearch.leadingAnchor.constraint(equalTo: self.view!.leadingAnchor, constant: 0.0).isActive = true
        viewSearch.trailingAnchor.constraint(equalTo: self.view!.trailingAnchor, constant: 0.0).isActive = true
        
        textfieldSearch = UITextField()
        textfieldSearch.placeholder = "Search Movies"
        textfieldSearch.attributedPlaceholder = NSAttributedString(string: "Search Movies",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        textfieldSearch.textColor = .white
        textfieldSearch.tintColor = .white
        textfieldSearch.layer.borderWidth = 1.5
        textfieldSearch.layer.borderColor = UIColor.white.cgColor
        textfieldSearch.layer.cornerRadius = 6.0
        textfieldSearch.keyboardType = .default
        textfieldSearch.delegate = self
        textfieldSearch.setLeftPaddingPoints(8.0)
        textfieldSearch.translatesAutoresizingMaskIntoConstraints = false
        viewSearch.addSubview(textfieldSearch)
        
        textfieldSearch.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        textfieldSearch.widthAnchor.constraint(equalToConstant: 300.0).isActive = true
        textfieldSearch.centerXAnchor.constraint(equalTo: viewSearch.centerXAnchor, constant: 0).isActive = true
        textfieldSearch.centerYAnchor.constraint(equalTo: viewSearch.centerYAnchor, constant: 0).isActive = true
    }
    
    func searchViewRemove() {
        guard let vw = self.view.viewWithTag(98) else { return }
        vw.removeFromSuperview()
        
        self.removeCoverView()
        
        
    }
    
    func removeCoverView() {
        guard let vwCover = self.view.viewWithTag(90) else { return }
        vwCover.removeFromSuperview()
        
        self.collectionview?.allowsSelection = true
        self.collectionview?.isScrollEnabled = true
    }
    
    
    func addLabelNoData(collectinvw : UICollectionView) {
        
        let labelNoData : UILabel = UILabel()
        labelNoData.tag = 1001
        labelNoData.layer.zPosition = 1
        labelNoData.numberOfLines = 0
        labelNoData.textAlignment = .center
        labelNoData.textColor = Colors().banabiColor
        labelNoData.font = UIFont.boldSystemFont(ofSize: 20.0)
        labelNoData.text = "The movie you are looking for was not found."
        labelNoData.translatesAutoresizingMaskIntoConstraints = false
        collectinvw.addSubview(labelNoData)
        
        labelNoData.topAnchor.constraint(equalTo: collectinvw.topAnchor, constant: 80.0).isActive = true
        labelNoData.leadingAnchor.constraint(equalTo: collectinvw.leadingAnchor, constant: 10.0).isActive = true
        labelNoData.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10.0).isActive = true
        labelNoData.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
    }
    
    func removeLabelNoData(collectinvw : UICollectionView) {
        
        guard let labelnoData = collectinvw.viewWithTag(1001) else { return }
        
        labelnoData.removeFromSuperview()
    }
    
    // MARK: - ACTIONS
    @objc func rightBarbuttonAction() {
        
        self.setupCollectionView(islistview: !isListView)
        
    }
    
    @objc func searchBarbuttonAction() {
        self.searchViewAdd()
        
        self.leftBarbuttonItem(imagename: "Cancel")
    }
    
    @objc func cancelBarbuttonAction() {
        self.isSearching = false
        
        self.searchViewRemove()
        
        self.leftBarbuttonItem(imagename: "Search")
        
        page = 0
        
        self.loadData()
    }
    
    @objc func loadData() {
        self.startActivityIndicator(mainView: self.collectionview!)
        
        self.removeButtonBottom()
        
        page = page + 1
        
        APIMethods.init().fetchData(httpMethod: "POST",
                                    page: String(page),
                                    url:"/movie/popular",
                                    endPoint: "&language=en-US") { (success, data, error) in
            if success {
                
                let moviesModel = try? newJSONDecoder().decode(MoviesModel.self, from: data)
                print("PAGE => \(moviesModel?.page ?? 1)")
                
                for result in (moviesModel?.results)! {
                    self.moviesResults.append(result)
                }
                
               // self.moviesResults = moviesModel?.results ?? []
               // print("COUNTS => \(self.moviesResults.count)")
                
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    
                    self.collectionview?.reloadData()
                }
                
            } else {
                self.removeFromParent()
            }
        }
    }
    
    func searchData(searchText:String) {
        
        if searchText == "" || searchText.count == 0 {
            return
        }
        
        self.removeCoverView()
        
        self.startActivityIndicator(mainView: self.collectionview!)
        
        APIMethods.init().fetchData(httpMethod: "GET",
                                    page: String(1),
                                    url:"/search/movie",
                                    endPoint: "&language=en-US&include_adult=false&query="+searchText) { (succes, data, error) in
            DispatchQueue.main.async {
                self.textfieldSearch.resignFirstResponder()
            }
            
            if succes {
                
                self.moviesResultsSearch.removeAll()
                
                let moviesModel = try? newJSONDecoder().decode(MoviesModel.self, from: data)
                print("PAGE => \(moviesModel?.page ?? 1)")
                
                self.moviesResultsSearch = moviesModel?.results ?? []
                print("COUNTS => \(self.moviesResultsSearch.count)")
                
                DispatchQueue.main.async {
                    self.stopActivityIndicator()
                    
                    self.collectionview?.reloadData()
                }
            } else {
                
            }
        }
    }
    
}

// MARK: - COLLECTION VIEW METHODS....
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        var count: Int = 0
        
        count = self.isSearching ? self.moviesResultsSearch.count : self.moviesResults.count
        
        self.removeLabelNoData(collectinvw: collectionView)
        
        if count == 0 && self.isSearching {
            self.addLabelNoData(collectinvw: collectionView)
        }
        
        return count
        
        
       // return
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let movieArray : [Result] = self.isSearching ? self.moviesResultsSearch : self.moviesResults
        
        let model : Result = movieArray[indexPath.row]
        
        var isFav : Bool = false
        
        let userDefaults = UserDefaults.standard

        let arrayFav : [Int] = userDefaults.array(forKey: "ArrayFav") as? [Int] ?? [Int]()
        
        let index = self.find(value: model.id ?? 0, in: arrayFav)
        
        if index != nil {
            isFav = true
        }
        
        if isListView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellList",
                                                          for: indexPath) as! CollectionViewCellList
            cell.populateCell(model: model, isFav: isFav)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellGrid",
                                                          for: indexPath) as! CollectionViewCellGrid
            
            cell.populateCell(model: model, isFav: isFav)
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == self.moviesResults.count - 1 && isSearching == false {
           
            self.loadData()
        } else {
           
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
        let movieArray : [Result] = self.isSearching ? self.moviesResultsSearch : self.moviesResults
        
        let selectedMovie : Result = movieArray[indexPath.row]
        
        let detailVC : UIViewControllerDetail = UIViewControllerDetail.init(nibName: "UIViewControllerDetail", bundle: nil)
        
        self.navigationItem.title = ""
        
        detailVC.selectedMovie = selectedMovie
        
        detailVC.selectedIndexPath = indexPath
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
}

// MARK: - TEXT FIELD DELEGATE METHODS...
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isSearching = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text else { return true }
        
        self.searchData(searchText: text)
        
        return true
        
    }
    
}
