//
//  FolderCell.swift
//  NotesApp
//
//  Created by Marc Meinhardt on 16.02.20.
//  Copyright © 2020 Marc Meinhardt. All rights reserved.
//

import UIKit

class FolderCell: UITableViewCell {
    
    var folderData: NoteFolder! {
        
        didSet {
            //print(folderData.title)
            label.text = folderData.title
            // Get Accurate Note Count For Folders
            let count = CoreDataManager.shared.fetchNotes(from: folderData).count
            countLabel.text = String(count)
            
            //countLabel.text = String(folderData.notes.count)
        }
    }
    
    fileprivate var label: UILabel = {
        let label = UILabel()
        label.text = "Folder Title"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    fileprivate var countLabel: UILabel = {
        let label = UILabel()
        label.text = "##"
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    // lazy var instantiate the variable after it instantiates the other variables first
    fileprivate lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [label, countLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        return sv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        contentView.addSubview(stackView)
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
