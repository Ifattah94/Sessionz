//
//  HomeViewController.swift
//  Sessionz
//
//  Created by C4Q on 6/4/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class HomeViewController: UIViewController {

    let homeView = HomeView()
    private var annotations = [MKAnnotation]()
    var usersOnMap = [UserProfile]()
    private var locationService = LocationService.manager
    var newLocation: UserLocation? {
        didSet {
            if let location = newLocation {
            UserProfileService.manager.newUserLocation(location: location)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeView()
        setupNavigationBar()
        askUserForPermission()
        loadUsers()
        setupDelegates()
       
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    private func configureHomeView() {
        view.addSubview(homeView)
        homeView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }

   
    func askUserForPermission(){
        let _ = LocationService.manager.checkForLocationServices()
        
    }
    
    private func setupNavigationBar() {
        navigationItem.title = "Find Players"
        navigationController?.navigationBar.barTintColor = Stylesheet.Colors.customPurple
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupDelegates() {
        locationService.locationServiceDelegate = self
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self 
        
        
    }
    
    private func loadUsers() {
        UserProfileService.manager.getAllUsers { (allUsers) in
            self.usersOnMap = allUsers
            self.homeView.tableView.reloadData()
        }
    }
    
    

   
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    //MARK TableView methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = homeView.tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        let thisUser = usersOnMap[indexPath.row]
        cell.configureCell(withUser: thisUser)
        return cell 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersOnMap.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
    
}
extension HomeViewController: LocationServiceDelegate {
    func userLocationDidUpdate(_ userLocation: CLLocation) {
        LocationService.manager.setUserLocation(userLocation)
        newLocation = UserLocation(location: userLocation)
        
    }
    
    func userLocationsUpdatedFromFirebase(_ locations: [UserLocation]) {
        
    }
    
   
    
    
}
