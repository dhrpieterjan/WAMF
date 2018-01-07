//
//  BestellingenDetailTableViewController.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 11/11/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import UIKit
import SwiftQRCode


class BestellingenDetailTableViewController: UITableViewController {

    var bestelling: Bestelling!


    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "BestellingenTableViewCell", bundle: nil), forCellReuseIdentifier: "tableHeader")
        
    }
    
    @IBAction func unwindFromshowPresenter(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindFromshowqrcode(_ segue: UIStoryboardSegue){
        
    }
    
    
    @IBAction func addFavorietenBtn(_ sender: UIBarButtonItem) {
        
        let actionSheet = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let view = UIView(frame: CGRect(x: 8.0, y: 8.0, width: actionSheet.view.bounds.size.width - 8.0 * 4.5, height: 120.0))
        view.backgroundColor = UIColor.green
        actionSheet.view.addSubview(view)
        actionSheet.addAction(UIAlertAction(title: "Add to a Playlist", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Create Playlist", style: .destructive , handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Remove from this Playlist", style: .destructive, handler: nil))

        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    @IBAction func ShowQRCode(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let view = UIView(frame: CGRect(x: 8.0, y: 8.0, width: actionSheet.view.bounds.size.width - 8.0 * 4.5, height: 150.0))
        
        let imagev = UIImageView(frame: CGRect(x: (actionSheet.view.bounds.size.width - 8 - 150)  , y: 8.0, width: 110, height: 110))
        let infoLabel = UILabel(frame: CGRect(x: 8.0, y: 0, width: (actionSheet.view.bounds.size.width - 160 ), height: 130))
        infoLabel.text = "1: Open de app \n2: Druk op de plus rechts boven \n3: selecteer het camera-icoon. \n4: Scan deze code en druk op \t\t \"Subscribe\""
        infoLabel.font = infoLabel.font.withSize(13.0)
        infoLabel.numberOfLines = 5
        imagev.image = QRCode.generateImage((bestelling.recordID?.recordName)!, avatarImage: UIImage(named: ""))
        view.addSubview(infoLabel)
        view.addSubview(imagev)
        
        actionSheet.view.addSubview(view)
        
        actionSheet.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
        
    }

}

extension BestellingenDetailTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stdcell", for: indexPath)
        
        cell.textLabel?.text = "Aantal Subs: \(bestelling.aantalSubs)"
        cell.detailTextLabel?.text = "\(bestelling.bestForPerson.count)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: "tableHeader") as! BestellingenTableViewCell
        
        header.naamLabel.text = bestelling.naam.uppercased()
        header.aantalSubsLabel.text = "#" + String(bestelling.aantalSubs)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy HH:mm"
        header.creationDate.text = formatter.string(from: bestelling.creationDate)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
}
