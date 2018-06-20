//
//  HomeView.swift
//  Sessionz
//
//  Created by C4Q on 6/7/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth

class HomeView: UIView {
    let currentUserUID = AuthUserService.manager.getCurrentUser()!.uid
    lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.showsUserLocation = true
        return map
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        //TODO register custom cell
        tv.register(PlayerCell.self, forCellReuseIdentifier: "PlayerCell")
        return tv
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        let views = [mapView, tableView] as [UIView]
        views.forEach { addSubview($0);
            ($0).translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
    
    private func setupConstraints() {
        //mapview
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
            make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(16)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-16)
            make.height.equalTo(safeAreaLayoutGuide.snp.height).multipliedBy(0.45)
            
            
            //tableview
            tableView.snp.makeConstraints({ (make) in
                make.top.equalTo(mapView.snp.bottom).offset(16)
                make.leading.equalTo(safeAreaLayoutGuide.snp.leading).offset(8)
                make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).offset(-8)
                make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-16)
            })
            
        }
        
        
        
    }
    
    

}
