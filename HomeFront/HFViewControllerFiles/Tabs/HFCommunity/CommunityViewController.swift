//
//  CommunityViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 10/5/25.
//

import UIKit
import MapKit
import CoreLocation


protocol ProfileRefreshable: AnyObject {
    func refreshFromProfile()
}

extension CommunityViewController: ProfileRefreshable {
    func refreshFromProfile() {
        configureGreeting()       // Refresh greeting based on rank/preferred name
        configureMap()            // Refresh map based on state
    }
}


class CommunityViewController: BaseViewController {
    
    // MARK: - UI Elements
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.layer.cornerRadius = 12
        map.clipsToBounds = true
        return map
    }()
    
    private lazy var greetingLabel = createLabel(
        text: "",
        fontSize: 26,
        bold: true
    )
    
    private lazy var subtitleLabel = createLabel(
        text: "Connecting you to your local veteran community",
        fontSize: 16,
        bold: false,
        color: .secondaryLabel
    )
    
    private lazy var stateLabel = createLabel(
        text: "",
        fontSize: 18,
        bold: false,
        color: .secondaryLabel
    )
    
    private lazy var locateButton = createPrimaryButton(title: "Show My VA Locations")
    
    private let geocoder = CLGeocoder()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Community"
        setupUI()
        setupActions()
        configureGreeting()
        configureMap()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        [greetingLabel, subtitleLabel, stateLabel, mapView, locateButton].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            stateLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            stateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mapView.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 20),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.45),
            
            locateButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 30),
            locateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locateButton.widthAnchor.constraint(equalToConstant: 220),
            locateButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupActions() {
        locateButton.addTarget(self, action: #selector(showVALocations), for: .touchUpInside)
    }
    
    // MARK: - Configuration
    
    private func configureGreeting() {
        let preferredName = UserDefaults.standard.string(forKey: "preferredName") ?? "Friend"
        let rank = UserDefaults.standard.string(forKey: "rank") ?? ""
        
        // Determine time of day
        let hour = Calendar.current.component(.hour, from: Date())
        let timeGreeting: String
        switch hour {
        case 5..<12:
            timeGreeting = "Good Morning"
        case 12..<17:
            timeGreeting = "Good Afternoon"
        default:
            timeGreeting = "Good Evening"
        }
        
        if !rank.isEmpty {
            greetingLabel.text = "\(timeGreeting), \(rank) \(preferredName)"
        } else {
            greetingLabel.text = "\(timeGreeting), \(preferredName)"
        }
    }
    
    // MARK: - Map
    
    private func configureMap() {
        let state = UserDefaults.standard.string(forKey: "stateOfResidence") ?? "Missouri"
        stateLabel.text = "Showing resources in \(state)"
        
        // Try to geocode the user's saved state
        geocoder.geocodeAddressString(state) { [weak self] placemarks, error in
            guard let self = self else { return }
            
            if let coordinate = placemarks?.first?.location?.coordinate {
                self.centerMap(on: coordinate, state: state)
            } else {
                // Fallback to Missouri
                let missouriCoords = CLLocationCoordinate2D(latitude: 38.5767, longitude: -92.1735)
                self.centerMap(on: missouriCoords, state: "Missouri")
            }
        }
    }
    
    private func centerMap(on coordinate: CLLocationCoordinate2D, state: String) {
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
        )
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func showVALocations() {
        showAlert(title: "Coming Soon", message: "VA locations will be displayed here for your state.")
    }
}
