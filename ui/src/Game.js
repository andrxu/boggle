import React from 'react';
import Board from './Board.js';
import {apiHost} from './config'
import Grid from '@material-ui/core/Grid';
import Typography from '@material-ui/core/Typography';
import Button from '@material-ui/core/Button';
import Input from '@material-ui/core/Input';
import FormControl from '@material-ui/core/FormControl';
import FormHelperText from '@material-ui/core/FormHelperText';

import "./Game.css";

class Game extends React.Component {
    constructor(props) {
      super(props);
      this.state = {
          board_str: '',
          userInput: '',
          userWords: [],
          computerWords: []
      };
    }

    componentDidMount = () => {
        this.handleStartOverClick();
    }

    // Call the backend to check if the word is on the board and valid
    requestWordCheck = () => {
        const word = this.state.userInput;
        if (this.state.userWords.some((w) => w.word === word)) {
            return; // this word has been searched already
        }
        fetch(apiHost + "/boards/" + this.state.board_str + '?word=' + word).then(response => {
            if (response.status !== 200) {
                throw Error("The server could not process the request.");
            }
            return response.json();
        }).then(data => {
            const userWords = this.state.userWords.slice(0);
            const checked_word = {word: word, valid: data.word_valid === null ? false : data.word_valid};
            userWords.push(checked_word); 
            this.setState({
                userInput: checked_word.valid ? '' : word, 
                userWords: userWords
            });
            console.log(this.state.userWords);
        }).catch((error) => {
            alert('Please note the server isn\'t responding: ' + error);
        });
    }

    // Call the backend to solve the board
    requestSolveBoard = () => {
        fetch(apiHost + "/boards/" + this.state.board_str + '/words').then(response => {
            if (response.status !== 200) {
                throw Error("The server could not process the request.");
            }
            return response.json();
        }).then(data => {
            console.log(data);
            this.setState({
                computerWords: data
            });
            console.log(this.state.computerWords);
        }).catch((error) => {
            alert('Please note the server isn\'t responding: ' + error);
        });
    }

    // Call the backend to request a new board
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
            alert('Please note the server isn\'t responding ' + error);
        });
    }

    handleStartOverClick = () => {
        this.requestNewBoard();
        this.setState({
            userInput: '',
            userWords: [],
            computerWords: []
        });
    } 

    handleSolveClick = () => {
        this.requestSolveBoard();
    }

    handleSquareClick = (index) => {
        console.log(this.state.board_str[index] + ' was clicked');
    }

    handleUserInput = (e) => {
        const MAX_WORD_LENGTH = 16;
        const word = e.target.value.toUpperCase().substring(0, MAX_WORD_LENGTH).replace(/[^A-Z]+/g, '');
        this.setState({userInput: word});     
    }
    
    handleKeyDown = (e) => {
        if (e.key === 'Enter') {
            if (typeof(e.targe) !== undefined && e.target.value.length > 0) { 
                this.requestWordCheck(); 
            }
        }
    }

    handleSubmitClick = () => {
        if (this.state.userInput.length > 0) {
            this.requestWordCheck();
        }
    }

    renderComputerWordList = (props) => {
        return (
            <div className='computer-words'>
                <Typography color="textSecondary" variant="caption">
                {props.map((item, index) => (
                    <ul key={index}>{item}</ul>
                ))}   
                </Typography>
            </div>
        )
    }

    renderUserWordList = (props) => {
        // only show valid words
        return (
            <div className='user-words'>
                <Typography color="textSecondary" variant="caption">
                {props.filter(item => item.valid === true).map((item, index) => (
                    <ul key={index}>{item.word}</ul>
                ))}   
                </Typography>
            </div>
        )
    }

    render() {
        return (
            <div>                
                <Grid container>
                    <Grid container> 
                        <Grid item xs={12}>
                            <div className='title'><h2>Boggle Game</h2></div>
                        </Grid>                
                        <Grid item xs={3}></Grid>
                        <Grid item xs={2}>
                            <div className="computer-words-info">
                                <div className="computer-words-title"> 
                                    <Typography color="textSecondary" variant="body2">Words on board:</Typography>
                                </div>
                                {this.renderComputerWordList(this.state.computerWords)}
                            </div>
                        </Grid>
                        <Grid item xs={2}>
                            <div className="board-container">
                                <div className="board">
                                    <Board board_str={this.state.board_str} onSquareClick={i => this.handleSquareClick(i)} />
                                </div>
                                <div className='controls'>
                                    <div className="input-control" >
                                        <FormControl> 
                                            <Input id="input-box" type="text" value={this.state.userInput} onChange={this.handleUserInput} 
                                                onKeyDown={this.handleKeyDown}/>
                                            <FormHelperText id="input-box-helper-text">Type the word you find here</FormHelperText>
                                        </FormControl>
                                        <Button variant="outlined" size="small" color="primary" onClick={() => this.handleSubmitClick()}>
                                            Submit
                                        </Button>
                                    </div>
                                </div>
                                <div className="button-solve" >
                                    <Button variant="outlined" size="small" color="primary" onClick={() => this.handleSolveClick()}>
                                        Solve Me
                                    </Button>
                                </div>
                                <div className="button-start-over" >
                                    <Button variant="outlined" size="small" color="primary" onClick={() => this.handleStartOverClick()}>
                                        Start Over
                                    </Button>
                                </div>
                            </div>
                        </Grid>
                        <Grid item xs={2}>    
                            <div className="user-words-info"> 
                                <div className="user-words-title">  
                                    <Typography color="textSecondary" variant="body2">Words you found:</Typography>
                                </div>
                                {this.renderUserWordList(this.state.userWords)}
                            </div>
                        </Grid>
                        <Grid item xs={3}></Grid>
                    </Grid>
                </Grid>
            </div>
        );
    }
}

export default Game;
