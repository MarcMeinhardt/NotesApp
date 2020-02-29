//
//  ViewController.swift
//  NotesApp
//
//  Created by Marc Meinhardt on 15.02.20.
//  Copyright © 2020 Marc Meinhardt. All rights reserved.
//

import UIKit

//let firstFolderNotes = [
//    Note(title: "UITableViews", date: Date(), text: "Table views use protocols to receive data."),
//    Note(title: "Collection Views", date: Date(), text: "Collection views can be customized with flow layouts to create layouts like you see in the Pinterest app."),
//    Note(title: "Flow Layouts", date: Date(), text: "Custom layouts can be made with UICollectionViewFlowLayout.")
//]
//
//let secondFolderNotes = [
//    Note(title: "Instagram", date: Date(), text: "Photos and photos."),
//    Note(title: "YouTube Channel", date: Date(), text: "Videos and Music")
//]
//
//var noteFolders:[NoteFolder] = [
//    NoteFolder(title: "Course Notes", notes: firstFolderNotes),
//    NoteFolder(title: "Social Media", notes: secondFolderNotes)
//]

var noteFolders = [NoteFolder]()

class FoldersController: UITableViewController {

    // MARK: - Properties
    fileprivate var textField: UITextField!
    
    fileprivate let CELL_ID: String = "CELL_ID"
    
    fileprivate let headerView:UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        let label = UILabel(frame: CGRect(x: 20, y: 15, width: 100, height: 20))
        label.text = "iCLOUD"
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = .darkGray
        headerView.addBorder(toSide: .bottom, withColor: UIColor.lightGray.withAlphaComponent(0.5).cgColor, andThickness: 0.3)
        headerView.addSubview(label)
        return headerView
    }()
    
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Library"
        noteFolders = CoreDataManager.shared.fetchNoteFolder()
        setupTableView()
    }
    
    
    // MARK: - View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(false, animated: false)
        
        let items:[UIBarButtonItem] = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "New Folder", style: .done, target: self, action: #selector(self.handleAddNewFolder))
        ]
        
        self.toolbarItems = items
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
        self.navigationItem.setRightBarButtonItems([editButton], animated: false)
        self.navigationController?.toolbar.tintColor = .primaryColor
        self.navigationController?.navigationBar.tintColor = .primaryColor
        
        setupTranslucentViews()
        
        self.tableView.reloadData()
    }
    
    
    // MARK: - Handlers
    
    @objc fileprivate func handleAddNewFolder() {
        print("Trying to add new folder")
        
        let addAlert = UIAlertController(title: "New Folder", message: "Enter a name for this folder", preferredStyle: .alert)
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            addAlert.dismiss(animated: true)
        }))
        
        addAlert.addTextField { (tf) in
            // reference textfield outside this method
            self.textField = tf
        }
        
        addAlert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            addAlert.dismiss(animated: true)
            // insert new folder with the correct title
            guard let title = self.textField.text else { return }
            print(title)
            
            let newFolder = CoreDataManager.shared.createNoteFolder(title: title)
            noteFolders.append(newFolder)
            self.tableView.insertRows(at: [IndexPath(row: noteFolders.count - 1, section: 0)], with: .fade)
//            let newFolder = NoteFolder(title: title, notes: [])
        }))
        
        present(addAlert, animated: true)
    }
    
    // Method To Hide The Tool Bar When Moving To A New View Controller
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setToolbarHidden(true, animated: false)
//    }

    // MARK: - Functions
    
    fileprivate func setupTableView() {
        tableView.register(FolderCell.self, forCellReuseIdentifier: CELL_ID)
        tableView.tableHeaderView = headerView
    }
    
    fileprivate func getImage(withColor color: UIColor, andSize size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    fileprivate func setupTranslucentViews() {
        let toolBar = self.navigationController?.toolbar
        let navigationBar = self.navigationController?.navigationBar
        
        let slightWhite = getImage(withColor: UIColor.systemBackground.withAlphaComponent(0.9), andSize: CGSize(width: 30, height: 30))
        toolBar?.setBackgroundImage(slightWhite, forToolbarPosition: .any, barMetrics: .default)
        toolBar?.setShadowImage(UIImage(), forToolbarPosition: .any)
        
        navigationBar?.setBackgroundImage(slightWhite, for: .default)
        navigationBar?.shadowImage = slightWhite
    }
}


extension FoldersController {

    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction {

        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            completion(true)

            let noteFolder = noteFolders[indexPath.row]

            print("trying to delete item at indexPath:",indexPath)

            if CoreDataManager.shared.deleteNoteFolder(noteFolder: noteFolder) {
                noteFolders.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                completion(true)
            }
        }

        action.backgroundColor = .red

        return action
    }


    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let delete = deleteAction(at: indexPath)

        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    // Outdated editActionsForRowAt Swift 4.2 Code
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
//
//            let noteFolder = noteFolders[indexPath.row]
//
//            if CoreDataManager.shared.deleteNoteFolder(noteFolder: noteFolder) {
//                noteFolders.remove(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .fade)
//            }
//        }
//        return [deleteAction]
//    }
    
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteFolders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! FolderCell
        let folderForRow = noteFolders[indexPath.row]
//        cell.label.text = folderForRow.title
//        cell.countLabel.text = String(folderForRow.notes.count)
        cell.folderData = folderForRow
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let folderNotesController = FoldersNotesController()
        let folderForRowSelected = noteFolders[indexPath.row]
        folderNotesController.folderData = folderForRowSelected
        navigationController?.pushViewController(folderNotesController, animated: true)
    }
}

