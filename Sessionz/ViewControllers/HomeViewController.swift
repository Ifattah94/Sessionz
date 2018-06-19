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
import FirebaseAuth

class HomeViewController: UIViewController {
    var currentUserID = AuthUserService.manager.getCurrentUser()?.uid
    var currentUserLocation: UserLocation?
    

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
    
    
    var userLocations = [UserLocation]() {
        didSet {
            for location in userLocations {
                  let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                annotations.append(annotation)
            }
            DispatchQueue.main.async {
                self.homeView.mapView.addAnnotations(self.annotations)
                self.homeView.mapView.showAnnotations(self.annotations, animated: true)
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentUserLocation()
        setUserLocations()
        configureHomeView()
        setupNavigationBar()
        askUserForPermission()
        loadUsers()
        setupDelegates()
        setRegionFromUser(with: self.currentUserLocation)
        
       
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func setCurrentUserLocation() {
        if let currentUserID = currentUserID {
            UserProfileService.manager.getUserLocation(fromUserUID: currentUserID) { (userLocationOnline) in
                self.currentUserLocation = userLocationOnline
            }
        }
    }
    private func setUserLocations() {
        UserProfileService.manager.getAllUserLocations { (onlineLocations) in
            self.userLocations = onlineLocations
        }
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
        homeView.mapView.delegate = self
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self 
        
        
    }
    
    private func loadUsers() {
        UserProfileService.manager.getAllUsers { (allUsers) in
            self.usersOnMap = allUsers
            self.homeView.tableView.reloadData()
        }
    }
    
    func setRegionFromUser(with userLocation: UserLocation?) {
        if let userLocation = userLocation {
            
            let latitude = CLLocationDegrees(userLocation.latitude)
            let longitude = CLLocationDegrees(userLocation.longitude)
            let regionArea = 0.06
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: regionArea, longitudeDelta: regionArea))
            homeView.mapView.setRegion(region, animated: true)
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
extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
       
        var userAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "UserAnnotationView")
        if userAnnotationView == nil {
            userAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "UserAnnotationView")
            userAnnotationView?.canShowCallout = true
             let index = annotations.index{$0 === annotation}
            if let annotationIndex = index {
                userAnnotationView?.image = #imageLiteral(resourceName: "cmPunk").reDrawImage(using: CGSize(width: 50, height: 50))
                userAnnotationView?.contentMode = .scaleAspectFit
            }
        } else {
            userAnnotationView?.annotation = annotation
        }
        return userAnnotationView
    }
}
