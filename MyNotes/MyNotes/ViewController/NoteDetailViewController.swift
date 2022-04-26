//
//  NoteDetailViewController.swift
//  MyNotes
//
//  Created by ilia nikashov on 04.03.2022.
//

import UIKit
import CoreData

class NoteDetailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var selectedNote: Note? = nil
    
    override func viewDidLoad() {
        
        titleTextField.delegate = self
        
        titleTextField.layer.cornerRadius = 8
        descriptionTextField.layer.cornerRadius = 8
        deleteButton.layer.cornerRadius = 8
        
        saveButton.isEnabled = false
        saveButton.customView?.alpha = 0.1
        
        super.viewDidLoad()
        
        if selectedNote != nil {
            titleTextField.text = selectedNote?.title
            descriptionTextField.text = selectedNote?.descr
        }
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let text = (titleTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if text.isEmpty || text.first == " " {
        saveButton.isEnabled = false
        saveButton.customView?.alpha = 0.1
    } else {
        saveButton.isEnabled = true
        saveButton.customView?.alpha = 1.0
    }
     return true
    }
    
    
    @IBAction func saveActionButton(_ sender: Any) {
        saveButton.isEnabled = titleTextField.text!.count > 0
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        if selectedNote == nil {
            let entity = NSEntityDescription.entity(forEntityName: "Note", in: context)
            let newNote = Note(entity: entity!, insertInto: context)
            newNote.id = noteList.count as NSNumber
            newNote.title = titleTextField.text
            newNote.descr = descriptionTextField.text
            do {
                try context.save()
                noteList.append(newNote)
                navigationController?.popViewController(animated: true)
            } catch {
                print("Save error")
            }
        }
        else {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results {
                    let note = result as! Note
                    if note == selectedNote {
                        note.title = titleTextField.text
                        note.descr = descriptionTextField.text
                        try context.save()
                        navigationController?.popViewController(animated: true)
                    }
                }
            } catch {
                print("Fetch Failed")
            }
        }
    }
    
  
    @IBAction func DeleteNoteButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        do {
            let results:NSArray = try context.fetch(request) as NSArray
            for result in results {
                let note = result as! Note
                if note == selectedNote {
                    note.deletedDate = Date()
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }
            }
        } catch {
            print("Fetch Failed")
        }
    }
    
    
}
