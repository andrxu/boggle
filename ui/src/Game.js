import React from 'react';
import Board from './Board.js';
import {apiHost} from './config'
import Grid from '@material-ui/core/Grid';
import Divider from '@material-ui/core/Divider';
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
          userWords: []
      };
    }

    componentDidMount = () => {
        this.startOver();
    }

    startOver = () => {
        this.requestNewBoard();
        this.setState({
            userInput: '',
            userWords: []
        });
    } 

    // Call the backend to check if the word is on the board and valid
    checkWord = () => {
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
                this.checkWord(); 
            }
        }
    }

    submit = () => {
        if (this.state.userInput.length > 0) {
            this.checkWord();
        }
    }

    renderWordList = (props) => {
        // only show valid words
        return (
            <div className='user-words'>
                {props.userWords.filter(item => item.valid === true).map((item, index) => (
                    <div key={index}>
                        <ul key={index}>
                            <Typography color="textSecondary" variant="caption">
                                {item.word}
                            </Typography>
                        </ul>
                    </div>
                ))}   
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
                        <Grid item xs={4}></Grid>
                        <Grid item xs={4}>
                                <Board board_str={this.state.board_str} onSquareClick={i => this.handleSquareClick(i)} />
                                <div className='controls'>
                                    <Divider variant="middle" component="ul"/>
                                    <div className="extra-space"/>
                                    <div style={{float: 'left'}} className="input-control" >
                                        <FormControl> 
                                            <Input id="input-box" type="text" value={this.state.userInput} onChange={this.handleUserInput} 
                                                onKeyDown={this.handleKeyDown}/>
                                            <FormHelperText id="input-box-helper-text">Type the word you find here</FormHelperText>
                                        </FormControl>
                                        <Button variant="outlined" size="small" color="primary" onClick={() => this.submit()}>
                                            Submit
                                        </Button>
                                    </div>
                                    <div className="extra-space"/>
                                    <div style={{float: 'right'}} >
                                        <Button variant="outlined" size="small" color="primary" onClick={() => this.startOver()}>
                                            Start Over
                                        </Button>
                                    </div>
                                </div>
                        </Grid>
                        <Grid item xs={4}>    
                            <div> 
                                <div> 
                                    <Typography color="textSecondary" variant="body2">Words found:</Typography>
                                </div>
                                {this.renderWordList(this.state)}
                            </div>
                        </Grid>
                    </Grid>
                </Grid>
            </div>
        );
    }
}

export default Game;
