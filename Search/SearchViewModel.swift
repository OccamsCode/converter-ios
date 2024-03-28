import Foundation

protocol FlagDelegate {
    func updateFlag()
}

final class SearchViewModel {
    
    enum Constants {
       static let title = "Search"
    }
    
    var filteredArray: [MetaData] = [] {
        didSet {
            onUpdate()
        }
    }
    
    var metaDataArray: [MetaData] = [] {
        didSet {
            onUpdate()
        }
    }
    
    var onUpdate: (() -> Void) = {}

    func fetchMetaData() {
        NetworkManager.shared.fetchMetaData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let metaData):
                    self.metaDataArray = metaData
                    self.filteredArray = self.metaDataArray
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
