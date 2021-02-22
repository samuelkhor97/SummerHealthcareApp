let express = require('express');
const { models } = require('../models/index');
let router = express.Router();

const firestore = require('../firebase/firestore');
const firebaseAdmin = require('../firebase/firebase-admin');

/**
 * POST api: Create pharmacy
 * url: domain/admin/createPharmacy
 */
router.post('/createPharmacy', async (req, res, next) => {
    const body = req.body;
    const location = body.location;
    const phoneNumber = body.phoneNumber;
    let uid;

    try {
        const usersRef = firestore.collection('users');
        const snapshot = await usersRef.where('mobileNumber', '==', phoneNumber).get();
        if (snapshot.empty) {
            return res.status(404).send(`Error: User with phone number: ${phoneNumber} not found.`);
        } else {
            // Phone number is unique, hence only one record will be returned
            uid = snapshot.docs[0].data()['id'];
        }
        const userData = snapshot.docs[0].data();
        if (userData['role'] == 'pharmacist') {
            return res.status(400).send(`Error: User is already a pharmacist.`);
        }

        const pharmacyId = await firestore.collection('groups').doc().id;
        await firestore.collection('groups').doc(pharmacyId).set({
            'id': pharmacyId,
            'createdAt': firebaseAdmin.firestore.FieldValue.serverTimestamp(),
            'modifiedAt': firebaseAdmin.firestore.FieldValue.serverTimestamp(),
            'type': 'pharmacy',
            'members': [uid],
        });
        const userRef = snapshot.docs[0].ref;
        await userRef.update({
            'groups': firebaseAdmin.firestore.FieldValue.arrayUnion(pharmacyId),
            'pharmacyGroupId': pharmacyId,
            'role': 'pharmacist'
        });

        await models.Pharmacy.create({
            pharmacy_id: pharmacyId,
            location: location,
            phone_num: phoneNumber,
        });

        await models.User.update({
            pharmacy_id: pharmacyId
        }, {
            where: {
                uid: uid
            }
        });

        return res.status(200).send('Successfully created pharmacy!')
    } catch (error) {
        return res.status(403).send(`Error: ${error}`)
    }
});

module.exports = router;
