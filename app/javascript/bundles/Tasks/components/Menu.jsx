import React from 'react'

const Menu = props => (
  <p style={{minHeight: 30}}>
    <span
      className={`badge badge-danger mr-1 badge-clickable ${props.due === "past_due" ? "badge-lg" : "badge-sm"}`}
      onClick={ () => { props.handleDueClick("past_due") } }
      id="menu-past-due"
    >
      Past Due
    </span>
    <span
      className={`badge badge-warning mr-1 badge-clickable ${props.due === "due_soon" ? "badge-lg" : "badge-sm"}`}
      onClick={ () => { props.handleDueClick("due_soon") } }
      id="menu-due-soon"
    >
      Due Soon
    </span>
    <span
      className={`badge badge-success mr-1 badge-clickable ${props.due === "due_later" ? "badge-lg" : "badge-sm"}`}
      onClick={ () => { props.handleDueClick("due_later") } }
      id="menu-due-later"
    >
      Due Later
    </span>
    <span
      className={`badge badge-secondary badge-clickable ${props.due === "not_due" ? "badge-lg" : "badge-sm"}`}
      onClick={ () => { props.handleDueClick("not_due") } }
      id="menu-not-due"
    >
      Not Due
    </span>
  </p>
)

export default Menu
