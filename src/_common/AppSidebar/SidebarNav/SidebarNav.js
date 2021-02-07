import React from 'react'
import { makeStyles, createStyles } from '@material-ui/core/styles'
import List from '@material-ui/core/List'
import ListSubheader from '@material-ui/core/ListSubheader'

import IconDashboard from '@material-ui/icons/Dashboard'
import IconSettings from '@material-ui/icons/Settings'
import IconPreson from '@material-ui/icons/Person'

import NavList from './NavList'

const SidebarNav = props => {
  const { isCollapsed } = props
  const classes = useStyles()

  const itemsCore = [
    {
      name: 'Dashboard',
      link: '/',
      Icon: IconDashboard,
    },
    {
      name: 'Auth',
      Icon: IconPreson,
      items: [
        {
          name: 'Login',
          link: '/auth/login',
        },
      ],
    },
    {
      name: 'Settings',
      link: '/settings',
      Icon: IconSettings,
    },
  ]

  return (
    <div>
      <List className={classes.navList} disablePadding>
        <ListSubheader disableSticky={true} className={classes.navListHeader}>
          Core Modules
        </ListSubheader>
        <NavList isCollapsed={isCollapsed} items={itemsCore} />
      </List>
    </div>
  )
}

const useStyles = makeStyles(theme =>
  createStyles({
    navList: {
      width: theme.sidebar.width,
      fontSize: '1.1em',
      fontWeight: 400,
      lineHeight: 1.5,
      letterSpacing: '0.00938em',
    },
    navListHeader: {
      textAlign: 'center',
      color: 'rgba(255,255,255,0.5)',
    },
    iconFeatures: {
      color: '#95de3c',
    },
    iconDocs: {
      color: '#f8cda9',
    },
    iconSupporters: {
      color: '#e3b546',
    },
    iconDiscuss: {
      color: '#ccc',
    },
  }),
)

export default SidebarNav
