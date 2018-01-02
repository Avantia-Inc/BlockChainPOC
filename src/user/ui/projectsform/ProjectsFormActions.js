import AuthenticationContract from '../../../../build/contracts/Authentication.json'
import ProjectRepositoryContract from '../../../../build/contracts/ProjectRepository.json'
import ProjectContract from '../../../../build/contracts/Project.json'
import store from '../../../store'
import BigNumber from 'bignumber.js/bignumber'

const contract = require('truffle-contract')

export const USER_UPDATED = 'USER_UPDATED'
function userUpdated(user) {
  return {
    type: USER_UPDATED,
    payload: user
  }
}

export function updateUser(name) {
  let web3 = store.getState().web3.web3Instance
  
    // Double-check web3's status.
    if (typeof web3 !== 'undefined') {
  
      return function(dispatch) {
        // Using truffle-contract we create the authentication object.
        const authentication = contract(AuthenticationContract)
        authentication.setProvider(web3.currentProvider)
  
        // Declaring this for later so we can chain functions on Authentication.
        var authenticationInstance
  
        // Get current ethereum wallet.
        web3.eth.getCoinbase((error, coinbase) => {
          // Log errors, if any.
          if (error) {
            console.error(error);
          }
  
          authentication.deployed().then(function(instance) {
            authenticationInstance = instance
  
            // Attempt to login user.
            authenticationInstance.update(name, {from: coinbase})
            .then(function(result) {
              // If no error, update user.
  
              dispatch(userUpdated({"name": name}))
  
              return alert('Name updated!')
            })
            .catch(function(result) {
              // If error...
            })
          })
        })
      }
    } else {
      console.error('Web3 is not initialized.');
    }
}

export function createProject(name) {
  let web3 = store.getState().web3.web3Instance
debugger;
  // Double-check web3's status.
  if (typeof web3 !== 'undefined') {

    return function(dispatch) {
      // Using truffle-contract we create the authentication object.
      const projectRepo = contract(ProjectRepositoryContract);
      const project = contract(ProjectContract);
      
      projectRepo.setProvider(web3.currentProvider);
      project.setProvider(web3.currentProvider);

      // Declaring this for later so we can chain functions on Authentication.
      var projectRepoInstance

      // Get current ethereum wallet.
      web3.eth.getCoinbase((error, coinbase) => {
        // Log errors, if any.
        if (error) {
          console.error(error);
        }

        project.new(name, 1511203271071, 1511203271071, { from: coinbase, gas: 2000000 }).then(function(myProject) {
          projectRepo.deployed().then(function(instance) {
            projectRepoInstance = instance
  
            // Attempt to create project.
            projectRepoInstance.createNewProject(myProject.address, {from: coinbase })
            .then(function() {
              // If no error, update user.
              debugger;
              //dispatch(userUpdated({"name": name}))
  
              return alert('Project created!')
            })
            .catch(function(result) {
              debugger;
              // If error...
            })
          })
        });
      })
    }
  } else {
    console.error('Web3 is not initialized.');
  }
}
