//
//  ViewController.swift
//  MapApplication
//
//  Created by LoganMacMini on 2024/4/7.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    private var viewModel = ViewModel()
    
    private let mapView: MKMapView = {
        let map = MKMapView()
        map.isUserInteractionEnabled = true
        map.showsCompass = true
        return map
    }()
    
    private let collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        
        collection.delegate = self
        collection.dataSource = self
        mapView.delegate = self
        viewModel.delegate = self
        viewModel.fetchLocationData()
    }
    
    private func layout() {
        
        mapView.addSubview(collection)
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            collection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collection.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            collection.heightAnchor.constraint(equalToConstant: 150),
        ])
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mapView.frame = view.bounds
    }
}

extension ViewController: ViewModelDelegate {
    func viewModel(didReceiveData data: [LocationElement]) {
        viewModel.locations = data
        
        placeMarks(addresses: viewModel.locations)
        
        DispatchQueue.main.async { [unowned self] in
            self.collection.reloadData()
        }
    }
    
    func placeMarks(addresses: [LocationElement]) {
                
        addresses.forEach { address in
            CLGeocoder().geocodeAddressString(address.address) { placemarks, error in

                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let placemarks = placemarks {
                    //取得第一個地點標記
                    let placemark = placemarks[0]
                    
                    //加上標記
                    let annotation = MKPointAnnotation()
                    annotation.title = address.title
                    annotation.subtitle = address.address
                    
                    if let location = placemark.location {
                        annotation.coordinate = location.coordinate
                        self.mapView.addAnnotation(annotation)
                        print("address:\(address.address)")
                    }
                }
            }
        }
    }
    
    func viewModel(didReceiveError error: any Error) {
        print("\(error.localizedDescription)")
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("viewModel.locations.count:\(viewModel.locations.count)")
        return viewModel.locations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        
        guard let image = viewModel.locations[indexPath.row].image,
              let subtitle = viewModel.locations[indexPath.row].city else {
            return UICollectionViewCell()
        }
        let title = viewModel.locations[indexPath.row].title
        
        cell.configure(image: image, title: title, subtitle: subtitle)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        
        print("collectionView section:\(indexPath.section) didSelectItemAt:\(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                
        let width = collectionView.bounds.width * 0.8
        let height: CGFloat = collectionView.bounds.height
        
        print("width:\(width), height:\(height)")
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = collectionView.bounds.width * 0.8
        let totalSpacingWidth = (collectionView.bounds.width - totalCellWidth) / 2
        
        return UIEdgeInsets(top: 0, left: totalSpacingWidth, bottom: 0, right: totalSpacingWidth)
    }
    
    // collection view cell之間的間距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("scrollView.contentOffset.x:\(scrollView.contentOffset.x)")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustScrollViewContentOffset(scrollView: scrollView, collectionWidth: collection.bounds.width)
    }
    
    func adjustScrollViewContentOffset(scrollView: UIScrollView, collectionWidth: CGFloat) {
        
        let collectionViewWidth = collectionWidth * 0.8
        let currentIdx = Int(floor(scrollView.contentOffset.x / collectionViewWidth))
        
        if currentIdx != 0 && currentIdx != viewModel.locations.count - 1 {
            // 當currentIdx非第一筆跟最後一筆時
            var newOffsetX = scrollView.contentOffset.x - CGFloat(49 * currentIdx)
            // 確保 newOffsetX不會小於0 或大於 scrollView 的最大滾動範圍
            newOffsetX = max(0, newOffsetX)
            newOffsetX = min(newOffsetX, scrollView.contentSize.width - scrollView.bounds.width)

            scrollView.setContentOffset(CGPoint(x: newOffsetX, y: scrollView.contentOffset.y), animated: true)
        }
                
        let matchedAnnotation :[MKAnnotation] = mapView.annotations.filter { annotation in
            return annotation.title ?? "" == viewModel.locations[currentIdx].title
        }
                
        //顯示標記
        self.mapView.showAnnotations(matchedAnnotation, animated: true)
        mapView.selectAnnotation(matchedAnnotation[0], animated: true)
        mapView.region = MKCoordinateRegion(center: matchedAnnotation[0].coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        
        //判斷標記點是否與使用者相同，若為 true 就回傳 nil
        if annotation is MKUserLocation {
            return nil
        }
        
        // 創建一個重複使用的 AnnotationView
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")
        if annotationView == nil {
            // 如果 annotationView 為 nil就初始化一個 MKPinAnnotationView
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }
        
        // 設定中間描述
        let label = UILabel()
        label.text = "點擊查看資訊"
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        annotationView?.detailCalloutAccessoryView = label
        
        // 設定右方按鈕
        let button = UIButton(type: .infoLight)
        button.addTarget(self, action: #selector(checkDetail), for: .touchUpInside)
        annotationView?.rightCalloutAccessoryView = button
//        annotationView?.image = UIImage(named: "pin")?.withRenderingMode(.automatic)
        annotationView?.canShowCallout = true
        return annotationView
    }
    
    @objc private func checkDetail() {
        print("check")
    }
}
