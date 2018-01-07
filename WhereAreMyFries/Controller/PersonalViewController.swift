
import UIKit
import CloudKit

class PersonalViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var Favorites: [FavForPers] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        refresh()
       
    }
    
    @objc private func refresh(_ :AnyObject) {
        refresh()
        tableView.refreshControl?.endRefreshing()
    }
    
    func refresh() {
        BestellingenRepository().getFavBestellingn(completionHandler: { (FavsForPers) in
            DispatchQueue.main.async {
                self.Favorites = FavsForPers
                self.tableView.reloadData()
            }
        })
    }

}

extension PersonalViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Favorites.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCell") as! FavTableViewCell
        cell.detailLabel.text = Favorites[indexPath.row].toString()
        cell.namelabel.text = Favorites[indexPath.row].naam!
        return cell
    }
    
}

extension PersonalViewController: UITableViewDelegate {
    
    
}
