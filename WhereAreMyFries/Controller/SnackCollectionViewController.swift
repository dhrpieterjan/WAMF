//
//  SnackCollectionViewController.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 09/11/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SnackCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var CounterLabel: UILabel!
    var snacks: [String: [Snack]] = [:]
    var selectedSnacks: [Snack] = []
    let inset:CGFloat = 10
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet var colView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ScackRepository().initialiseData()
        
        
        collectionView?.register(UINib(nibName: "SnackCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Snackcell")
        
        qdb()
        
        collectionView?.allowsMultipleSelection = true
        
        if selectedSnacks.count >= 1 {
            addBtn.isEnabled = true
        } else {
            addBtn.isEnabled = false
        }
        
    }
    
    @IBAction func unwindFromCancelNewFavorite(_ segue: UIStoryboardSegue) {
    }
    
    @IBAction func unwindFromAddlNewFavorite(_ segue: UIStoryboardSegue) {
        self.selectedSnacks.removeAll()
        for idp in (self.collectionView?.indexPathsForSelectedItems)! {
            self.collectionView?.deselectItem(at: idp, animated: true)
            self.collectionView?.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewFavorite" {
            let vc = segue.destination as! AddFavoriteViewController
            vc.snacks = selectedSnacks
        }
    }
    
    func qdb() {
        
        let items = self.navigationItem.rightBarButtonItems!
        
        let indicatorView = UIActivityIndicatorView()
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        indicatorView.color = UIColor.black
        let barloaderItem = UIBarButtonItem(customView: indicatorView)
        //navbarLoadingBtns.append(barloaderItem)
        self.navigationItem.setRightBarButton(barloaderItem, animated: true)
        
        ScackRepository().getAllSnacks { dbsnacks in
            self.snacks = dbsnacks
            self.collectionView?.reloadData()
            self.navigationItem.setRightBarButtonItems(items, animated: true)
        }
    }
}

extension SnackCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var arr = Array(snacks.keys)
        let sectionName = arr[section]
        
        return (snacks[sectionName]?.count)!
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Snackcell", for: indexPath) as! SnackCollectionViewCell
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        cell.snackNameLabel.textColor = UIColor.white
        
        var arr = Array(snacks.keys)
        var snackarray = snacks[arr[indexPath.section]]
        
        cell.snack = snackarray![indexPath.row]
        
        //print(selectedSnacks)
        
        for snack in selectedSnacks {
            if snack.image == cell.snack!.image {
                cell.enable(bool: true)
            }else {
                cell.enable(bool: false)
            }
        }
        
        //print(snacks[arr[indexPath.section]]![indexPath.row])
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return snacks.keys.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SnackViewSectionHeader", for: indexPath) as! SnackSectionHeaderCollectionReusableView
        
        var arr = Array(snacks.keys)
        let sectionName = arr[indexPath.section]
        
        cell.sectionNameLabel.text = sectionName
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.right)
        
        let cell = collectionView.cellForItem(at: indexPath) as! SnackCollectionViewCell
        cell.enable(bool: true)
        cell.snackNameLabel.textColor = UIColor.black
        selectedSnacks.append(cell.snack!)
        //collectionView.reloadItems(at: collectionView.indexPathsForSelectedItems!)
        CounterLabel.text = "\(selectedSnacks.count)"
        if selectedSnacks.count >= 1 {
            addBtn.isEnabled = true
        } else {
            addBtn.isEnabled = false
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let cell = collectionView.cellForItem(at: indexPath) as! SnackCollectionViewCell
        cell.enable(bool: false)
        cell.snackNameLabel.textColor = UIColor.white
        //collectionView.reloadItems(at: collectionView.indexPathsForSelectedItems!)
        selectedSnacks.remove(at: selectedSnacks.index(of: cell.snack!)!)
        CounterLabel.text = "\(selectedSnacks.count)"
        if selectedSnacks.count >= 1 {
            addBtn.isEnabled = true
        } else {
            addBtn.isEnabled = false
        }
    }
    
    
    
}

extension SnackCollectionViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - (5 * inset)) / 3, height: (collectionView.bounds.width - (4 * inset)) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
}
