# README

This is the ruby based backend RESTful service for the boggle game.

* Ruby version

```
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-darwin18]
Rails 6.0.0
```
* System dependencies

The 3rd party dictionary api:
```
https://www.dictionaryapi.com/api/v3/references/sd3/json/%s?key=
```

* Configuration

* Database creation

* Database initialization

* How to run the test suite

```
$ rails db:migrate RAILS_ENV=test
$ rails db:environment:set RAILS_ENV=test && bundle exec rspec
```

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* Run the service

```
$ rails s -p 3001
```

* Test the service:


1. Get a new board:

```
http://localhost:3001/boggle/v1/boards/new
```

```json
{"board":"XEASYEUHAENTYEBC"}
```

2. Check a word to see if it's on the board and valid:
```
http://localhost:3001/boggle/v1/boards/EASYEUHAENTYEBCX?word=EASY
```

```json
{"board":"EASYEUHAENTYEBCX","word":"EASY","found_on_board":true,"word_valid":true}
```
3. Display a board

```
http://localhost:3001/boggle/v1/boards/EASYEUHAENTYEBCX
```

```
E A S Y 
E U H A 
E N T Y 
E B C X
```

4. Auto solve a board automatically

```
http://localhost:3001/boggle/v1/boards/ABCHIBEOEEZCTXON/words
```

```
["ABE","ABI","BABE","BEE","BEI","BET","BIB","CHE","CHO","COCO","COE","CON","ECHO","ECO","ECON","EXE","EXT","HEE","HOC","TEE","TEX"]
```


