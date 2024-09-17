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
        require(players.length <= maxNumberOfPlayers, "Maximum players reached.");
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

    // Function to check if it's the correct player's turn
    function isPlayerTurn(address player) internal view returns (bool) {
        return players[currentPlayerIndex] == player;
    }


// Function to move player based on dice result
    function movePlayer(uint8 diceResult) internal {
        uint8 currentPosition = playerPositions[msg.sender];
        uint8 newPosition = currentPosition + diceResult;

        // Handle the loop-around logic
        if (newPosition > totalSpaceOnBoard) {
            newPosition = newPosition % totalSpaceOnBoard;
        }

        playerPositions[msg.sender] = newPosition;
    }

    
    // Function to roll the dice
    function rollDice() public {
        require(gameStarted, "Game not started yet.");
        require(!gameEnded, "Game has ended.");
        require(msg.sender == players[currentPlayerIndex], "Not your turn.");

        // Pseudorandom number generation
        uint8 diceResult = uint8(keccak256(abi.encodePacked(block.timestamp, msg.sender, block.difficulty))) % 6 + 1;

        // Move the player
        movePlayer(diceResult);

        // Emit event for the dice roll and new position
        emit DiceRolled(msg.sender, diceResult, playerPositions[msg.sender]);

        // Move to the next player's turn
        currentPlayerIndex = (currentPlayerIndex + 1) % maxNumberOfPlayers;
    }

}

