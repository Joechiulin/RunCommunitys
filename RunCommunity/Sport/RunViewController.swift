//
//  RunViewController.swift
//  RunCommunity
//
//  Created by Joe on 2019/4/12.
//  Copyright © 2019 PIG. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class RunViewController: UIViewController  {
    @IBOutlet weak var mview: UIView!
    let userDefault = UserDefaults.standard
    let url_server = URL(string: common_url + "ServerConnectServlet")

  //  let url_server = URL(string: "http://127.0.0.1:8080/ServerConnect_Web/ServerConnectServlet")
    @IBOutlet weak var btstop: UIButton!
    @IBOutlet weak var btstart: UIButton!
    @IBOutlet weak var mapview: MKMapView!
    @IBOutlet weak var lbdis: UILabel!
    @IBOutlet weak var lbtime: UILabel!
    @IBOutlet weak var lbpace: UILabel!
//    private let locationManagers = LocationManager.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    private var formattedDistance = ""
    private var formattedTime = ""
    private var formattedPace = ""

    
    let locationManager = LocationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        locationManager.requestWhenInUseAuthorization()
        mapview.delegate = self
        setMapRegion()
        mapview.showsUserLocation = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        locationManager.stopUpdatingLocation()
    }
    
    func setMapRegion() {
        let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        var region = MKCoordinateRegion()
        region.span = span
        mapview.setRegion(region, animated: true)
        mapview.regionThatFits(region)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if !mapView.isUserLocationVisible {
            mapView.setCenter(userLocation.coordinate, animated: true)
        }
    }
    @IBAction func stopbt(_ sender: Any) {
        self.saveRun()
        self.stopRun()

        let alertController = UIAlertController(title: "結束",
                                                message: "是否新增貼文",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel))
        alertController.addAction(UIAlertAction(title: "新增貼文", style: .default) { _ in
            self.stopRun()
            self.naxtpage()
        })
        alertController.addAction(UIAlertAction(title: "放棄貼文", style: .destructive) { _ in
            self.stopRun()
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
        
        present(alertController, animated: true)
    
    }
    private func naxtpage(){
        if let controller = storyboard?.instantiateViewController(withIdentifier: "runinsert") as? RuninsertiVC  {
            print(formattedTime)
            controller.pace = formattedPace
            controller.time = formattedTime
            controller.distance = formattedDistance
            present(controller, animated: true, completion: nil)
        }
    }
    private func saveRun() {
        
        var requestParam = [String: String]()
        requestParam["action"] = "runinsert"

        let  account = self.userDefault.string(forKey: "useraccount")
        let image = takeSnapshotOfView(view: mview)
        
        requestParam["account"] = account
        requestParam["time"] = formattedTime
        requestParam["distance"] = formattedDistance
        if image != nil {
            requestParam["imageBase64"] = image!.jpegData(compressionQuality: 1.0)!.base64EncodedString()
       //照片存檔     UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)

        }
         executeTask(self.url_server!, requestParam) { (data, response, error) in
            if error == nil {
                if data != nil {
                    if let result = String(data: data!, encoding: .utf8) {
                        if let count = Int(result) {
                            DispatchQueue.main.async {
                                // 新增成功則回前頁
                                if count != 0 {                                            self.navigationController?.popViewController(animated: true)
                                } else {
                                    print("insert fail")
                                }
                            }
                        }
                    }
                }
            } else {
                print(error!.localizedDescription)
            }
        }

        
        
      
    }
    func takeSnapshotOfView(view:UIView) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: view.frame.size.width, height: view.frame.size.height))
        view.drawHierarchy(in: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height), afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    private func stopRun() {
       
        btstart.isHidden = false
        btstop.isHidden = true
        timer?.invalidate()
        locationManager.stopUpdatingHeading()
    }
    
    @IBAction func startbt(_ sender: Any) {
        btstart.isHidden = true
        btstop.isHidden = false
        seconds = 0
        distance = Measurement(value: 0, unit: UnitLength.meters)
        locationList.removeAll()
        updateDisplay()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.eachSecond()
        }
        startLocationUpdates()
        
        
    }
    func eachSecond() {
        seconds += 1
        updateDisplay()
    }
    
    private func updateDisplay() {
        formattedDistance = FormatDisplay.distance(distance)
        formattedTime = FormatDisplay.time(seconds)
        formattedPace = FormatDisplay.pace(distance: distance,
                                               seconds: seconds,
                                               outputUnit: UnitSpeed.minutesPerKilometer)

        lbdis.text = "距離: \(formattedDistance)"
        lbtime.text = "時間: \(formattedTime)"
//        lbpace.text = "均速: \(formattedPace)"
        lbpace.text = "均速: \(formattedPace)"
    }
    private func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.startUpdatingLocation()
    }
    
}
extension RunViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                let coordinates = [lastLocation.coordinate, newLocation.coordinate]
                mapview.addOverlay(MKPolyline(coordinates: coordinates, count: 2))
                let region =
                    MKCoordinateRegion(center: newLocation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
                mapview.setRegion(region, animated: true)
            }
            
            locationList.append(newLocation)
        }
    }
}
extension RunViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer(overlay: overlay)
        }
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = .blue
        renderer.lineWidth = 3
        return renderer
    }
}
