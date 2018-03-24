import React from 'react';
import ReactDOM from 'react-dom';
import { Button,Input } from 'reactstrap';

export default function run_main(root) {
    ReactDOM.render(<Main />, root);
}
class Main extends React.Component {
    constructor(props){
        super(props);
    }
    newGame(props) {
        let gameName = $("#name").val();
        let userName = $("#user").val();
        if (!gameName) {
            alert('Please enter game name')
        }
        else if (!userName){
            alert('Please enter user name')
        }
        else {
            window.location = "/game/" + gameName + "/" + userName;
        }
    }
    render(){
        return (
            <div className="row">
                <Input className="col-4" placeholder="gamename" id="name" type="text"/>
                <Input className="col-4" placeholder="username" id="user" type="text"/>
                <Button  onClick={this.newGame.bind(this)}> Go</Button>
            </div>
        )
    }
}
