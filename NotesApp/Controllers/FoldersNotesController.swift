//
//  FoldersNotesController.swift
//  NotesApp
//
//  Created by Marc Meinhardt on 15.02.20.
//  Copyright © 2020 Marc Meinhardt. All rights reserved.
//

import UIKit

extension FoldersNotesController: NoteDelegate {
    
    func saveNewNote(title: String, date: Date, text: String) {
        
        let newNote = CoreDataManager.shared.createNewNote(title: title, date: date, text: text, noteFolder: self.folderData)
        notes.append(newNote)
        filteredNotes.append(newNote)
        self.tableView.insertRows(at: [IndexPath(row: notes.count - 1, section: 0)], with: .fade)
    }
}


class FoldersNotesController: UITableViewController {
    
    var notesString = ""
    lazy var notesCount = notes.count
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var folderData: NoteFolder! {
        didSet {
            
            // Fetch Data from CoreDataManager's note folder data
            notes = CoreDataManager.shared.fetchNotes(from: folderData)
            
            filteredNotes = notes
        }
    }
    
    fileprivate var notes = [Note]()
    fileprivate var filteredNotes = [Note]()
    
    var cachedText: String = ""
    
    fileprivate let CELL_ID: String = "CELL_ID"
    
    
    // MARK: - View Did Load
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = self.folderData.title
        
        setupTableView()
        setupSearchBar()
    }
    
    
    // MARK: - View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Reload table view data to show updated notes as soon as it appears
        tableView.reloadData()
        
        setupTabBar()
    }
    
    
    // MARK: - Handlers
    
    @objc fileprivate func createNewNote() {
        let noteDetailController = NoteDetailController()
        noteDetailController.delegate = self
        navigationController?.pushViewController(noteDetailController, animated: true)
    }
    
    
    // MARK: - Functions
    
    fileprivate func updateNotesCount() {
        if notesCount == 1 {
            notesString = "Note"
        } else {
            notesString = "Notes"
        }
    }
    
    fileprivate func setupTabBar() {
        notesCount = notes.count
        //print("Notes count : ", self.notesCount)

        updateNotesCount()
        
        let items: [UIBarButtonItem] = [
            //UIBarButtonItem(barButtonSystemItem: .organize, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "\(notesCount) \(notesString)", style: .done, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(self.createNewNote)),
        ]
        
        self.toolbarItems = items
    }
    
    fileprivate func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.obscuresBackgroundDuringPresentation = true
        searchController.searchBar.delegate = self
    }
    
    
    //MARK: Table View Data Source
    
    fileprivate func setupTableView() {
        tableView.register(NoteCell.self, forCellReuseIdentifier: CELL_ID)
    }
}


extension FoldersNotesController: UISearchBarDelegate {

    // MARK: - Functions
    
    // NOTE: This is the deprecated way of adding swipe actions to a UITableView row
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        var actions = [UITableViewRowAction]()
//
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
//            print("trying to delete item at indexPath:",indexPath)
//            let targetRow = indexPath.row
//            self.notes.remove(at: targetRow)
//            self.filteredNotes.remove(at: targetRow)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//        actions.append(deleteAction)
//
//        return actions
//    }
//
    private func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            completion(true)
            
            let targetRow = indexPath.row
            
            print("trying to delete item at indexPath:",indexPath)
             
            if CoreDataManager.shared.deleteNote(note: self.notes[targetRow]) {
                self.notes.remove(at: targetRow)
                self.filteredNotes.remove(at: targetRow)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                completion(true)
            }
            self.setupTabBar()
        }
        
        action.backgroundColor = .red
        
        return action
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteAction(at: indexPath)
        
        return UISwipeActionsConfiguration(actions: [delete])
    }

    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredNotes = notes.filter({ (note) -> Bool in
            return (note.title?.lowercased().contains(searchText.lowercased()) ?? false)
        })
        if searchBar.text!.isEmpty && filteredNotes.isEmpty {
            filteredNotes = notes
        }
        cachedText = searchText
        tableView.reloadData()
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if !cachedText.isEmpty && !filteredNotes.isEmpty {
            searchController.searchBar.text = cachedText
        }
    }
}


extension FoldersNotesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredNotes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! NoteCell
        let noteForRow = self.filteredNotes[indexPath.row]
        cell.noteData = noteForRow
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let noteDetailController = NoteDetailController()
        let noteData = self.filteredNotes[indexPath.row]

        noteDetailController.noteData = noteData
        navigationController?.pushViewController(noteDetailController, animated: true)
    }
    
}
