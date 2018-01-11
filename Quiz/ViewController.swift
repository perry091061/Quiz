//
//  ViewController.swift
//  Quiz
//
//  Created by Perry Davies on 25/09/2017.
//  Copyright © 2017 Perry Davies. All rights reserved.
//

import UIKit

class ViewController: UIViewController, completed {
    @IBOutlet weak var txtPlayer1:  UITextField!
    @IBOutlet weak var txtPlayer2:  UITextField!
    @IBOutlet weak var lblScore:    UILabel!
    @IBOutlet weak var tableView:   UITableView!
    
    
    var currentScore = 0
    var player1:Int?         // First player selected
    var player2:Int?         // Second player selected
    var players = [Player]() // Collection of NBA players
    
    let color = [UIColor.green,UIColor.red] // textfield editable indicators
    
    @IBAction func selectPressed(_ sender: UIButton)
    {
        processSelection(id: sender.tag)
    }
    
    @IBAction func cancelText(_ sender: UIButton)
    {
        processCancel(id: sender.tag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPlayer1.isEnabled = false
        txtPlayer2.isEnabled = false
        let network = NetworkApi.sharedInstance
        network.delegate = self
        network.fetchPlayersData()
        // Catch notification for player images to be updated
        NotificationCenter.default.addObserver(self, selector: #selector( ViewController.playerUpdate), name: Notification.Name("Refresh"), object: nil)
    }
    
    @objc func playerUpdate(notification: Notification)
    {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func complete() {
        players = NetworkApi.sharedInstance.players
        tableView.reloadData()
    }
    
    func displayMessage(title:String,msg:String,type:Int)
    {
        var buttonTitle = ["Ok","Cancel"]
        let style: UIAlertActionStyle = .default
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle[type], style: style, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // Process player selection
    
    func processCancel(id: Int)
    {
    switch id
    {
    case 0:txtPlayer1.text = ""
    case 1:txtPlayer2.text = ""
    default :break
    }
    selectPlayers(txtPlayerFieldA: txtPlayer2, txtPlayerFieldB: txtPlayer1)
    }
    
    func processSelection(id:Int)
    {
        guard player1 != nil && player2 != nil
            else { return }
        
        if currentScore + 1 > 10
        {
            displayMessage(title: "Max Score", msg: "Well done try again!",type: 0)
            resetScore()
        }
        switch id
        {
        case 0:
            if (players[player1!].fppg > players[player2!].fppg)
            {
                displayMessage(title: "Correct", msg: "Well done!", type: 0)
                updateScore()
            }
            else
            {
                displayMessage(title: "Incorrect", msg: "Try again!", type: 0)
            }
        case 1:
            if (players[player1!].fppg < players[player2!].fppg)
            {
                displayMessage(title: "Correct", msg: "Well done!", type: 0)
                updateScore()
            }
            else
            {
                displayMessage(title: "Incorrect", msg: "Try again!", type: 0)
            }
        default: break
        }
        clearPlayers()
    }
    
    func updateScore()
    {
        currentScore += 1
        lblScore.text = "\(currentScore)"
    }
    
    func resetScore()
    {
        currentScore = 0
        lblScore.text = "00"
        clearPlayers()
    }
    func clearPlayers()
    {
        txtPlayer1.text = ""
        txtPlayer2.text = ""
        player1 = nil
        player2 = nil
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let firstName = players[indexPath.row].first_Name,
              let lastName  = players[indexPath.row].last_Name
            else
        {
            txtPlayer1.text = ""
            return
        }
        
        let name = firstName + ", " + lastName
        
        if ((txtPlayer1.text?.isEmpty)! || (txtPlayer1.backgroundColor == color[1]))
        {
            player1 = indexPath.row  // first player selected
            txtPlayer1.text = name
            selectPlayers(txtPlayerFieldA: txtPlayer1, txtPlayerFieldB: txtPlayer2)
        }
        else if ((txtPlayer2.text?.isEmpty)! || (txtPlayer2.backgroundColor == color[1]))
        {
            player2 = indexPath.row  // second player selected
            txtPlayer2.text = name
            selectPlayers(txtPlayerFieldA: txtPlayer2, txtPlayerFieldB: txtPlayer1)
        }
        
    }
    
    func selectPlayers(txtPlayerFieldA: UITextField,txtPlayerFieldB: UITextField)
    {
        
        txtPlayerFieldA.backgroundColor = color[0]
        txtPlayerFieldB.backgroundColor = color[1]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        //cell.selectionStyle = .default
        if let cell = cell.configPlayer(player: players[indexPath.row])
        {
            return cell
        }
        return TableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
}
