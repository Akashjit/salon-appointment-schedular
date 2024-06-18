# 💻Project: Number Guessing Game

## Project Goal
Create a number guessing game (Bash script) that runs in the terminal and saves user information.

Project made as part of the <b> FreeCodeCamp Relational Databases Beta Certificate course </b>

## Process

Database was created in PostgreSQL to insert and store user information and game history.

Tables:
- 'Games' - stores game history, including the user_id, the number of guesses inputed before finishing game and the 'secret number'.
- 'Players' - stores usernames (and corresponding user_id) so bash script will recognised new and returning users.

The Bash script runs the game until the 'secret number' is found.

Based on the user input it provides hints to say whether the guess made is lower or higher than the 'secret number'.

The script recognised if the users are new or returning players based on their username and updates the database anytime a new user is detected.

It also stores the game history for both new and returning players, which is updated whenever a new game starts.

--- 
🎮 Can you guess the secret number?

🥳 Give it a go, and have fun!


<div id="img" align="left">
  <img src="https://media.giphy.com/media/3o6Zt7cqmjnCk6VJ0Q/giphy.gif" width="300"/>
  </div>
</div>
