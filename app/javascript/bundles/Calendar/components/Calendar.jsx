import React, { Component } from 'react'
import dateFns from 'date-fns'
import Header from './Header'
import Days from './Days'
import Cells from './Cells'
import axios from 'axios'
import CalendarModal from './CalendarModal'

const csrfHeaders = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN':     ReactOnRails.authenticityToken()
}

class Calendar extends Component {
  state = {
    currentMonth: new Date(),
    currentDate:  new Date(),
    tasks:        {},
    selectedDate: new Date(),
    modalOpen:    false,
    task:         { description: '', due_date: '', errors: [] }
  }

  handleDescriptionChange = event => {
    let { task } = this.state
    task.description = event.target.value
    this.setState({ task })
  }

  handleFormSubmit = event => {
    event.preventDefault()
    let { task, tasks, selectedDate } = this.state
    const formattedDate = dateFns.format(selectedDate, 'YYYY-MM-DD')
    task.due_date = formattedDate
    axios.post('/tasks.json', { task }, { headers: csrfHeaders })
      .then(response => {
        if(tasks[formattedDate]){
          tasks[formattedDate].push(response.data)
        }else{
          tasks[formattedDate] = [response.data]
        }
        this.setState({
          tasks,
          task: { description: '', due_date: '', errors: [] }
        })
      })
      .catch(error => {
        if(error.response.status === 422){
          task.errors = error.response.data.errors
          this.setState({ task })
        }
      })
  }


  fetchTasks = currentMonth => {
    const monthStart  = dateFns.startOfMonth(currentMonth)
    const monthEnd    = dateFns.endOfMonth(monthStart)
    const startDate   = dateFns.format(dateFns.startOfWeek(monthStart), "YYYY-MM-DD")
    const endDate     = dateFns.format(dateFns.endOfWeek(monthEnd), "YYYY-MM-DD")
    axios.get(`/calendar.json?start_date=${startDate}&end_date=${endDate}`)
      .then(response => this.setState({ tasks: response.data, currentMonth }))
  }

  nextMonth = () => {
    const currentMonth = dateFns.addMonths(this.state.currentMonth, 1)
    this.fetchTasks(currentMonth)
  }

  prevMonth = () => {
    const currentMonth = dateFns.subMonths(this.state.currentMonth, 1)
    this.fetchTasks(currentMonth)
  }

  handleDateClick = day => {
    this.setState({ selectedDate: day, modalOpen: true })
  }

  closeModal = () => {
    this.setState({ modalOpen: false })
  }

  render(){
    const { currentMonth, currentDate, tasks,
            selectedDate, modalOpen, task } = this.state
    return(
      <div className="calendar">
        <Header
          currentMonth={currentMonth}
          nextMonth={this.nextMonth}
          prevMonth={this.prevMonth}
        />
        <Days/>
        <Cells
          currentMonth={currentMonth}
          currentDate={currentDate}
          tasks={tasks}
          handleDateClick={this.handleDateClick}
        />
        <CalendarModal
          selectedDate={selectedDate}
          modalOpen={modalOpen}
          closeModal={this.closeModal}
          dailyTasks={ tasks[dateFns.format(selectedDate, 'YYYY-MM-DD')] || [] }
          task={task}
          handleDescriptionChange={this.handleDescriptionChange}
          handleFormSubmit={this.handleFormSubmit}
        />
      </div>
    )
  }

  componentDidMount(){
    const { currentMonth } = this.state
    this.fetchTasks(currentMonth)
  }
}

export default Calendar
