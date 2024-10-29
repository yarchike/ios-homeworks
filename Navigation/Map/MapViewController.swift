//
//  MapViewController.swift
//  Navigation
//
//  Created by Ярослав  Мартынов on 28.10.2024.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var mapTypeSegmentedControl: UISegmentedControl = {
        let mapTypeSegmentedControl = UISegmentedControl(items: ["Standard".localized, "Satellite".localized, "Hybrid".localized])
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapTypeSegmentedControl.selectedSegmentIndex = 0
        mapTypeSegmentedControl.addTarget(self, action: #selector(mapTypeChanged), for: .valueChanged)
        mapTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return mapTypeSegmentedControl
    }()
    
    private lazy var trackingButton: MKUserTrackingButton = {
        let trackingButton = MKUserTrackingButton(mapView: mapView)
        trackingButton.translatesAutoresizingMaskIntoConstraints = false
                trackingButton.layer.backgroundColor = UIColor.white.cgColor
                trackingButton.layer.borderColor = UIColor.gray.cgColor
                trackingButton.layer.borderWidth = 1.0
                trackingButton.layer.cornerRadius = 5.0
                trackingButton.clipsToBounds = true
        return trackingButton
    }()
    
    private lazy var clearButton: UIButton = {
        let clearButton = UIButton(type: .system)
        clearButton.setTitle("Очистить", for: .normal)
        clearButton.backgroundColor = .white
        clearButton.layer.cornerRadius = 5
        clearButton.layer.borderColor = UIColor.gray.cgColor
        clearButton.layer.borderWidth = 1.0
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.addTarget(self, action: #selector(clearMap), for: .touchUpInside)

  
        return clearButton
    }()

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        addSubviews()
        setupConstraints()
        
        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.startUpdatingLocation()
        
        let lpg = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        mapView.addGestureRecognizer(lpg)
    
    }
    
    private func setupView() {
        view.backgroundColor = .white
        title = "Карта"
    }
    
    private func addSubviews() {
        view.addSubview(mapView)
        view.addSubview(mapTypeSegmentedControl)
        view.addSubview(trackingButton)
        view.addSubview(clearButton)

    }
    
    
    private func setupConstraints() {
        let safeAreaGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mapTypeSegmentedControl.bottomAnchor.constraint(equalTo: safeAreaGuide.bottomAnchor, constant: -10),
            mapTypeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            mapTypeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            trackingButton.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 20),
            trackingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            trackingButton.widthAnchor.constraint(equalToConstant: 44),
            trackingButton.heightAnchor.constraint(equalToConstant: 44),
            
            clearButton.topAnchor.constraint(equalTo: safeAreaGuide.topAnchor, constant: 20),
            clearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            clearButton.widthAnchor.constraint(equalToConstant: 100),
            clearButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc func mapTypeChanged() {
         switch mapTypeSegmentedControl.selectedSegmentIndex {
         case 0:
             mapView.mapType = .standard
         case 1:
             mapView.mapType = .satellite
         case 2:
             mapView.mapType = .hybrid
         default:
             break
         }
     }
    
    func addAnnotation(at coordinate: CLLocationCoordinate2D) {
           let annotation = MKPointAnnotation()
           annotation.coordinate = coordinate
        annotation.title = "Point on the map".localized
           mapView.addAnnotation(annotation)
       }
    
    @objc
    func longPress(_ gr: UILongPressGestureRecognizer) {
        if gr.state == .began {
                    let touchLocation = gr.location(in: mapView)
                    let coordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
                    

                    mapView.removeAnnotations(mapView.annotations)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
            annotation.title = "Destination".localized
                    mapView.addAnnotation(annotation)
                    
    
                
                    showRoute(to: coordinate)
                }
    }
    
    func showRoute(to destinationCoordinate: CLLocationCoordinate2D) {
        guard let userLocation = locationManager.location else { return }
        
        let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Error calculating directions: \(error.localizedDescription)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    @objc func clearMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    
    }
    
}

extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let location = locations.last else { return }
           let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
           mapView.setRegion(region, animated: true)
       }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(overlay: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5.0
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
