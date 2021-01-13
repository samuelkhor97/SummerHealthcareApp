const firebaseAdmin = require('firebase-admin');
const serviceAccount = require('./serviceAccountKey.json');

// Connect to Firebase
firebaseAdmin.initializeApp({
  credential: firebaseAdmin.credential.cert(serviceAccount),
  databaseURL: 'https://summerhealthcareapp.appspot.com/',
});

module.exports = firebaseAdmin;
