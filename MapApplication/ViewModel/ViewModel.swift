//
//  ViewModel.swift
//  MapApplication
//
//  Created by LoganMacMini on 2024/4/7.
//

protocol ViewModelDelegate: AnyObject {
    func viewModel(didReceiveData data: [LocationElement])
    func viewModel(didReceiveError error: Error)
}

final class ViewModel {
    
    var locations: [LocationElement] = []
    
    weak var delegate: ViewModelDelegate?
    
    func fetchLocationData() {
        APIClient.shared.fetchData { [weak self] location, error in
            if let error = error {
                // If there's an error, inform the delegate about the error
                self?.delegate?.viewModel(didReceiveError: error)
                return
            }
            
            guard let location = location else {
                return
            }
            
            self?.delegate?.viewModel(didReceiveData: location.locations)
        }
    }
}
