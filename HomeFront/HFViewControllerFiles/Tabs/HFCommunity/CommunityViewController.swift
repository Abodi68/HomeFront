//
//  CommunityViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 10/5/25.
//

import UIKit
import MapKit
import CoreLocation
import os.log


protocol ProfileRefreshable: AnyObject {
    func refreshFromProfile()
}

extension CommunityViewController: ProfileRefreshable {
    func refreshFromProfile() {
        DispatchQueue.main.async { [weak self] in
            self?.configureMap()
        }
    }
}


class CommunityViewController: BaseViewController, MKMapViewDelegate {
    
    private let log = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.homefront.app", category: "Community")
    
    // Persisted user preference for state from JSON via UserProfileStore
    private var stateOfResidence: String? {
        guard let accountID = LocalAccountManager.shared.currentAccount?.username else {
            log.warning("[State] No current account; cannot load profile")
            return nil
        }
        let store = UserProfileStore.shared
        if let profile = store.loadProfile(for: accountID) {
            let value = profile.stateOfResidence?.trimmingCharacters(in: .whitespacesAndNewlines)
            if let value, !value.isEmpty {
                log.debug("[State] Loaded from UserProfileStore for account \(accountID, privacy: .public): \(value, privacy: .public)")
                return value
            } else {
                log.warning("[State] Profile present but stateOfResidence is missing/empty for account \(accountID, privacy: .public)")
                return nil
            }
        } else {
            log.warning("[State] No profile found in store for account \(accountID, privacy: .public)")
            return nil
        }
    }
    
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
        color: .hf_primary
    )
    
    private lazy var stateLabel = createLabel(
        text: "",
        fontSize: 18,
        bold: false,
        color: .hf_primary
    )
    
    private lazy var locateButton = createPrimaryButton(title: "Show My VA Locations")
    
    private let geocoder = CLGeocoder()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Community"
        
        log.info("CommunityViewController loaded")
        
        greetingLabel.adjustsFontForContentSizeCategory = true
        subtitleLabel.adjustsFontForContentSizeCategory = true
        stateLabel.adjustsFontForContentSizeCategory = true
        
        locateButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        locateButton.titleLabel?.adjustsFontForContentSizeCategory = true
        
        setupUI()
        setupActions()
        mapView.delegate = self
        configureMap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileDidUpdate), name: .profileDidUpdate, object: nil)
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
    
    // MARK: - VA Locations (Demo)
    private struct VALocation {
        let name: String
        let coordinate: CLLocationCoordinate2D
        let phone: String
        let address: String
    }

    private func missouriVALocations() -> [VALocation] {
        return [
            VALocation(
                name: "VA St. Louis Health Care System — John Cochran Division",
                coordinate: CLLocationCoordinate2D(latitude: 38.6356, longitude: -90.2286),
                phone: "(314) 652-4100",
                address: "915 N Grand Blvd, St. Louis, MO 63106"
            ),
            VALocation(
                name: "VA St. Louis Health Care System — Jefferson Barracks Division",
                coordinate: CLLocationCoordinate2D(latitude: 38.5017, longitude: -90.2836),
                phone: "(314) 652-4100",
                address: "1 Jefferson Barracks Dr, St. Louis, MO 63125"
            ),
            VALocation(
                name: "Kansas City VA Medical Center",
                coordinate: CLLocationCoordinate2D(latitude: 39.0569, longitude: -94.5786),
                phone: "(816) 861-4700",
                address: "4801 Linwood Blvd, Kansas City, MO 64128"
            )
        ]
    }

    private func addVALocationsToMap(_ locations: [VALocation]) {
        let annotations: [MKPointAnnotation] = locations.map { loc in
            let ann = MKPointAnnotation()
            ann.title = loc.name
            ann.subtitle = "\(loc.address) • \(loc.phone)"
            ann.coordinate = loc.coordinate
            return ann
        }
        mapView.addAnnotations(annotations)
    }
    
    private func fitMapToAnnotations(edgePadding: UIEdgeInsets = UIEdgeInsets(top: 60, left: 40, bottom: 60, right: 40), animated: Bool = true) {
        let annotations = mapView.annotations.filter { !($0 is MKUserLocation) }
        guard !annotations.isEmpty else { return }
        var zoomRect = MKMapRect.null
        for annotation in annotations {
            let point = MKMapPoint(annotation.coordinate)
            let rect = MKMapRect(x: point.x, y: point.y, width: 0.01, height: 0.01)
            zoomRect = zoomRect.union(rect)
        }
        mapView.setVisibleMapRect(zoomRect, edgePadding: edgePadding, animated: animated)
    }
    
    // MARK: - Map
    
    private func configureMap() {
        log.info("configureMap() called")

        // Clear existing annotations/overlays for a clean slate
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        guard let state = stateOfResidence else {
            // If no state, center on continental US with a wide span and update labels
            stateLabel.text = "Select your state in Profile"
            let usCenter = CLLocationCoordinate2D(latitude: 39.8283, longitude: -98.5795)
            let region = MKCoordinateRegion(center: usCenter, span: MKCoordinateSpan(latitudeDelta: 30, longitudeDelta: 30))
            mapView.setRegion(region, animated: true)
            log.warning("[Map] No state available; centered on US overview")
            return
        }

        // Update label to reflect the chosen state
        stateLabel.text = state

        // Cancel any in-flight geocoding to avoid overlapping callbacks
        geocoder.cancelGeocode()
        let query = "\(state), USA"
        log.info("[Geocode] Starting geocode for: \(query, privacy: .public)")

        geocoder.geocodeAddressString(query) { [weak self] placemarks, error in
            guard let self = self else { return }

            if let error = error as? CLError {
                self.log.error("[Geocode] CLError for state \(state, privacy: .public): \(error.localizedDescription, privacy: .public)")
            } else if let error {
                self.log.error("[Geocode] Error for state \(state, privacy: .public): \(error.localizedDescription, privacy: .public)")
            }

            guard let coordinate = placemarks?.first?.location?.coordinate else {
                // Fallback to Missouri if geocoding fails
                let fallbackState = "Missouri"
                let fallbackCoords = CLLocationCoordinate2D(latitude: 38.5767, longitude: -92.1735)
                DispatchQueue.main.async {
                    self.stateLabel.text = fallbackState
                    self.centerMap(on: fallbackCoords, state: fallbackState)
                    // Removed addVALocationsToMap call here as per instructions
                }
                self.log.warning("[Geocode] No coordinate for \(state, privacy: .public). Falling back to Missouri")
                return
            }

            self.log.info("[Geocode] Success for \(state, privacy: .public): lat=\(coordinate.latitude, privacy: .public), lon=\(coordinate.longitude, privacy: .public)")
            DispatchQueue.main.async {
                self.stateLabel.text = state
                self.centerMap(on: coordinate, state: state)
                // Removed addVALocationsToMap call here as per instructions
            }
        }
    }
    
    private func centerMap(on coordinate: CLLocationCoordinate2D, state: String) {
        log.debug("[Map] Centering on \(state, privacy: .public) at lat=\(coordinate.latitude, privacy: .public), lon=\(coordinate.longitude, privacy: .public)")
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
        )
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func showVALocations() {
        log.info("[Action] Show VA Locations tapped")
        guard let state = stateOfResidence else {
            showAlert(title: "Profile Needed", message: "Please set your state in Profile to show VA locations.")
            return
        }
        // For demo: only Missouri is supported
        if state == "Missouri" {
            // Clear existing VA annotations (optional: keep other annotations)
            let nonUserAnnotations = mapView.annotations.filter { !($0 is MKUserLocation) }
            mapView.removeAnnotations(nonUserAnnotations)
            // Add Missouri VA locations and fit
            addVALocationsToMap(missouriVALocations())
            fitMapToAnnotations()
        } else {
            showAlert(title: "Coming Soon", message: "VA locations for \(state) will be available in a future update.")
        }
    }
    
    @objc private func handleProfileDidUpdate() {
        log.info("[Profile] profileDidUpdate received; refreshing map")
        configureMap()
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        let identifier = "VALocationPin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        if view == nil {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
            view?.markerTintColor = .systemBlue
            view?.glyphImage = UIImage(systemName: "cross.case.fill")
            let infoButton = UIButton(type: .detailDisclosure)
            view?.rightCalloutAccessoryView = infoButton
        } else {
            view?.annotation = annotation
        }
        return view
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else { return }
        let title = annotation.title ?? "VA Location"
        let details = annotation.subtitle ?? nil

        var phone: String?
        var address: String?
        if let detailsStr = details ?? nil {
            let parts = detailsStr.components(separatedBy: " • ")
            if parts.count == 2 {
                address = parts[0]
                phone = parts[1]
            }
        }

        let alert = UIAlertController(title: title, message: address ?? (details ?? ""), preferredStyle: .actionSheet)

        if let phone = phone {
            alert.addAction(UIAlertAction(title: "Call \(phone)", style: .default, handler: { _ in
                let digits = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                if let url = URL(string: "tel://\(digits)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }))
        }

        if let address = address {
            alert.addAction(UIAlertAction(title: "Copy Address", style: .default, handler: { _ in
                UIPasteboard.general.string = address
            }))
            alert.addAction(UIAlertAction(title: "Open in Maps", style: .default, handler: { _ in
                let placemark = MKPlacemark(coordinate: annotation.coordinate)
                let mapItem = MKMapItem(placemark: placemark)
                mapItem.name = title
                mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            }))
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let pop = alert.popoverPresentationController {
            pop.sourceView = view
            pop.sourceRect = view.bounds
        }

        present(alert, animated: true)
    }
}

