import React, { Component } from 'react'
import store from '../../../store'
import ProjectRepositoryContract from '../../../../build/contracts/ProjectRepository.json'

const contract = require('truffle-contract')

class ProjectsForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      name: this.props.name
    }

    this.loadProjects();
  }

  onInputChange(event) {
    this.setState({ name: event.target.value })
  }

  handleSubmit(event) {
    event.preventDefault()

    if (this.state.name.length < 2)
    {
      return alert('Please fill in your name.')
    }

    this.props.onProjectFormSubmit(this.state.name);
    //this.props.onProfileFormSubmit(this.state.name)
  }

  loadProjects() {
    let web3 = store.getState().web3.web3Instance
    
      // Double-check web3's status.
      if (typeof web3 !== 'undefined') {
    
        //return function(dispatch) {
          // Using truffle-contract we create the authentication object.
          const projectsRepo = contract(ProjectRepositoryContract)
          projectsRepo.setProvider(web3.currentProvider)
    
          // Declaring this for later so we can chain functions on Authentication.
          var projectRepoInstance
    
          // Get current ethereum wallet.
          web3.eth.getCoinbase((error, coinbase) => {
            // Log errors, if any.
            if (error) {
              console.error(error);
            }
    
            projectsRepo.deployed().then(function(instance) {
              projectRepoInstance = instance
    
              // Attempt to sign up user.
              projectRepoInstance.myProjects({from: coinbase})
              .then(function(result) {
                debugger;
                alert(result.length);
                // If no error, login user.
                //return dispatch(loginUser())
              })
              .catch(function(result) {
                debugger;
                // If error...
              })
            })
          })
        //}
      } else {
        console.error('Web3 is not initialized.');
      }
  }

  render() {
    return(
      <div>
      <table>
        <thead>
          <tr>
            <th>Project Name</th>
            <th>Bidding End</th>
            <th>Bidding Reveal</th>
            <th># Bids</th>
            <th>Status</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>My First Project</td>
            <td>12/15/2017 1:00 PM EST</td>
            <td>12/15/2016 5:00 PM EST</td>
            <td>2</td>
            <td>Open</td>
            <td><button>TEST</button></td>
          </tr>
        </tbody>
      </table>
      <form className="pure-form pure-form-stacked" onSubmit={this.handleSubmit.bind(this)}>
        <fieldset>
          <label htmlFor="name">Name</label>
          <input id="name" type="text" placeholder="Project Name" />
          <span className="pure-form-message">This is a required field.</span>
          <br />
          <button type="submit" className="pure-button pure-button-primary">Create</button>
        </fieldset>
      </form>
      </div>
    )
  }
}

export default ProjectsForm
