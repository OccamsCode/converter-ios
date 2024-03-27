import Foundation

struct DependencyProvider {
    static var searchViewController: SearchViewController {
        let searchVC = SearchViewController()
        searchVC.viewModel = searchViewModel
        return searchVC
    }
    
    static var converterViewController: ConverterViewController {
        let converterVC = ConverterViewController()
        converterVC.viewModel = converterViewModel
        return converterVC
    }
    
    static var converterViewModel: ConverterViewModel {
        let converterVM = ConverterViewModel()
        return converterVM
    }
    
    static var searchViewModel: SearchViewModel {
        let searchViewModel = SearchViewModel()
        return searchViewModel
    }
}
