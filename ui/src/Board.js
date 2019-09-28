import React, {Component} from "react";
import Square from './Square';

import "./Board.css";

class Board extends Component {
    
    constructor(props) {
        super(props);
        this.state = {
        }
    }
    renderBoard = () => {
        const DIM = 4;
        const board = [];
        let index = 0;    
        
        for (let i = 0; i < DIM; i++) {
          const columns = [];
          for (let j = 0; j < DIM; j++) {
            columns.push(this.renderSquare(index++));
          }
          board.push(<div key={i} className="board-row">{columns}</div>);
        } 
        return board;
      }

      renderSquare = (i) => {    
        return (
          <Square key={i} value={this.props.board_str[i]} onClick={() => this.props.onSquareClick(i)} />
        );
      }

    render = () => {
        return ( <div className="board-container">{this.renderBoard()}</div>)   
    }
}

export default Board;