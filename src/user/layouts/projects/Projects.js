import React, { Component } from 'react'
import { connect } from 'react-redux'
import { loadProjects, createProject } from './ProjectsActions'

const loadData = ({loadProjects}) => {
  loadProjects();
};

class ProjectsForm extends Component {
  constructor(props) {
    super(props)

    this.state = {
      name: this.props.name,
      endDate: this.props.endDate,
      revealEndDate: this.props.revealEndDate
    }
  }

  componentDidMount() {
    loadData(this.props);
  }

  handleSubmit(event) {
    event.preventDefault();

    this.props.onProjectFormSubmit("My Project", new Date(1511203271071), new Date(1511203271071));

    //this.props.onProjectFormSubmit(this.state.name, this.state.endDate, this.state.revealEndDate);
  }

  render() {
    return(
      <main className="container">
      <form onSubmit={this.handleSubmit.bind(this)}>
      <fieldset>
        <legend>Create A New Project</legend>
        <div>
          <label>Project Name:</label>
          <input value={this.state.name} type="text" defaultValue="TEST" id="name" />
        </div>
        <div>
          <label>Bidding End Date</label>
          <input value={this.state.endDate} type="date" defaultValue="2018-02-09" id="endDate" />
        </div>
        <div>
            <label>Bidding Reveal End Date</label>
            <input value={this.state.revealEndDate} type="date" defaultValue="2018-02-10" id="revealEndDate" />
        </div>
        <div>
          <button type="submit">Create</button>
        </div>
      </fieldset>
      </form>
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

const mapDispatchToProps = (dispatch) => {
  return {
    onProjectFormSubmit: (name, endDate, revealEndDate) => {
       event.preventDefault();
       dispatch(createProject(name, endDate, revealEndDate));
    },
    loadProjects: loadProjects
  }
}

export default connect(
  mapStateToProps,
  mapDispatchToProps
)(ProjectsForm);

