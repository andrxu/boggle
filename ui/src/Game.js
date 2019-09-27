import React from 'react';
import Board from './Board.js';
import {apiHost} from './config'

class Game extends React.Component {
    constructor(props) {
      super(props);
      this.state = {
          board_str: '',
          userInput: '',
          userWords: []
      };
    }

    MAX_WORD_LENGTH = 16;

    startOver = () => {
        // reset board
        // reset user word list
        // reset user input text
        this.requestNewBoard();
        this.setState({
            userInput: '',
            userWords: []
        });
    } 

    componentDidMount = () => {
        this.startOver(); // grab data off server
    }

    checkWord = () => {
        var word = this.state.userInput;
        fetch(apiHost + "/boards/" + this.state.board_str + '?word=' + word).then(response => {
            if (response.status !== 200) {
                throw Error("The server could not process the request.");
            }
            return response.json();
        }).then(data => {
            var userWords = this.state.userWords.slice(0);
            userWords.push({word: word, valid: data.word_valid === null ? 'false': data.word_valid}); 
            this.setState({
                userWords: userWords
            });
            console.log(this.state.userWords);
        }).catch((error) => {
            alert('Please note the server isn\'t responding: ' + error);
        });
    }

    requestNewBoard = () => {
        fetch(apiHost + "/boards/new").then(response => {
            if (response.status !== 200) {
                throw Error("The server could not process the request.");
            }
            return response.json();
        }).then(data => {
            console.log(data);
            this.setState({
                board_str: data.board
            });
        }).catch((error) => {
            alert('Please note the server isn\'t responding');
        });
    }

    onSquareClick = (index) => {
        console.log(this.state.board_str[index] + ' was clicked');
    }

    handleUserInput = (e) => {
        let word = e.target.value.toUpperCase().substring(0, this.MAX_WORD_LENGTH).replace(/[^A-Z]+/g, '');
        this.setState({userInput: word});     
    }
    
    handleKeyDown = (e) => {
        if (e.key === 'Enter') {
            if (typeof(e.targe) !== undefined && e.target.value.length > 0)
                this.checkWord();
        }
    }

    submit = () => {
        if (this.state.userInput.length > 0) {
            this.checkWord();
        }
    }

    render() {

        return (
            <div className="game">
                   
                <div className="">
                    <Board 
                        board_str={this.state.board_str}                   
                        onSquareClick={i => this.onSquareClick(i)}
                    />
                    <div>
                        <ol>{}</ol>
                    </div>
                </div>
                <input type="text" value={this.state.userInput} onChange={this.handleUserInput} onKeyDown={this.handleKeyDown}
                />

                <div className="game-info">
                    <div>{}</div>
                    <button className="button" onClick={() => this.submit()}>
                    Submit
                    </button>
                </div>

                <div className="game-info">
                    <div>{}</div>
                    <button className="button" onClick={() => this.startOver()}>
                    Start Over
                    </button>
                </div>
            </div>
        );
    }
}

export default Game;