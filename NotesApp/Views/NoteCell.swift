//
//  NoteCell.swift
//  NotesApp
//
//  Created by Marc Meinhardt on 16.02.20.
//  Copyright © 2020 Marc Meinhardt. All rights reserved.
//

import UIKit

class NoteCell: UITableViewCell {
    
    var noteData: Note! {
        
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mma dd-MM-yy"
            
            noteTitle.text = noteData.title
            dateLabel.text = dateFormatter.string(from: noteData.date ?? Date())
            previewLabel.text = noteData.text
        }
    }
    
    fileprivate var noteTitle: UILabel = {
        let label = UILabel()
        label.text = "#####"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    fileprivate var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "#####"
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = .gray
        return label
    }()
    
    fileprivate var previewLabel: UILabel = {
        let label = UILabel()
        label.text = "The note's text will go here to create a preview..."
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textColor = UIColor.gray.withAlphaComponent(0.9)
        return label
    }()
    
    fileprivate lazy var horizontalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [dateLabel, previewLabel, UIView()])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .leading
        return stack
    }()
    
    fileprivate lazy var verticalStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [noteTitle, horizontalStackView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(verticalStackView)
        verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        verticalStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
