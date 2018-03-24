import React from 'react';
import ReactDOM from 'react-dom';
import { Button } from 'reactstrap';

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
            currentUser: "user1",
            observers: []
        }
        this.channel = props.channel;
        this.channel.join()
            .receive("ok", this.gotView.bind(this))
            .receive("error", resp => { console.log("Unable to join", resp) });

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
        if(this.state.users.black.clicked.length > 0){
            let clicked = this.state.users.black.clicked;
            chessboard[clicked[0] * 8 + clicked[1]].status = 'click'
        }
        console.log(chessboard)
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
    isSymbol(){
        let curr = this.getCurrentUser();
        for(let i =0; i < curr.positions.length; i ++){
            let p = curr.positions[i];
            if (curr.clicked[0] == p.position[0] && curr.clicked[1] == p.position[1]){
                return true;
            }
        }
        return false;
    }
    attack(ii){
        let futurePosition = [Math.floor(ii/8), ii%8];
        console.log(futurePosition);
        let oppo = this.getOppoUser();
        console.log(oppo)
        for(let i =0; i < oppo.positions.length; i ++){
            let p = oppo.positions[i];

            if (p.position[0] == futurePosition[0] && p.position[1] == futurePosition[1]){
                console.log(p)
                oppo.positions.splice(i, 1);
            }
        }
        console.log('oppo')
        console.log(oppo)
        return oppo;
    }

    setSymbol(ii){
        let curr = this.getCurrentUser();
        curr.positions.forEach(function(element) {
            if (curr.clicked[0] == element.position[0] && curr.clicked[1] == element.position[1]){
                element.position = [Math.floor(ii/8),ii%8];
            }
        });
        curr.clicked = []
        return curr;

    }

    select(ii){
        console.log(this.getCurrentUser())
        if(!this.getCurrentUser()){
            return;
        }
        let newUsers = this.state.users;
        let pastClick = this.getCurrentUser().clicked
        console.log(pastClick.length > 0)
        console.log(this.isSymbol())
        if (pastClick.length > 0 && this.isSymbol()){
            console.log('in')
            newUsers[this.getCurrentUserColor()] = this.setSymbol(ii)
            newUsers[this.getOppoUserColor()] = this.attack(ii)
        }
        else{
            newUsers[this.getCurrentUserColor()].clicked = [Math.floor(ii/8),ii%8]
        }
        this.setState({users: newUsers});
    }

    render() {
        let currThis = this;
        let chessboard = this.initChessBoard();
        let tilesList = chessboard.map(function(ele, ii){
            return <Block content={ele} select={currThis.select.bind(currThis)} num={ii} key={ii}/>;
        });
        return (<div className="chessboard">
            {tilesList}
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

