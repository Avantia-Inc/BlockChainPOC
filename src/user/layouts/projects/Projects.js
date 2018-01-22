import React, { Component } from 'react'
import { connect } from 'react-redux'
import { loadProjects } from './ProjectsActions'

const loadData = ({loadProjects}) => {
  loadProjects();
};

class ProjectsForm extends Component {
  constructor(props) {
    super(props)

    //this.state = {
      //name: this.props.name
    //}
  }

  componentDidMount() {
    loadData(this.props);
  }

  render() {
    return(
      <main className="container">
      <div className="pure-g">
        <div className="pure-u-1-1">
          <table>
          <tbody>
          {this.props.projects.map((project, i) =>
            <tr key={i}>
              <td>{project.name}</td>
            </tr>
          )}
          </tbody>
        </table>
        </div>
      </div>
    </main>
    )
  }
}

const mapStateToProps = (state, ownProps) => {
  return {
    projects: state.projects.projects
  }
}

export default connect(
  mapStateToProps,
  {
    loadProjects
  }
)(ProjectsForm);

