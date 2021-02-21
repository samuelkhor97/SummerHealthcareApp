import React, { useContext } from 'react'

import { makeStyles } from '@material-ui/core/styles'
import Button from '@material-ui/core/Button'
import Tooltip from '@material-ui/core/Tooltip'
import IconMore from '@material-ui/icons/MoreVert'
import IconFilter from '@material-ui/icons/Tune'
import IconDropDown from '@material-ui/icons/ArrowDropDown'
import IconNew from '@material-ui/icons/Add'
import IconDelete  from '@material-ui/icons/Delete'
import TextField from '@material-ui/core/TextField';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';

import dashboardContext from './dashboardContext'
import AddPharmacistDialog from './addPharmacistDialog'

const DashboardActions = () => {
  const classes = useStyles()
  const { filter } = useContext(dashboardContext)
  const [dialogOpen, setDialogOpen] = React.useState(false);

  const dateFilterLabel = filter
    ? `${filter.dateFrom.format('ll')} - ${filter.dateTo.format('ll')}`
    : 'Date Filter'

  return (
    <div>
      <Tooltip title="Date Range">
        <Button>
          {dateFilterLabel} <IconDropDown />
        </Button>
      </Tooltip>
      <Tooltip title="Create new">
        <Button color="secondary" onClick={() => setDialogOpen(true)}>
          <IconNew className={classes.iconNew} />
          New
        </Button>
      </Tooltip>
      <AddPharmacistDialog dialogOpen={dialogOpen} setDialogOpen={setDialogOpen} />
      <Tooltip title="Remove">
        <Button color="secondary">
          <IconDelete className={classes.iconDelete} />
          Remove
        </Button>
      </Tooltip>
      <Tooltip title="Filter">
        <Button color="secondary">
          <IconFilter />
        </Button>
      </Tooltip>
      <Tooltip title="More actions">
        <Button color="secondary">
          <IconMore />
        </Button>
      </Tooltip>
    </div>
  )
}

const useStyles = makeStyles(theme => ({
  iconNew: {
    marginRight: 5,
  },
  iconDelete: {
    marginRight: 5,
  },
}))

export default DashboardActions
