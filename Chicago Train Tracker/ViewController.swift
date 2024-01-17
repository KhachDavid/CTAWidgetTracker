import Foundation
import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    private var mapView: MapView!
    private var listView: ListView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView = MapView()
        listView = ListView()
        
        // Create tab bar
        let tabBar = UITabBarController()
        
        mapView.configureView()
        
        let mapTab = UINavigationController(rootViewController: mapView)
        let listTab = UINavigationController(rootViewController: listView)
        mapTab.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)
        listTab.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.bullet"), tag: 1)
        
        tabBar.viewControllers = [listTab, mapTab]
        tabBar.selectedIndex = 0
        
        addChild(tabBar)
        view.addSubview(tabBar.view)
        tabBar.didMove(toParent: self)

    }
}
