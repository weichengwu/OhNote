//
//  NotesListViewController.swift
//  OhNote
//
//  Created by 吴伟城 on 16/2/16.
//  Copyright © 2016年 Weicheng Wu. All rights reserved.
//

import UIKit

private let identifier = "Cell"

class NotesListViewController: UIViewController {
    
    var notes = [Note]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func newNote() {
        self.performSegueWithIdentifier("toEditorVC", sender: Note())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        notes = Note.all()
        tableView.reloadData()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as! EditorViewController
        destVC.note = sender as? Note
    }

}

// MARK: - table view data source

extension NotesListViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier)!
        let note = notes[indexPath.row]
        let timeLabel = UILabel()
        timeLabel.text = note.time
        timeLabel.font = UIFont.systemFontOfSize(10)
        timeLabel.textColor = UIColor.lightGrayColor()
        timeLabel.sizeToFit()
        cell.accessoryView = timeLabel
        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = note.summary
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
}

// MARK: - table view delegate

extension NotesListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let note = notes[indexPath.row]
        self.performSegueWithIdentifier("toEditorVC", sender: note)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let alertController = UIAlertController(title: "确定删除此条笔记？", message: "", preferredStyle: .Alert)
            let actionCancel = UIAlertAction(title: "取消", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
                // FIXME: Hide 'Delete' button with animation.
            })
            let actionYes = UIAlertAction(title: "确定", style: .Destructive, handler: { (action: UIAlertAction) -> Void in
                let note = self.notes[indexPath.row]
                note.remove()
                self.notes.removeAtIndex(indexPath.row)
                tableView.reloadData()
            })
            alertController.addAction(actionCancel)
            alertController.addAction(actionYes)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}

