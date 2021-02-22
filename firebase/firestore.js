const firebaseAdmin = require('./firebase-admin');

const firestore = firebaseAdmin.firestore();

module.exports = firestore;