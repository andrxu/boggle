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

Get a new board:

```
http://ocalhost:3000/boggle/v1/boards/new
```

Sample out:
```json
{"board":"XEASYEUHAENTYEBC"}
```

  Check a word to see if it's on the board and valid:
```
http://localhost:3000/boggle/v1/boards/XEASYEUHAENTYEBC?word=EASY
```

Sample out:
```json
{"board":"XEASYEUHAENTYEBC","word":"XEAS","found_on_board":false,"word_valid":true}
```


