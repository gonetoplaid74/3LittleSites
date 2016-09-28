//
//  ViewController.swift
//  WebNews
//
//  Created by Allan Wallace on 28/07/2016.
//  Copyright © 2016 Allan Wallace. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    var webView: WKWebView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    

    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var bbcBtn: UIBarButtonItem!
    @IBOutlet weak var dmBtn: UIBarButtonItem!
    @IBOutlet weak var f1Btn: UIBarButtonItem!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
   
    @IBOutlet weak var bookmarkBack: UIButton!
    @IBOutlet weak var Bookmarks: UIBarButtonItem!
    
    
    @IBOutlet weak var bookmarkView: UIView!
    @IBOutlet weak var BookmarkLbl: UILabel!
    
    @IBOutlet weak var web1: UITextField!
    @IBOutlet weak var lbl1: UITextField!
    @IBOutlet weak var web2: UITextField!
    @IBOutlet weak var lbl2: UITextField!
    @IBOutlet weak var web3: UITextField!
    @IBOutlet weak var lbl3: UITextField!
    var url1: String!
    var url2: String!
    var url3: String!
    let tempURL1 = "http://apple.co.uk"
    let tempURL2 = "http://www.google.co.uk"
    let tempURL3 = "http://www.wikipedia.org"
    let tempbarLbl1 = "APL"
    let tempbarLbl2 = "GGL"
    let tempbarLbl3 = "WIK"
    var barLbl1: String!
    var barLbl2: String!
    var barLbl3: String!
    var firstLoad: Bool!

    typealias DownloadComplete = () -> ()

    override func viewDidLoad() {
        super.viewDidLoad()
                bbcBtn.isEnabled = true
                dmBtn.isEnabled = true
                f1Btn.isEnabled = true
        spinner.isHidden = true
       
      
        webView = WKWebView()
        container.insertSubview(webView, belowSubview: spinner)
        loadUserData()
        prefillBookmarks()
        
        if firstLoad == true {
            bookmarkView.isHidden = false
        }
        
        spinner.layer.cornerRadius = 10
        
        bookmarkView.layer.cornerRadius = 20
        bookmarkView.layer.shadowRadius = 20
        bookmarkView.layer.shadowColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0).cgColor
        bookmarkView.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        bookmarkView.layer.shadowOpacity = 0.85
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        let frame =  CGRect(x: 0, y: 0, width: container.frame.width, height: container.frame.height)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.frame = frame
        
        let firstView = UserDefaults.standard
        url1 = firstView.string(forKey: "website1")
        loadRequest(urlString: url1)
        
     webView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        backButton.isEnabled = false
        forwardButton.isEnabled = false
        
        

        
        
    }
    
    func loadUserData () {
        let website1 = UserDefaults.standard
        let webBtn1 = UserDefaults.standard
        let website2 = UserDefaults.standard
        let webBtn2 = UserDefaults.standard
        let website3 = UserDefaults.standard
        let webBtn3 = UserDefaults.standard
        
        if website1.string(forKey: "website1") == nil {
            firstLoad = true
            website1.set(tempURL1, forKey: "website1")
            webBtn1.set(tempbarLbl1, forKey: "barBtn1")
            bbcBtn.title = webBtn1.string(forKey: "barBtn1") as String!
        }
        
        
        if website2.string(forKey: "website2") == nil{
            website2.set(tempURL2, forKey: "website2")
            webBtn2.set(tempbarLbl2, forKey: "barBtn2")
            dmBtn.title = webBtn2.string(forKey: "barBtn2") as String!
        }
        
        if website3.string(forKey: "website3") == nil{
            website3.set(tempURL3, forKey: "website3")
            webBtn3.set(tempbarLbl3, forKey: "barBtn3")
            f1Btn.title = webBtn3.string(forKey: "barBtn3") as String!

            
        } else {
        bbcBtn.title = webBtn1.string(forKey: "barBtn1") as String!
        dmBtn.title = webBtn2.string(forKey: "barBtn2") as String!
        f1Btn.title = webBtn3.string(forKey: "barBtn3") as String!
        firstLoad = false
        bookmarkView.isHidden = true
        
        }

        
    }
    
    func keyboardWillShow(notification: NSNotification) {
    
    
    if self.view.frame.origin.y == 0{
    self.view.frame.origin.y -= 120
    }
    
    }
    
    
    func keyboardWillHide(notification: NSNotification) {
                    if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += 120
            }
        }
    
   // override func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions.Type, context: UnsafeMutablePointer?) {
    override func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?) {
        
    }
    //func observeValue(forKeyPath keyPath: String?, of object: AnyObject?, change: [NSKeyValueChangeKey : AnyObject]?, context: UnsafeMutableRawPointer?) {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        
     
        if (keyPath == "loading"){
            backButton.isEnabled = webView.canGoBack
            forwardButton.isEnabled = webView.canGoForward
            
        }

        
        
    }
    
     override func didReceiveMemoryWarning() {
        didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

        

    
    func loadRequest(urlString: String){
   
              spinner.isHidden = false
        
        spinner.startAnimating()
        
    let url = NSURL(string: urlString)!
    let request = URLRequest(url: url as URL)

        webView.load(request)
     
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
             //your function here
           self.spinner.stopAnimating()
            self.spinner.isHidden = true
            

        }
            }
    
  
    
    
   
    

    
    
    @IBAction func back(sender: UIBarButtonItem){
        spinner.isHidden = false
        spinner.startAnimating()

        webView.goBack()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
    //your function here
    self.spinner.stopAnimating()
    self.spinner.isHidden = true
    
    }

    }
    @IBAction func forward(sender: UIBarButtonItem){
        webView.goForward()
    }
    @IBAction func reload(sender: UIBarButtonItem){
        spinner.isHidden = false
        spinner.startAnimating()
        

        
        let request = NSURLRequest(url: webView.url!)
        webView.load(request as URLRequest)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            //your function here
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
        }
        
    }
    @IBAction func loadBBCF1(_ sender: UIBarButtonItem) {
        
        let website3 = UserDefaults.standard
        url3 = website3.string(forKey: "website3")!
    loadRequest(urlString: url3)
        
        
    }
    
    @IBAction func loadDailyMail(_ sender: UIBarButtonItem) {
        
        let website2 = UserDefaults.standard
        url2 = website2.string(forKey: "website2")!
        loadRequest(urlString: url2)
        
        
        

    }

    @IBAction func loadBBCNews(_ sender: UIBarButtonItem) {
    
        let website1 = UserDefaults.standard
        url1 = website1.string(forKey: "website1")!
        loadRequest(urlString: url1)
    }

