import React, { Component } from 'react'

class ChangeRequests extends Component {
  render() {
    return(
      <main className="container">
        <div className="pure-g">
          <div className="pure-u-1-1">
            <h1>Projects</h1>
            <p>Create a project here!</p>
            <ProjectFormContainer />
          </div>
        </div>
      </main>
    )
  }
}

export default ChangeRequests
