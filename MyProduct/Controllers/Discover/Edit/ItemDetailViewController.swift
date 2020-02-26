//
//  ItemDetailViewController.swift
//  MyProduct
//
//  Created by 王雪慧 on 2020/1/15.
//  Copyright © 2020 王雪慧. All rights reserved.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ detailViewController: ItemDetailViewController)
    func itemDetailViewControllerDidFinish(_ detailViewController: ItemDetailViewController)
}

class ItemDetailViewController: UIViewController {
    
    var saveButton: UIBarButtonItem!
    var cancelButton: UIBarButtonItem!
    
    var detailName: UITextField!
    var detailNotes: UITextView!
    
    var hasChanges: Bool {
        return detailItem!.title != detailName.text! || detailItem!.notes != detailNotes.text!
    }
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    func sendDidCancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    func sendDidFinish() {
        delegate?.itemDetailViewControllerDidFinish(self)
    }
    
    var detailItem: Item? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    // Keyboard support observers.
    private var keyboardShowObserver: NSObjectProtocol!
    private var keyboardHideObserver: NSObjectProtocol!
    
    // Text view change observer.
    private var textDidChangeObserver: NSObjectProtocol!
    
    // MARK: - View Controller Lifecycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Apply these buttons later to be used only when in edit mode.
        cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction(_:)))
        saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveAction(_:)))
        
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(named: "DetailBackgroundColor")
        } else {
            view.backgroundColor = UIColor(red: 0.333, green: 0.333, blue: 0.333, alpha: 1)
        }
        
        detailName = UITextField(frame: .zero)
        detailName.placeholder = "Enter a name"
        detailName.borderStyle = .roundedRect
        detailName.delegate = self
        detailName.backgroundColor = .white
        view.addSubview(detailName)
        
        detailName.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(StatusBarAndNavigationBarHeight() + 10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(34)
        }
        
        detailNotes = UITextView(frame: .zero)
        detailNotes.delegate = self
        detailNotes.backgroundColor = .white
        view.addSubview(detailNotes)
        
        detailNotes.snp.makeConstraints { (make) in
            make.top.equalTo(detailName.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10 - TabbarHeight())
        }
        
        configureView()
    }

    func createSubview() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.enable = false
        
        textDidChangeObserver = NotificationCenter.default.addObserver(
            forName: UITextField.textDidChangeNotification,
            object: detailName,
            queue: OperationQueue.main) { (notification) in
                if let textField = notification.object as? UITextField {
                    if let text = textField.text {
                        self.saveButton!.isEnabled = !text.isEmpty
                    } else {
                        self.saveButton!.isEnabled = false
                    }
                }
        }
        
        keyboardShowObserver =
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification,
                                                   object: nil,
                                                   queue: OperationQueue.main) { [weak self] notification in
                                                    guard let keyboardRect = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey]
                                                        as? NSValue else { return }
                                                    let frameKeyboard = keyboardRect.cgRectValue
                                                    self?.detailNotes.snp.updateConstraints({ (make) in
                                                        make.bottom.equalToSuperview().offset(-10 - frameKeyboard.size.height)
                                                    })
                                                    self?.view.layoutIfNeeded()
        }
        
        keyboardHideObserver =
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                                   object: nil,
                                                   queue: OperationQueue.main) { [weak self] notification in
                                                    self?.detailNotes.snp.updateConstraints({ (make) in
                                                        make.bottom.equalToSuperview().offset(-10 - TabbarHeight())
                                                    })
                                                    self?.view.layoutIfNeeded()
        }
        
        detailName.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        IQKeyboardManager.shared.enable = true
        
        NotificationCenter.default.removeObserver(textDidChangeObserver as Any)
        
        NotificationCenter.default.removeObserver(keyboardShowObserver as Any)
        NotificationCenter.default.removeObserver(keyboardHideObserver as Any)
    }
    
    override func viewWillLayoutSubviews() {
        // If our model has unsaved changes, prevent pull to dismiss and enable the save button
        let hasChanges = self.hasChanges
        
        if #available(iOS 13.0, *) {
            isModalInPresentation = hasChanges
        }
        saveButton.isEnabled = hasChanges
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem,
            let detailName = detailName,
            let detailNotes = detailNotes {
                detailName.text = detail.title
                detailNotes.text = detail.notes
            }
    }

    // MARK: - User Actions
    
    @objc
    func cancelAction(_ sender: Any) {
        endEditState()
        
        if hasChanges {
            confirmCancel(showingSave: false)
        } else {
            sendDidCancel()
        }
    }
    
    @objc
    func saveAction(_ sender: Any) {
        detailItem!.title = detailName.text!
        detailItem!.notes = detailNotes.text!
        
        endEditState()
        
        // Commit this item for save.
        saveItem(detailItem!)
        
        sendDidFinish()
    }
    
    func saveItem(_ item: Item) {
        // Send the notification to the view controller to save this item.
        NotificationCenter.default.post(name: ItemMasterViewController.noteDidChangeNotification, object: item)
    }
    
    // Start editing: save the original title and note, setup the navigation bar.
    func startEditState() {
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    // End editing: exit edit mode and reset navigation bar.
    func endEditState() {
        view.endEditing(true)
    }
    
    // MARK: - Cancellation Confirmation

    func confirmCancel(showingSave: Bool) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Only ask if the user intended to save if they attempted to pull to dismiss, not if they tap Cancel
        if showingSave {
            alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
                self.saveAction(self)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Discard Changes", style: .destructive) { _ in
            self.sendDidCancel()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - UITextFieldDelegate

extension ItemDetailViewController: UITextFieldDelegate {

    // User ended the edit by tapping "Done" in the keyboard.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveAction(self)
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        startEditState()
    }

}

// MARK: - UITextViewDelegate

extension ItemDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        startEditState()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text {
            saveButton!.isEnabled = !text.isEmpty
        } else {
            saveButton!.isEnabled = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        endEditState()
    }
  
}

extension ItemDetailViewController: UIAdaptivePresentationControllerDelegate {
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        confirmCancel(showingSave: true)
    }
    
}


