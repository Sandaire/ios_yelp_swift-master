//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate  {
    
    
    var businesses: [Business]!
    var searchBar: UISearchBar!
    var isMoreDataLoading = false
    //var loadingMoreView:InfiniteScrollActivityView?
    var limit: Int = 20
    var offset: Int = 20
    
    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up search bar
        searchBar = UISearchBar()
        searchBar.returnKeyType = .search
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 100;
        tableView.estimatedRowHeight = 100;
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        searchBar.delegate = self
        
        // Set up Infinite Scroll loading indicator
        //let frame = CGRect(x: 0, y: tableView.contentSize.height, width: //tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        //loadingMoreView = InfiniteScrollActivityView(frame: frame)
        //loadingMoreView!.isHidden = true
        //tableView.addSubview(loadingMoreView!)
        
       // var insets = tableView.contentInset
        //insets.bottom += InfiniteScrollActivityView.defaultHeight
       // tableView.contentInset = insets
        
        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.tableView.reloadData();
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            
        }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm(term: "Restaurants", sort: .distance, categories: ["asianfusion", "burgers"]) { (businesses, error) in
         self.businesses = businesses
         for business in self.businesses {
         print(business.name!)
         print(business.address!)
         "Thai"
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil{
            return businesses.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BussinessCell",for: indexPath) as! BussinessCell
        cell.business = businesses[indexPath.row];
        return cell;
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        
        if let indexPath = tableView.indexPath(for: cell) {
            let detailViewController = segue.destination as! DetailViewController
            detailViewController.business = self.businesses[indexPath.row]
            
        }
    }
    
    
    // Searchbar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //PKHUD.sharedHUD.contentView = PKHUDProgressView()
        //PKHUD.sharedHUD.show()
        
        Business.searchWithTerm(term: searchBar.text!, completion: { (businesses: [Business]?, error: Error?) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            searchBar.setShowsCancelButton(false, animated: true)
            searchBar.endEditing(true)
            self.tableView.resignFirstResponder()
            //PKHUD.sharedHUD.hide()
        }
        )
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    
    
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count == 0 {
            
        }
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        tableView.resignFirstResponder()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