//        func fadeIn(){
//            
//            for _ in 0...15 {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
//                    //your function here
//                    self.bookmarkView.alpha += 0.05
//                    
//            }
//        }
//    }

    
    func prefillBookmarks() {
        let website1 = UserDefaults.standard
        let webBtn1 = UserDefaults.standard
        let website2 = UserDefaults.standard
        let webBtn2 = UserDefaults.standard
        let website3 = UserDefaults.standard
        let webBtn3 = UserDefaults.standard
        
        web1.text = website1.string(forKey: "website1")
        lbl1.text = webBtn1.string(forKey: "barBtn1")
        web2.text = website2.string(forKey: "website2")
        lbl2.text = webBtn2.string(forKey: "barBtn2")
        web3.text = website3.string(forKey: "website3")
        lbl3.text = webBtn3.string(forKey: "barBtn3")
        
        self.web1.keyboardType = UIKeyboardType.URL
        self.web2.keyboardType = UIKeyboardType.URL
        self.web3.keyboardType = UIKeyboardType.URL
        

        
        
    }
    
    func saveBookmarks() {
        let website1 = UserDefaults.standard
        let webBtn1 = UserDefaults.standard
        let website2 = UserDefaults.standard
        let webBtn2 = UserDefaults.standard
        let website3 = UserDefaults.standard
        let webBtn3 = UserDefaults.standard
        
        website1.set(web1.text, forKey: "website1")
        webBtn1.set(lbl1.text, forKey: "barBtn1")
        
        website2.set(web2.text, forKey: "website2")
        webBtn2.set(lbl2.text, forKey: "barBtn2")
        
        website3.set(web3.text, forKey: "website3")
        webBtn3.set(lbl3.text, forKey: "barBtn3")
        
        bbcBtn.title = webBtn1.string(forKey: "barBtn1")
        dmBtn.title = webBtn2.string(forKey: "barBtn2")
        f1Btn.title = webBtn3.string(forKey: "barBtn3")

    }

    @IBAction func loadBookmarks(_ sender: UIBarButtonItem) {
        
        bookmarkView.isHidden = false
        
        prefillBookmarks()
        
        
        
        
        
    }

    @IBAction func bookmarkBackBtn(_ sender: AnyObject) {
        bookmarkView.isHidden = true
    }
    @IBAction func save(_ sender: AnyObject) {
        bookmarkView.isHidden = true
        saveBookmarks()
        
               }
}



