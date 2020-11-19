//
//  UIViewControllerPersonDetail.swift
//  EmirayNakip__ING
//
//  Created by Emiray Nakip on 20.11.2020.
//

import UIKit
import WebKit

class UIViewControllerPersonDetail: UIViewController, WKUIDelegate {

    var tableview : UITableView?
    
    var personModel : PersonModel? = nil
    var personId : Int? = nil
    
    let personOverview : String = "PersonOverview"
    var tableviewArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableviewArray.append(personOverview)
        
        guard let modelID = personId else { return }
        
        self.fetchData(modelID: modelID)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationItem.title = "Person Detail"
    }
    
    // MARK:- API METHODS
    func fetchData(modelID:Int) {
        
        self.startActivityIndicator(mainView: self.view!)
        
        APIMethods.init().fetchData(httpMethod: "GET",
                                    page: String(1),
                                    url: "/person/"+String(modelID),
                                    endPoint: "") { (succes, data, error) in
            if succes {
                
                let personMdl = try? newJSONDecoder().decode(PersonModel.self, from: data)
                print("==>",personMdl?.id)
                
                self.personModel = personMdl
              
                DispatchQueue.main.async {
                
                    self.stopActivityIndicator()
                    
                    self.setupTableView()
                    
                }
                
                
            } else {
                self.stopActivityIndicator()
            }
        }
        
    }
    
    // MARK: - SETUP UI
    func setupTableView() {
        
        self.tableview = UITableView()
        self.tableview?.backgroundColor = .white
        self.tableview?.separatorStyle = .none
        self.tableview?.allowsSelection = false
        self.tableview?.rowHeight = UITableView.automaticDimension
        self.tableview?.estimatedRowHeight = 200.0
        self.tableview?.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tableview ?? UITableView())
        
        self.tableview?.delegate = self
        self.tableview?.dataSource = self
        
        self.tableview?.register(UINib.init(nibName: "TableViewCellLabel", bundle: nil),
                                 forCellReuseIdentifier: "TableViewCellLabel")
        
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
    
    func viewHeader(model:PersonModel) -> UIView {
        let vwHeader : UIView = UIView.init(frame: CGRect.init(x: 0.0,
                                                               y: 0.0,
                                                               width: self.view.frame.size.width,
                                                               height: 180.0))
        vwHeader.backgroundColor = .white
        
        // IMAGE VIEW
        let imageViewMovie : UIImageView = UIImageView.init()
        APIMethods.init().downloadImage(from: model.profile_path ?? "", imageview: imageViewMovie)
        imageViewMovie.translatesAutoresizingMaskIntoConstraints = false
        vwHeader.addSubview(imageViewMovie)
        
        imageViewMovie.widthAnchor.constraint(equalToConstant: 120.0).isActive = true
        imageViewMovie.heightAnchor.constraint(equalToConstant: 170.0).isActive = true
        imageViewMovie.leadingAnchor.constraint(equalTo: vwHeader.leadingAnchor, constant: 5.0).isActive = true
        imageViewMovie.topAnchor.constraint(equalTo: vwHeader.topAnchor, constant: 5.0).isActive = true
        
        // LABEL TITLE
        let labelTitle : UILabel = UILabel()
        labelTitle.text = model.name
        labelTitle.font = UIFont.boldSystemFont(ofSize: 17.0)
        labelTitle.numberOfLines = 0
        labelTitle.textColor = .black
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        vwHeader.addSubview(labelTitle)
        
        labelTitle.topAnchor.constraint(equalTo: imageViewMovie.topAnchor, constant: 0.0).isActive = true
        labelTitle.leadingAnchor.constraint(equalTo: imageViewMovie.trailingAnchor, constant: 5.0).isActive = true
        labelTitle.trailingAnchor.constraint(equalTo: vwHeader.trailingAnchor, constant: -5.0).isActive = true
        
        // LABEL PLACE OF BIRTH
        let labelGenres : UILabel = UILabel()
        labelGenres.text = model.place_of_birth ?? ""
        labelGenres.font = UIFont.boldSystemFont(ofSize: 17.0)
        labelGenres.numberOfLines = 0
        labelGenres.textColor = .black
        labelGenres.translatesAutoresizingMaskIntoConstraints = false
        vwHeader.addSubview(labelGenres)
        
        labelGenres.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 6.0).isActive = true
        labelGenres.leadingAnchor.constraint(equalTo: imageViewMovie.trailingAnchor, constant: 5.0).isActive = true
        labelGenres.trailingAnchor.constraint(equalTo: vwHeader.trailingAnchor, constant: -5.0).isActive = true
        
        // LABEL BIRTH DATE
        let labelTime : UILabel = UILabel()
        labelTime.text = model.birthday?.convertMyDateFormat()
        labelTime.numberOfLines = 0
        labelTime.textColor = .black
        labelTime.textAlignment = .left
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        vwHeader.addSubview(labelTime)
        
        labelTime.topAnchor.constraint(equalTo: labelGenres.bottomAnchor, constant: 6.0).isActive = true
        labelTime.leadingAnchor.constraint(equalTo: imageViewMovie.trailingAnchor, constant: 5.0).isActive = true
        labelTime.trailingAnchor.constraint(equalTo: vwHeader.trailingAnchor, constant: -5.0).isActive = true
        
        
        // BUTTON HOMEPAGE
        let buttonHomePage : UIButton = UIButton()
        buttonHomePage.setTitle("HOMEPAGE", for: .normal)
        buttonHomePage.backgroundColor = Colors().banabiColor
        buttonHomePage.setTitleColor(.white, for: .normal)
        buttonHomePage.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        buttonHomePage.layer.cornerRadius = 6.0
        buttonHomePage.isHidden = model.homepage != nil ? false : true
        buttonHomePage.addTarget(self, action: #selector(homepageAction), for: .touchUpInside)
        buttonHomePage.translatesAutoresizingMaskIntoConstraints = false
        vwHeader.addSubview(buttonHomePage)
        
        buttonHomePage.topAnchor.constraint(equalTo: labelGenres.bottomAnchor, constant: 5.0).isActive = true
        buttonHomePage.leadingAnchor.constraint(equalTo: imageViewMovie.trailingAnchor, constant: 5.0).isActive = true
        buttonHomePage.trailingAnchor.constraint(equalTo: vwHeader.trailingAnchor, constant: -5.0).isActive = true
        buttonHomePage.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        
        
        return vwHeader
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
    
    //ACTIONS
    @objc func homepageAction() {
        
        guard let homepage = self.personModel?.homepage else { return }
        
        guard let homepageURL = URL(string: homepage) else {
            return
        }
        
        self.setupWebView(urll: homepageURL)
        
    }
    
}

extension UIViewControllerPersonDetail: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.viewHeader(model: self.personModel!)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableviewCell : String = self.tableviewArray[indexPath.row]
        
        if tableviewCell == self.personOverview {
            let cell : TableViewCellLabel = tableview?.dequeueReusableCell(withIdentifier: "TableViewCellLabel", for: indexPath) as! TableViewCellLabel
            
            cell.label.text = self.personModel?.biography ?? ""
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
