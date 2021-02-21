import React, { useState } from 'react';
import Button from '@material-ui/core/Button';
import TextField from '@material-ui/core/TextField';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import Snackbar from '@material-ui/core/Snackbar';
import MuiAlert from '@material-ui/lab/Alert';
import axios from "axios";

function Alert(props) {
  return <MuiAlert elevation={6} variant="filled" {...props} />;
}

export default function AddPharmacistDialog({ dialogOpen, setDialogOpen }) {
  const [phoneNumber, setPhoneNumber] = useState('');
  const [location, setLocation] = useState('');
  const [showAlert, setShowAlert] = useState(false);
  // refer to https://material-ui.com/components/snackbars/ for severity options
  const [severity, setSeverity] = useState('success');
  const [msg, setMsg] = useState('');

  const handleClose = () => {
    setDialogOpen(false);
  };

  const handleAdd = async () => {
    try {
      let responseMsg = await createPharmacy();
      setMsg(responseMsg);
      setSeverity('success');
      setShowAlert(true);
    } catch (error) {
      setMsg(error.message);
      setSeverity('error');
      setShowAlert(true);
    }
  };

  async function createPharmacy() {
    let responseMsg = await axios.post(process.env.REACT_APP_BACKEND_URL + '/admin/createPharmacy',
      {
        phoneNumber: phoneNumber,
        location: location
      },
      { headers: { Authorization: 'adminpharmacist' } }
    ).then(response => response.data
    ).catch((error) => {
      throw Error(error.response.data);
    });

    return responseMsg;
  }

  return (
    <Dialog open={dialogOpen} onClose={handleClose} aria-labelledby="form-dialog-title">
      <DialogTitle id="form-dialog-title">Create Pharmacy</DialogTitle>
      <DialogContent>
        <DialogContentText>
          Please enter the Pharmacy's corresponding details.
          </DialogContentText>
        <TextField
          autoFocus
          margin="dense"
          id="phone"
          label="Phone Number"
          type="text"
          onChange={(e) => setPhoneNumber(e.target.value)}
          fullWidth
        />
        <TextField
          margin="dense"
          id="location"
          label="Pharmacy Location"
          type="text"
          onChange={(e) => setLocation(e.target.value)}
          fullWidth
        />
      </DialogContent>
      <DialogActions>
        <Button onClick={handleClose} color="primary">
          Cancel
          </Button>
        <Button onClick={handleAdd} color="primary">
          Add
          </Button>
      </DialogActions>
      <Snackbar open={showAlert} autoHideDuration={6000} onClose={() => setShowAlert(false)}>
        <Alert onClose={() => setShowAlert(false)} severity={severity}>
          {msg}
        </Alert>
      </Snackbar>
    </Dialog>
  );
}