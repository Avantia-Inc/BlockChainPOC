import React, { Component } from 'react'
import ProjectsFormContainer from '../../ui/projectsform/ProjectsFormContainer'

class Profile extends Component {
  render() {
    return(
      <main className="container">
        <div className="pure-g">
          <div className="pure-u-1-1">
            <h1>Projects</h1>
            <p>View your projects here.</p>
            <ProjectsFormContainer />
          </div>
        </div>
      </main>
    )
  }
}

export default Profile