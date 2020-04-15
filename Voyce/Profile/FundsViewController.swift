//
//  TransferFunds.swift
//  Voyce
//
//  Created by Aron Vischjager on 3/29/20.
//  Copyright © 2020 QEDev. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FundsViewController: UIViewController
{
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var accountNumber: UITextField!
    @IBOutlet weak var routingNumber: UITextField!
    // Please don't remove the functions variable
    lazy var functions = Functions.functions()
    
    // Pops view controller off the view controller stack
    func removeViewController()
    {
         navigationController?.popViewController(animated: true)
    }
    
    // Checks if all field have content
    // returns false if any field is empty
    func initAccount() -> DwollaUser?
    {
        guard let firstName = firstName.text else
        {
            return nil
        }
        guard let lastName = lastName.text else
        {
            return nil
        }
        guard let email = email.text else
        {
            return nil
        }
        guard let accountNumber = accountNumber.text else
        {
            return nil
        }
        guard let routingNumber = routingNumber.text else
        {
            return nil
        }
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty || accountNumber.isEmpty || routingNumber.isEmpty
        {
            return nil
        }
        return DwollaUser(firstName, lastName, email, accountNumber, routingNumber)
    }
    
    // Sends user info to Dwolla and transfers funds
    func sendData(user: DwollaUser)
    {
        var dataString = ""
        let amount = Money()
        if userHasFundingSource()
        {
            let fundingSource = getFundingSource()
            dataString = "\(fundingSource), \(amount.getMoney())"
        }
        else
        {
            dataString = "\(user.firstName), \(user.lastName), \(user.email), \(user.accountNumber), \(user.routingNumber), \(amount.getMoney())"
        }
        functions.httpsCallable("addMessage").call(["text": dataString])
        {(result, error) in
            // Handles any errors in the communication
            if let error = error as NSError?
            {
                if error.domain == FunctionsErrorDomain
                {
                    let code = FunctionsErrorCode(rawValue: error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                }
            }
            // Handles the responses from the server
            if let text = (result?.data as? [String: Any])?["text"] as? String
            {
                print("This is the output " + text)
            }
        }
    }
    
    // Returns true if the user already has a funding source
    func userHasFundingSource() -> Bool
    {
        return DatabaseManager.shared.sharedUser.hasFundingSource()
    }
    
    // Returns the funding source string from the user
    func getFundingSource() -> String
    {
        return DatabaseManager.shared.sharedUser.fundingSource
    }
    
    // Updates the funding source string of the user inside the database
    func updateFundingSource(fundingSource: String)
    {
        DatabaseManager.shared.sharedUser.updateFundingSource(fundingSource: fundingSource)
    }
    
    
    
    // Call the methods to transfer funds to bank account
    @IBAction func transferFunds(_ sender: UIButton)
    {
        guard let dwollaUser = initAccount() else
        {
            return
        }
        sendData(user: dwollaUser)
        removeViewController()
    }
    
    // Calls any method when the app loads
    override func viewDidLoad()
    {
        
    }
    
}
