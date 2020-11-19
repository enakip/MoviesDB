//
//  UIViewControllerDetail.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 17.11.2020.
//

import UIKit
import WebKit

class UIViewControllerDetail: UIViewController, WKUIDelegate {
 
    var tableview : UITableView?
    
    let moveiOverview : String = "MovieOverview"
    
    var tableviewArray : [String] = []
    
    var selectedMovie : Result?
    
    var movieDetailModel : MovieDetailModel?
    
    var videoModel : VideoModel?
    
    var arrayCasts : [Cast] = []
    
    var selectedIndexPath : IndexPath = IndexPath.init()
    
    // MARK:- LIFE CYLCE
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableviewArray = [moveiOverview]
        
        self.rightBarButtonItem()
        
        self.fetchData(model: selectedMovie!)
        
        self.fetchVideo(model: selectedMovie!)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = "Movie Detail"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        let vc : ViewController = self.navigationController?.viewControllers.first as! ViewController
        
        vc.collectionview?.reloadItems(at: [selectedIndexPath])
    }
    
    // MARK:- API METHODS
    func fetchData(model:Result) {
        
        guard let movieID = model.id else { return }
        
        self.startActivityIndicator(mainView: self.view!)
        
        APIMethods.init().fetchData(httpMethod: "GET",
                                    page: String(1),
                                    url: "/movie/"+String(movieID),
                                    endPoint: "") { (succes, data, error) in
            if succes {
                
                let moviedetailModel = try? newJSONDecoder().decode(MovieDetailModel.self, from: data)
                print("==>",moviedetailModel?.id)
                
                self.movieDetailModel = moviedetailModel
              
                DispatchQueue.main.async {
                
                    self.stopActivityIndicator()
                    
                    self.setupTableView()
                    
                    self.fetchCreditsData(movieID: movieID)
                }
                
                
            } else {
                self.stopActivityIndicator()
            }
        }
        
    }
    
    func fetchCreditsData(movieID:Int) {
        
        self.startActivityIndicator(mainView: self.view!)
        
        APIMethods.init().fetchData(httpMethod: "GET",
                                    page: String(1),
                                    url: "/movie/"+String(movieID)+"/credits",
                                    endPoint: "") { (succes, data, error) in
            if succes {
                
                let creditsModel = try? newJSONDecoder().decode(CreditsModel.self, from: data)
                
                self.arrayCasts = creditsModel?.cast ?? [Cast]()
               
                DispatchQueue.main.async {
                
                    self.stopActivityIndicator()
                
                    self.tableview?.beginUpdates()
                    self.tableview?.reloadSections(IndexSet.init(integer: 1), with: .automatic)
                    self.tableview?.endUpdates()
                }
                
                
            } else {
                self.stopActivityIndicator()
            }
        }
        
    }
    
    func fetchVideo(model:Result) {
        
        guard let movieID = model.id else { return }
        
        self.startActivityIndicator(mainView: self.view!)
        
        APIMethods.init().fetchData(httpMethod: "GET",
                                    page: String(1),
                                    url: "/movie/"+String(movieID)+"/videos",
                                    endPoint: "") { (succes, data, error) in
            if succes {
                
                let videoModel = try? newJSONDecoder().decode(VideoModel.self, from: data)
                print("==>",videoModel?.id)
                
                self.videoModel = videoModel
                
            } else {
                self.stopActivityIndicator()
            }
        }
    }
    
    // MARK:- SETUP UI
    func rightBarButtonItem() {
        let rightbarbutton : UIBarButtonItem = UIBarButtonItem.barButton(self,
                                                                         action: #selector(favAction),
                                                                         imageName: "fav_none")
        self.navigationItem.rightBarButtonItem = rightbarbutton
    }
    
    func setupTableView() {
        
        self.tableview = UITableView()
        self.tableview?.backgroundColor = .white
        self.tableview?.separatorStyle = .none
        self.tableview?.rowHeight = UITableView.automaticDimension
        self.tableview?.estimatedRowHeight = 200.0
        self.tableview?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableview ?? UITableView())
        
        self.tableview?.delegate = self
        self.tableview?.dataSource = self
        
        self.tableview?.register(UINib.init(nibName: "TableViewCellLabel", bundle: nil),
                                 forCellReuseIdentifier: "TableViewCellLabel")
        self.tableview?.register(UINib.init(nibName: "TableViewCellLabelWithImage", bundle: nil),
                                 forCellReuseIdentifier: "TableViewCellLabelWithImage")
        
        var yAxis : NSLayoutYAxisAnchor?
        if #available(iOS 11.0, *) {
            let guide = self.view.safeAreaLayoutGuide
            yAxis = guide.bottomAnchor
        } else {
            yAxis = bottomLayoutGuide.bottomAnchor
        }
        self.tableview?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0).isActive = true
        self.tableview?.bottomAnchor.constraint(equalTo: yAxis!, constant: 0.0).isActive = true
        self.tableview?.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0).isActive = true
        self.tableview?.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0).isActive = true
        
        self.tableview?.reloadData()
    }
    
    func setupWebView(urll:URL) {
        
        // WEBVIEW...
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        let userScript = WKUserScript(source: jscript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(userScript)
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        
        let webview : WKWebView = WKWebView.init(frame: self.view.bounds, configuration: wkWebConfig)
        webview.tag = 1002
        webview.uiDelegate = self
        let myRequest = URLRequest(url: urll)
        webview.load(myRequest)
        webview.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(webview)
        
        webview.leadingAnchor.constraint(equalTo: self.tableview!.leadingAnchor, constant: 0.0).isActive = true
        webview.trailingAnchor.constraint(equalTo: self.tableview!.trailingAnchor, constant: 0.0).isActive = true
        webview.topAnchor.constraint(equalTo: self.tableview!.topAnchor, constant: 0.0).isActive = true
        webview.bottomAnchor.constraint(equalTo: self.tableview!.bottomAnchor, constant: 0.0).isActive = true
        
        // CLOSE BTN
        let btnClose : UIButton = UIButton()
        btnClose.setTitle("X", for: .normal)
        btnClose.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        btnClose.setTitleColor(.white, for: .normal)
        btnClose.backgroundColor = Colors().banabiColor
        btnClose.layer.cornerRadius = 15.0
        btnClose.addTarget(self, action: #selector(removeWebView), for: .touchUpInside)
        btnClose.translatesAutoresizingMaskIntoConstraints = false
        webview.addSubview(btnClose)
        
        btnClose.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        btnClose.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        btnClose.leadingAnchor.constraint(equalTo: webview.leadingAnchor, constant: 10.0).isActive = true
        btnClose.topAnchor.constraint(equalTo: (self.navigationController?.navigationBar.bottomAnchor)!, constant: 5.0).isActive = true
        
    }
    
    @objc func removeWebView() {
        
        guard let webvw = self.view.viewWithTag(1002) else { return }
        
        webvw.removeFromSuperview()
    }
    
    func viewHeader(model:MovieDetailModel) -> UIView {
        let vwHeader : UIView = UIView.init(frame: CGRect.init(x: 0.0,
                                                               y: 0.0,
                                                               width: self.view.frame.size.width,
                                                               height: 180.0))
        vwHeader.backgroundColor = .white
        
        // IMAGE VIEW
        let imageViewMovie : UIImageView = UIImageView.init()
        APIMethods.init().downloadImage(from: model.poster_path ?? "", imageview: imageViewMovie)
        imageViewMovie.translatesAutoresizingMaskIntoConstraints = false
        vwHeader.addSubview(imageViewMovie)
        
        imageViewMovie.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
        imageViewMovie.heightAnchor.constraint(equalToConstant: 170.0).isActive = true
        imageViewMovie.leadingAnchor.constraint(equalTo: vwHeader.leadingAnchor, constant: 5.0).isActive = true
        imageViewMovie.topAnchor.constraint(equalTo: vwHeader.topAnchor, constant: 5.0).isActive = true
        
        // LABEL TITLE
        let labelTitle : UILabel = UILabel()
        labelTitle.text = model.title
        labelTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
        labelTitle.numberOfLines = 0
        labelTitle.textColor = .black
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        vwHeader.addSubview(labelTitle)
        
        labelTitle.topAnchor.constraint(equalTo: imageViewMovie.topAnchor, constant: 0.0).isActive = true
        labelTitle.leadingAnchor.constraint(equalTo: imageViewMovie.trailingAnchor, constant: 5.0).isActive = true
        labelTitle.trailingAnchor.constraint(equalTo: vwHeader.trailingAnchor, constant: -5.0).isActive = true
        
        // LABEL GENRES
        let labelGenres : UILabel = UILabel()
        labelGenres.text = (model.genres?.first?.name ?? "")
        labelGenres.font = UIFont.boldSystemFont(ofSize: 17.0)
        labelGenres.numberOfLines = 0
        labelGenres.textColor = .black
        labelGenres.translatesAutoresizingMaskIntoConstraints = false
        vwHeader.addSubview(labelGenres)
        
        labelGenres.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 5.0).isActive = true
        labelGenres.leadingAnchor.constraint(equalTo: imageViewMovie.trailingAnchor, constant: 5.0).isActive = true
        labelGenres.widthAnchor.constraint(equalToConstant: 90.0).isActive = true
        
        // LABEL TIME
        let labelTime : UILabel = UILabel()
        labelTime.text = String(model.runtime ?? 0)+" m"
        labelTime.numberOfLines = 0
        labelTime.textColor = .black
        labelTime.textAlignment = .left
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        vwHeader.addSubview(labelTime)
        
        labelTime.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 6.0).isActive = true
        labelTime.leadingAnchor.constraint(equalTo: labelGenres.trailingAnchor, constant: 0.0).isActive = true
        labelTime.trailingAnchor.constraint(equalTo: vwHeader.trailingAnchor, constant: -5.0).isActive = true
        
        // BUTTON TRAILER
        let buttonTrailer : UIButton = UIButton()
        buttonTrailer.setTitle("Trailer", for: .normal)
        buttonTrailer.backgroundColor = Colors().banabiColor
        buttonTrailer.setTitleColor(.white, for: .normal)
        buttonTrailer.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        buttonTrailer.layer.cornerRadius = 6.0
        buttonTrailer.isHidden = model.video ?? false
        buttonTrailer.addTarget(self, action: #selector(videoAction), for: .touchUpInside)
        buttonTrailer.translatesAutoresizingMaskIntoConstraints = false
        vwHeader.addSubview(buttonTrailer)
        
        buttonTrailer.topAnchor.constraint(equalTo: labelGenres.bottomAnchor, constant: 5.0).isActive = true
        buttonTrailer.leadingAnchor.constraint(equalTo: imageViewMovie.trailingAnchor, constant: 5.0).isActive = true
        buttonTrailer.trailingAnchor.constraint(equalTo: vwHeader.trailingAnchor, constant: -5.0).isActive = true
        buttonTrailer.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        
        return vwHeader
    }
    
    func viewHeaderBasicSection() -> UIView {
        let vw : UIView = UIView.init(frame: CGRect.init(x: 0.0,
                                                         y: 0.0,
                                                         width: self.view.frame.size.width,
                                                         height: 40.0))
        vw.backgroundColor = Colors().banabiColor
        
        let labelTitle : UILabel = UILabel()
        labelTitle.text = "CAST"
        labelTitle.textColor = .white
        labelTitle.font = UIFont.boldSystemFont(ofSize: 20.0)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        vw.addSubview(labelTitle)
        
        labelTitle.leadingAnchor.constraint(equalTo: vw.leadingAnchor, constant: 5.0).isActive = true
        labelTitle.trailingAnchor.constraint(equalTo: vw.trailingAnchor, constant: -5.0).isActive = true
        labelTitle.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        labelTitle.topAnchor.constraint(equalTo: vw.topAnchor, constant: 5.0).isActive = true
        
        return vw
    }
    
    //MARK:- ACTIONS...
    @objc func favAction() {
        
        let movieId : Int = selectedMovie?.id ?? 0
        
        let userDefaults = UserDefaults.standard

        var arrayFav : [Int] = userDefaults.array(forKey: "ArrayFav") as? [Int] ?? [Int]()
        
        let index = self.find(value: movieId, in: arrayFav)
        
        if index == nil {
            arrayFav.append(movieId)
            
            self.showAlert(msgg: "Added to Favorites.", imagename: "Success")
            
            
        } else {
            arrayFav.remove(at: index!)
            
            self.showAlert(msgg: "Removed from Favorites.", imagename: "Success")
            
        }
        
        userDefaults.set(arrayFav, forKey: "ArrayFav")
        
    }
    
    @objc func videoAction() {
        
        guard let videoMdl = videoModel else { return }
        
        guard let videoResult = videoMdl.results else { return }
        
        guard let videoKey = videoResult.first?.key else { return }
        
        guard let videoURL = URL(string: "https://www.themoviedb.org/video/play?key="+videoKey) else {
            return
        }
        
        self.setupWebView(urll: videoURL)
        
    }
    
}
//MARK:-
// MARK:- TABLE VIEW METHODS...
extension UIViewControllerDetail: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? self.viewHeader(model: self.movieDetailModel!) : self.viewHeaderBasicSection()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 200.0 : 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.tableviewArray.count : self.arrayCasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let tableviewCell : String = self.tableviewArray[indexPath.row]
            
            if tableviewCell == "MovieOverview" {
                
            }
            
            let cell : TableViewCellLabel = tableview?.dequeueReusableCell(withIdentifier: "TableViewCellLabel", for: indexPath) as! TableViewCellLabel
            
            cell.label.text = self.movieDetailModel?.overview ?? ""
            
            return cell
        }
        
        if indexPath.section == 1 {
            
            let castMdl : Cast = self.arrayCasts[indexPath.row]
            
            let cellCast : TableViewCellLabelWithImage = tableview?.dequeueReusableCell(withIdentifier: "TableViewCellLabelWithImage", for: indexPath) as! TableViewCellLabelWithImage
            
            cellCast.labelMovie.text = castMdl.character ?? ""
            
            cellCast.labelOriginal.text = castMdl.original_name ?? ""
            
            APIMethods.init().downloadImage(from: castMdl.profile_path ?? "", imageview: cellCast.imageviewProfie)
            
            return cellCast
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? tableView.rowHeight : 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            let model : Cast = self.arrayCasts[indexPath.row]
            
            let personDetailVC : UIViewControllerPersonDetail = UIViewControllerPersonDetail.init(nibName: "UIViewControllerPersonDetail", bundle: nil) 
            
            self.navigationItem.title = ""
            
            personDetailVC.personId = model.id
            
            self.navigationController?.pushViewController(personDetailVC, animated: true)
            
        }
    }
}

