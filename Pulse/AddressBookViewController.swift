//
//  AddressBookViewController.swift
//  Pulse
//
//  Created by Design First Apps on 3/30/17.
//  Copyright © 2017 Mentor Ventures, Inc. All rights reserved.
//

import UIKit
import Contacts

class Contact: NSObject {
    
    var name: String
    var email: String
    var image: Data?
    
    init(name: String, email: String, image: Data?) {
        self.name = name
        self.email = email
        self.image = image
    }
    
}

class AddressBookViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
//    @IBOutlet weak var searchBar: UISearchBar!
    
    var task: Task?
    var sectionTextColor: UIColor = UIColor("C4C6C8")
    
    fileprivate var sectionDatasource: [String] = []
    
    fileprivate var datasource: [String : [Contact]] = [:] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    fileprivate var assignees: Set<Contact> = Set<Contact>() {
        didSet {
            let enabled: Bool = assignees.count > 0 ? true : false
            self.sendButtonEnabled(enabled)
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
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 60
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.sectionIndexColor = self.sectionTextColor
        self.tableView.sectionIndexBackgroundColor = self.tableView.backgroundColor
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
        
        let store = CNContactStore()
        let keysToFetch = [CNContactEmailAddressesKey as CNKeyDescriptor, CNContactFormatter.descriptorForRequiredKeys(for: .fullName) as CNKeyDescriptor, CNContactThumbnailImageDataKey as CNKeyDescriptor]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch)
        var cnContacts = [CNContact]()
        
        do {
            try store.enumerateContacts(with: request) {
                (contact, cursor) -> Void in
                if !contact.emailAddresses.isEmpty {
                    cnContacts.append(contact)
                }
            }
        } catch let error {
            print("Fetch contact error: \(error.localizedDescription)")
        }
        
        
        OperationQueue.main.addOperation {
            self.organizeContacts(cnContacts)
        }
    }
    
    private func organizeContacts(_ contacts: [CNContact]) {
        var datasource: [String : [Contact]] = [:]
        
        for contact in contacts {
            guard let nameFirstCharacter: Character = contact.givenName.characters.first else { continue }
            let nameLetter: String = String(nameFirstCharacter)
            
            for email in contact.emailAddresses {
                
                if email.value.contains("@") && email.value.contains(".") {
                    // Contact as dictionary
                    let name: NSString = contact.givenName + " " + contact.familyName as NSString
                    let contact: Contact = Contact(name: name as String, email: email.value as String, image: nil)
                    // Put this somewhere
                    
                    if var nameLetterArray: [Contact] = datasource[nameLetter] {
                        nameLetterArray.append(contact)
                        datasource.updateValue(nameLetterArray, forKey: nameLetter)
                    } else {
                        datasource.updateValue([contact], forKey: nameLetter)
                    }
                }
            }
        }
        let sectionDatasource: [String] = Array(datasource.keys.sorted())
        
        self.sectionDatasource = sectionDatasource
        self.datasource = datasource
    }
    
    fileprivate func sendButtonEnabled(_ enabled: Bool) {
        UIView.animate(withDuration: 0.1, animations: {
            self.sendButton.alpha = enabled ? 1.0 : 0.34
        }) { _ in
            self.sendButton.isEnabled = enabled
        }
    }
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        

        guard let task: Task = self.task else { return }
        
        var contactsArray: [[String : AnyObject]] = []
        for contact in self.assignees {
            let name: NSString = contact.name as NSString
            let email: NSString = contact.email as NSString
            let dictionary: [String : AnyObject] = ["name" : name, "email" : email]
            contactsArray.append(dictionary)
        }
        InviteService.inviteContactsToTask(taskId: task.objectId, contacts: contactsArray, success: { (invite) in
            
            self.performSegue(withIdentifier: "endCreateFlow", sender: nil)
            
        }) { (error, statusCode) in
            print("Error: \(statusCode ?? 000) \(error.localizedDescription)")
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        if self.navigationController != nil {
            _ = self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension AddressBookViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionDatasource.count
    }
    
//    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return self.sectionDatasource
//    }
//    
//    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
//        return index
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionDatasource[section]
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header: UITableViewHeaderFooterView? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        if header == nil {
            header = UITableViewHeaderFooterView(reuseIdentifier: "header")
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView else { return }
        header.contentView.backgroundColor = tableView.backgroundColor
        header.textLabel?.textColor = self.sectionTextColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource[self.sectionDatasource[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddressBookCell = tableView.dequeueReusableCell(withIdentifier: "addressBookCell", for: indexPath) as! AddressBookCell
        cell.contentView.backgroundColor = tableView.backgroundColor
        let contact: Contact = self.datasource[self.sectionDatasource[indexPath.section]]![indexPath.row]
        cell.nameLabel.text = contact.name
        cell.emailLabel.text = contact.email
//        if let imageData: Data = contact.thumbnailImageData {
//            guard let image: UIImage = UIImage(data: imageData) else { return cell }
//            cell.avatarImageView.image = image
//        } else {
        
//            let randomNumber: Int = (indexPath.row % 6) + 1 // This does not work properly with sections implemented
        
            let random: UInt32 = arc4random_uniform(6) + 1
            let avatarString: String = "AvatarRandom\(random)"
            if let image: UIImage = UIImage(named: avatarString) {
                cell.avatarImageView.image = image
            }
//        }
        cell.delegate = self
        return cell
    }
}

extension AddressBookViewController: AddressBookCellDelegate {
    
    func contactWasSelected(_ cell: AddressBookCell) {
        guard let indexPath: IndexPath = self.tableView.indexPath(for: cell) else { return }
        let contact: Contact = self.datasource[self.sectionDatasource[indexPath.section]]![indexPath.row]
        if self.assignees.contains(contact) {
            self.assignees.remove(contact)
            cell.state = .unselected
        } else {
            self.assignees.insert(contact)
            cell.state = .selected
        }
    }
}
