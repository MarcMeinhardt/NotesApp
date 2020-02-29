//
//  CoreDataManager.swift
//  NotesApp
//
//  Created by Marc Meinhardt on 20.02.20.
//  Copyright © 2020 Marc Meinhardt. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    // MARK: - Properties
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NotesApp")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading stores failed: \(err)")
            }
        }
        return container
    }()
    
    
    // MARK: - Notes Folder Functions
    
    // STEP 1. createNoteFolder
    func createNoteFolder(title: String) -> NoteFolder {
        let context = persistentContainer.viewContext
        
        let newNoteFolder = NSEntityDescription.insertNewObject(forEntityName: "NoteFolder", into: context) as! NoteFolder
        
        newNoteFolder.title = title
//        newNoteFolder.setValue(title, forKey: "title")
        
        do {
            try context.save()
            print("Trying to save folder")
            return newNoteFolder
        } catch let err {
            print("Failed to save new note folder:", err)
            return newNoteFolder
        }
    }
    
    
    // STEP 2. fetchNoteFolder
    func fetchNoteFolder() -> [NoteFolder] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NoteFolder>(entityName: "NoteFolder")
        
        do {
            let noteFolders = try context.fetch(fetchRequest)
            return noteFolders
            
        } catch let err {
            print("Failed to fetch note folders:", err)
            return []
        }
        
    }
    
    // STEP 3: deleteNoteFolder Function
    func deleteNoteFolder(noteFolder: NoteFolder) -> Bool {
        
        let context = persistentContainer.viewContext
        
        context.delete(noteFolder)
        
        do {
            try context.save()
            return true
        } catch let err {
            print("Error deleting note folder entity instance", err)
            return false
        }
    }
    
    
    // MARK: - Notes Functions
    
    // STEP 1: create new notes function
    func createNewNote(title: String, date: Date, text: String, noteFolder: NoteFolder) -> Note {
        
        let context = persistentContainer.viewContext
        
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context) as! Note
        
        newNote.title = title
        newNote.text = text
        newNote.date = date
        newNote.noteFolder = noteFolder
        
        
        do {
            try context.save()
            print("Trying to save folder")
            return newNote
        } catch let err {
            print("Failed to save new note folder:", err)
            return newNote
        }
    }
    
    // STEP 2: fetch notes function
    func fetchNotes(from noteFolder: NoteFolder) -> [Note] {
        
        guard let folderNotes = noteFolder.notes?.allObjects as? [Note] else { return [] }
        return folderNotes
    }
    
    // STEP 3: delete notes function
    func deleteNote(note: Note) -> Bool {
        
        let context = persistentContainer.viewContext
        
        context.delete(note)
        
        do {
            try context.save()
            return true
        } catch let err {
            print("Error deleting note entity instance", err)
            return false
        }
    }
    
    // STEP 4: update existing note function
    func saveUpdatedNote(note: Note, newText: String) {
        
        let context = persistentContainer.viewContext
        
        note.title = newText
        note.text = newText
        note.date = Date()
        
        do {
            try context.save()
        } catch let err {
            print("error saving/updating updated note : ", err)
        }
    }
}
