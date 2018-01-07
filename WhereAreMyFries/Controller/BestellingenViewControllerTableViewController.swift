//
//  BestellingenViewControllerTableViewController.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 28/10/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

class BestellingenViewControllerTableViewController: UITableViewController{
    
    @IBOutlet weak var bestellingTableView: UITableView!
    
    var bestelling : Bestelling?
    var bestellingen: [Bestelling] = []
    var userRecordID: CKRecordID!
    var navbarLoadingBtns: [UIBarButtonItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.register(UINib(nibName: "BestellingenTableViewCell", bundle: nil), forCellReuseIdentifier: "BestellingenTableViewCell")
        
        navbarLoadingBtns = self.navigationItem.rightBarButtonItems!
        
        let indicatorView = UIActivityIndicatorView()
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        indicatorView.color = UIColor.black
        let barloaderItem = UIBarButtonItem(customView: indicatorView)
        //navbarLoadingBtns.append(barloaderItem)
        self.navigationItem.setRightBarButton(barloaderItem, animated: true)
        
        
        qdb()
        
        refreshControl?.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
    }

    @objc private func refresh(_ :AnyObject) {
        qdb()
        self.refreshControl?.endRefreshing()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bestellingSegue" {
            
            if let destVC = segue.destination as? BestellingenDetailTableViewController {
                
                destVC.bestelling = self.bestelling
                
            }
        }
    }
    
    
    @IBAction func unwindFromAddBestelling(_ segue: UIStoryboardSegue) {
        
        self.qdb()
        
    }
    
    
    func qdb() {
        
        BestellingenRepository().getBestellingenForUser { bestellingen in
            
            self.bestellingen = bestellingen
            
            //self.tableView.reloadData()
            UIView.transition(with: self.tableView, duration: 0.2, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
            
            
            self.navigationItem.setRightBarButtonItems(self.navbarLoadingBtns, animated: true)
        }
    }
}

extension BestellingenViewControllerTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bestellingen.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BestellingenTableViewCell", for: indexPath) as! BestellingenTableViewCell
        let best = bestellingen[indexPath.row]
        cell.naamLabel.text = best.naam.uppercased()
        cell.aantalSubsLabel.text = "#" + String(best.aantalSubs)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy HH:mm"
        cell.creationDate.text = formatter.string(from: best.creationDate)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.bestelling = self.bestellingen[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "bestellingSegue", sender: self)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            
            BestellingenRepository().unsubscribeFrom(BestellingsRecordId: bestellingen[indexPath.row].recordID!, done: {
                //self.qdb()
            })
            bestellingen.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
        }
    }
    
}








