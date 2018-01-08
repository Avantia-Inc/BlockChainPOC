import { connect } from 'react-redux'
import ProjectsForm from './ProjectsForm'
import { createProject } from './ProjectsFormActions'

const mapStateToProps = (state, ownProps) => {
  return {
    name: state.user.data.name,
    projects: state.myProjects.projects
  }
}

const mapDispatchToProps = (dispatch) => {
  return {
    onProjectFormSubmit: (name) => {
      event.preventDefault();

      dispatch(createProject(name))
    }
  }
}

const ProjectsFormContainer = connect(
  mapStateToProps,
  mapDispatchToProps
)(ProjectsForm)

export default ProjectsFormContainer
