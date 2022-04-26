//
//  ViewController.swift
//  MyNotes
//
//  Created by ilia nikashov on 03.03.2022.
//

import UIKit
import CoreData

var noteList = [Note]()

class NoteTableViewController: UITableViewController {
    
    private var firstLoad = true
    
    
    override func viewDidLoad() {
        if firstLoad == true {
            createFirstNote()
            firstLoad = false
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results: NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let note = result as! Note
                    noteList.append(note)
                }
            } catch {
                print("Fetch failed")
            }
        }
    }
    
    
    private func nonDeletedNotes() -> [Note] {
            var noDeleteNoteList = [Note]()
            for note in noteList {
                if note.deletedDate == nil {
                    noDeleteNoteList.append(note)
                }
            }
            return noDeleteNoteList
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NoteCell
        let thisNote: Note!
        thisNote = nonDeletedNotes()[indexPath.row]
        noteCell.titleLabel.text = thisNote.title
        noteCell.descriptionLabel.text = thisNote.descr
        return noteCell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nonDeletedNotes().count
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNote" {
            let indexPath = tableView.indexPathForSelectedRow!
            let noteDetail = segue.destination as? NoteDetailViewController
            let selectedNote : Note!
            selectedNote = nonDeletedNotes()[indexPath.row]
            noteDetail!.selectedNote = selectedNote
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    private func createFirstNote() {
        let appDelegateObject = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegateObject.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
        let newNote = Note(entity: entity!, insertInto: context)
        newNote.id = noteList.startIndex as NSNumber
        newNote.title = "First Note"
        newNote.descr = "Description first note"
    }
}

