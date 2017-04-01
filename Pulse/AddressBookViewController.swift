//
//  AddressBookViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/30/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import Contacts

class AddressBookViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
//    @IBOutlet weak var searchBar: UISearchBar!
    
    fileprivate var datasource: [CNContact] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupAppearance()
        self.setupTableView()
        self.checkContactAuthorization {
            self.fetchContacts()
        }
    }
    
    func setupAppearance() {
        self.sendButton.layer.cornerRadius = 3.0
    }
    
    func setupTableView() {
        let cell: UINib = UINib(nibName: "AddressBookCell", bundle: nil)
        self.tableView.register(cell, forCellReuseIdentifier: "addressBookCell")
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func checkContactAuthorization(completion: @escaping () -> Void) {
        let errorMessage: String = "User has denied access to contacts."
        let authorization = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        switch authorization {
        case .authorized:
            completion()
        case .denied:
            print(errorMessage)
        case .restricted: break
            
        case .notDetermined:
            CNContactStore().requestAccess(for: CNEntityType.contacts, completionHandler: { (success, error) in
                if success {
                    completion()
                } else {
                    print(errorMessage)
                    print(error?.localizedDescription ?? errorMessage)
                }
            })
        }
    }
    
    func fetchContacts() {
//        
//        let store = CNContactStore()
//        guard let keysToFetch = [CNContactEmailAddressesKey, CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactThumbnailImageDataKey] as? [CNKeyDescriptor] else { return }
//        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
//        var cnContacts = [CNContact]()
//        
//        do {
//            try store.enumerateContacts(with: request) {
//                (contact, cursor) -> Void in
//                if !contact.emailAddresses.isEmpty {
//                    cnContacts.append(contact)
//                }
//            }
//        } catch let error {
//            print("Fetch contact error: \(error.localizedDescription)")
//        }
//        OperationQueue.main.addOperation { 
//            self.datasource = cnContacts
//        }
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension AddressBookViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddressBookCell = tableView.dequeueReusableCell(withIdentifier: "addressBookCell", for: indexPath) as! AddressBookCell
        cell.contentView.backgroundColor = tableView.backgroundColor
        let contact: CNContact = self.datasource[indexPath.row]
        cell.nameLabel.text = contact.givenName + " " + contact.familyName
        cell.emailLabel.text = contact.emailAddresses.first?.value as String?
        if let imageData: Data = contact.thumbnailImageData {
            guard let image: UIImage = UIImage(data: imageData) else { return cell }
            cell.avatarImageView.image = image
         }
        return cell
    }
}
