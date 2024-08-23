# Snake Game

I built the classic "Snake Game" using Flutter. Check it out here: https://snakegame-a1bc3.web.app/

The goal of the game is to grow the snake by making it eat the green fruit. You can move the snake by using the arrow keys on keyboard or by swiping if you're on your phone. 

As you grow the snake, you'll score points. If the snake bumps into itself, you lose the game. On the right, you can see your scores as well as other players' scores.

![Snake Game Picture](https://github.com/Samaara-Das/Snake-Game/blob/version2/assets/snakegame.png)

This project was inspired by and based on a tutorial by Mitch Koko. I followed the tutorial and then expanded upon it with my own modifications and additions. My personal contributions include:
- making the highscores visually appealing and responsive
- asking for the player's name once at the start of the game

## Note for developer
As soon as the game starts they give their name in the popup that is displayed. Then, they see the highscores re-load and see the top players. The player hasn't scored anything yet. So, their name won't be displayed in the highscores list. After their 1st game, if the player has scored better than the worst player in the highscores list, their name and score should be displayed in the highscores list. Currently, that isn't happening. This needs to be fixed.
