import React, { Component } from 'react'
import store from '../../../store'
import ProjectRepositoryContract from '../../../../build/contracts/ProjectRepository.json'

const contract = require('truffle-contract')

export const LOAD_PROJECTS = 'LOAD_PROJECTS'
function buildProjectsTable(projects) {
  return {
    type: LOAD_PROJECTS,
    projects: projects
  }
}

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
    let web3 = store.getState().web3.web3Instance;
    
      // Double-check web3's status.
      if (typeof web3 !== 'undefined') {
    
        return function(dispatch) {
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
                 dispatch(buildProjectsTable(result))
                // If no error, login user.
                //return dispatch(loginUser())
              })
              .catch(function(result) {
                debugger;
                // If error...
              })
            })
          })
        }
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
        {this.props.projects.map((row, i) =>
          <tr key={i}>
            {row.map((col, j) =>
              <td>GOT SOMETHING</td>
            )}
          </tr>
        )}
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
