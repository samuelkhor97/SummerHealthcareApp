let express = require('express');
const {sequelize, models} = require('../models/index');
let router = express.Router();

/**
 * GET api: Get user 
 * url: domain/user/me
 */
router.get('/me', async (req, res, next) => {
  // We could always access uid by res.locals.id, it is  passed from main index.js
  const uid = res.locals.id;

  try {
    const user =  await models.User.findByPk(uid);
    if (user === null) {
      res.status(403).send('User not found.')
    } else {
      // Return user's data
      return  res.status(200).json({
        full_name: user.full_name,
        phone_num: user.phone_num,
        height: user.height,
        age: user.age,
        gender: user.gender,
        ethnicity: user.ethnicity,
        education_status: user.education_status,
        employment_status: user.employment_status,
        occupation: user.occupation,
        marital_status: user.marital_status,
        smoker: user.smoker,
        cigs_per_day: user.cigs_per_day
      });
    }
  } catch (error) {
    res.status(403).send('Error occured while fetching user.')
  }
})

/**
 * POST api: Create user
 * url: domain/user/create
 */
router.post('/create', async (req, res, next) => {
    const uid = res.locals.id;
    const body = req.body;
    
    models.User
      .create({
        uid: uid,
        full_name: body.full_name,
        phone_num: body.phone_num,
        height: body.height,
        age: body.age,
        gender: body.gender,
        ethnicity: body.ethnicity,
        education_status: body.education_status,
        employment_status: body.employment_status,
        occupation: body.occupation,
        marital_status: body.marital_status,
        smoker: body.smoker,
        cigs_per_day: body.cigs_per_day,
        pharmacy_id: body.pharmacy_id
      })
      .then(item => {
        res.status(200).send('Successfully created user!')
      })
      .catch(error => {
        res.status(403).send(`Error: ${error}`)
      })
});

module.exports = router;