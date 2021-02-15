const firebaseAdmin = require('./firebase-admin');

const bucket = firebaseAdmin.storage().bucket();

module.exports = bucket;