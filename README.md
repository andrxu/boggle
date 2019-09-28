# Boggle Game

## How to run it

### Start the backend

* cd folder: service/boogle-api/
* review any setup steps in README.md
* run rails on port 3001

```bash
 rails s -p 3001
```

#### Backend interface

```
http://localhost:3001/boggle/v1/boards/new

{"board":"XEASYEUHAENTYEBC"}
```

```
http://localhost:3001/boggle/v1/boards/EASYEUHAENTYEBCX?word=EASY
{"board":"EASYEUHAENTYEBCX","word":"EASY","found_on_board":true,"word_valid":true}
```


```
http://localhost:3001/boggle/v1/boards/EASYEUHAENTYEBCX

E A S Y
E U H A
E N T Y
E B C X
```


### Start the frontend

* cd folder: ui
* review any setup steps in README.md
* run ReactJs

```bash
npm start
```

## TODOs

* Improve responsive UI, and accessiblity
* Support clicking letters
* Visually indicating the current word path on the board
* Front-end should directly verify if a word is on board
* Add a button to slove the board automatically
  * the backend will require a local dictionary instead of calling a service for each guess
  * the backend will need to implement a trie with statistics on each layer to support quick lookup and DFS pruning
* Better stategy to generate a board with more words
* Backend could pre-generate and store boards
* Allow saving the game
  
