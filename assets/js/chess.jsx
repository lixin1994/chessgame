import React from 'react';
import ReactDOM from 'react-dom';
import { Button, ListGroup, ListGroupItem } from 'reactstrap';

export default function chess_init(root, channel) {
    ReactDOM.render(<Chess channel={channel}/>, root);
}

let SYMBOLS =
    {
        "white":
        {
            "king": <span>&#9812;</span>,
            "queen": <span>&#9813;</span>,
            "rook": <span>&#9814;</span>,
            "bishop": <span>&#9815;</span>,
            "knight": <span>&#9816;</span>,
            "pawn": <span>&#9817;</span>
        },
        "black":
        {
            "king": <span>&#9818;</span>,
            "queen": <span>&#9819;</span>,
            "rook": <span>&#9820;</span>,
            "bishop": <span>&#9821;</span>,
            "knight": <span>&#9822;</span>,
            "pawn": <span>&#9823;</span>
        }
    }
class Chess extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            users: {
                black: {
                    name: '',
                    turn: false,
                    isWinner: false,
                    positions: [],
                    clicked: []
                },
                white: {
                    name: '',
                    turn: false,
                    isWinner: false,
                    positions: [],
                    clicked:[]
                }
            },
            currentUser: window.userName,
            observers: []
        }
        this.channel = props.channel;
        this.channel.join()
            .receive("ok", this.gotView.bind(this))
            .receive("error", resp => { console.log("Unable to join", resp) });
        this.channel.on("click", msg => {
            this.gotView(msg)
        });
        this.channel.on("joinGame", msg => {
            this.gotView(msg)
        })
        this.channel.on("games:"+ window.gameName, msg => {
            this.gotView(msg)
        })

    }

    joinGame(){
        this.channel.push("joinGame", {user: window.userName, name: window.gameName})
            .receive("ok", this.gotView.bind(this));

    }
    gotView(view){
        let currThis = this;
        let currState = this.state;
        console.log("game", view.game);
        this.setState({users: view.game.users, observers: view.game.observers})
    }
    initChessBoard(){
        let chessboard = Array(64);
        for(var i = 0; i < 64; i ++){
            var block = {color: "",
                         name: "blank",
                         status: "normal"};
            chessboard[i] = block
        }
        this.state.users.black.positions.forEach(function(item){
            var block = {
                color: "black",
                name: item.name,
                status: "normal"
            };
            chessboard[item.position[0] * 8 + item.position[1]] = block;
        });
        this.state.users.white.positions.forEach(function(item){
            var block = {
                color: "white",
                name: item.name,
                status: "normal"
            };
            chessboard[item.position[0] * 8 + item.position[1]] = block;
        });
        if(this.getCurrentUserColor() && this.state.users[this.getCurrentUserColor()].clicked.length > 0){
            console.log(this.getCurrentUserColor())
            let clicked = this.state.users[this.getCurrentUserColor()].clicked;
            chessboard[clicked[0] * 8 + clicked[1]].status = 'click'
        }
        if(this.getCurrentUserColor() == 'white'){
            chessboard = this.flip(chessboard)
        }
        return chessboard;
    }
    flip(chessboard){
        for(let i = 0; i < 32; i++){
            let temp = chessboard[i];
            chessboard[i] = chessboard[63 - i];
            chessboard[63 - i] = temp;
        }
        return chessboard;
    }
    getCurrentUser(){
        if(this.state.users.black.name == this.state.currentUser){
            return this.state.users.black;
        }
        else if (this.state.users.white.name == this.state.currentUser){
            return this.state.users.white;
        }
        else{
            return null;
        }
    }
    getOppoUser(){
        if(this.state.users.black.name == this.state.currentUser){
            return this.state.users.white;
        }
        else if (this.state.users.white.name == this.state.currentUser){
            return this.state.users.black;
        }
        else{
            return null;
        }
    }

    getCurrentUserColor(){
        if (this.state.users.black.name == this.state.currentUser){
            return 'black';
        }
        if (this.state.users.white.name == this.state.currentUser){
            return 'white';
        }
    }
    getOppoUserColor(){
        if (this.state.users.black.name == this.state.currentUser){
            return 'white';
        }
        if (this.state.users.white.name == this.state.currentUser){
            return 'black';
        }
    }

    select(ii){
        if(this.getCurrentUserColor() == 'white'){
            ii = 63 - ii;
        }
        this.channel.push("click", {user: window.userName, name: window.gameName, ii: ii})
            .receive("ok", this.gotView.bind(this)); console.log(this.getCurrentUser())
    }

    render() {
        let currThis = this;
        let chessboard = this.initChessBoard();
        let tilesList = chessboard.map(function(ele, ii){
            return <Block content={ele} select={currThis.select.bind(currThis)} num={ii} key={ii}/>;
        });
        let observersList = this.state.observers.map(function(ele, ii){
            return <ListGroupItem key={ii}>{ele}</ListGroupItem>

        })
        return (
            <div>
                <Button onClick={currThis.joinGame.bind(currThis)}>Join Game</Button>
                <div className="chessboard">
                    {tilesList}
                </div>
                <ListGroup>
                    {observersList}
                </ListGroup>
            </div>)
    }
}

function Block(props){
    let tile = props.content;
    let blockColor="black"
    if ((Math.floor(props.num/8) + props.num%8)%2 == 0){
        blockColor="white"
    }
    let symble = ''
    if (tile.name != 'blank'){
        symble = SYMBOLS[tile.color][tile.name];
    }
    if (tile.status=='normal'){
        let classes = blockColor + ' block';
        return <div className={classes} onClick={()=>props.select(props.num)}>{symble}</div>;
    }
    else if (tile.status=='click'){
        let classes = blockColor + ' click block';
        return <div className={classes} >{symble}</div>;
    }
}
