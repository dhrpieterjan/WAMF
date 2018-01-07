
import UIKit
import CloudKit

class PersonalViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var Favorites: [FavForPers] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                // error handling magic
                return
            }
            
            print("Got user record ID \(recordID.recordName).")
            DispatchQueue.main.async {
            }
            
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { record, error in
                guard let record = record, error == nil else {
                    // show off your error handling skills
                    return
                }
                
                print("The user record is: \(record)")
            }
            
            CKContainer.default().requestApplicationPermission(.userDiscoverability) { status, error in
                guard status == .granted, error == nil else {
                    // error handling voodoo
                    return
                }
                
                CKContainer.default().discoverUserIdentity(withUserRecordID: recordID) { identity, error in
                    guard let components = identity?.nameComponents, error == nil else {
                        // more error handling magic
                        return
                    }
                    
                    DispatchQueue.main.async {
                        let fullName = PersonNameComponentsFormatter().string(from: components)
                        print("The user's full name is \(fullName)")
                    }
                }
            }
            
            CKContainer.default().discoverAllIdentities { identities, error in
                guard let identities = identities, error == nil else {
                    // awesome error handling
                    return
                }
                
                print("User has \(identities.count) contact(s) using the app:")
                print("\(identities)")
            }
            
            
            
        }
        
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
