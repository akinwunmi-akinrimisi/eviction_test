// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LudoGame {
   
    uint8 public constant maxNumberOfPlayers = 4;       // number of players and their positions
    uint8 public constant totalSpaceOnBoard = 52;       //  board size
    uint8 public currentPlayerIndex = 0;                // To track whose turn it is
    bool public gameStarted = false;
    bool public gameEnded = false;
    
    address[] public players;                           // Array of players
    mapping(address => uint8) public playerPositions;   // Tracking player’s position on the board

  

    // Event to indicate a player rolled the dice and moved
    event DiceRolled(address indexed player, uint8 diceResult, uint8 newPosition);


    // Function for players to register
    function registerPlayer() public {
        require(players.length < maxNumberOfPlayers, "Maximum players reached.");
        require(!gameStarted, "Game has already started.");
        require(playerPositions[msg.sender] == 0, "Player is already registered.");

        players.push(msg.sender);                       // Add player to the list
        playerPositions[msg.sender] = 1;                // Initial position is 1 (starting point)
    }

    // Function to start the game
    function startGame() public {
        require(players.length == maxNumberOfPlayers, "Need 4 players to start.");
        require(!gameStarted, "Game already started.");

        gameStarted = true;
    }

}

