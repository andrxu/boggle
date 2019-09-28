# README

This is the ruby based backend RESTful service for the boggle game.

* Ruby version

```
ruby 2.6.3p62 (2019-04-16 revision 67580) [x86_64-darwin18]
Rails 6.0.0
```
* System dependencies

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
$ rails s
```

* Test the service:


1. Get a new board:

```
http://localhost:3000/boggle/v1/boards/new
```

```json
{"board":"XEASYEUHAENTYEBC"}
```

2. Check a word to see if it's on the board and valid:
```
http://localhost:3000/boggle/v1/boards/EASYEUHAENTYEBCX?word=EASY
```

```json
{"board":"EASYEUHAENTYEBCX","word":"EASY","found_on_board":true,"word_valid":true}
```
3. Display a board

```
http://localhost:3000/boggle/v1/boards/EASYEUHAENTYEBCX
```

```
E A S Y 
E U H A 
E N T Y 
E B C X
```




