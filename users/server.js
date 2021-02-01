let express = require('express');
const { sequelize, models } = require('../models/index');
let userHelper = require('../helpers/user.js');
let router = express.Router();

/**
 * GET api: Get user 
 * url: domain/user/me
 */
router.get('/me', async (req, res, next) => {
  // We could always access uid by res.locals.id, it is  passed from main index.js
  const uid = res.locals.id;

  try {
    const user = await models.User.findByPk(uid);
    const weight = await models.Weight.findAll({
      limit: 1,
      where: { uid: uid },
      order: [['date', 'DESC']]
    });
    if (user === null) {
      res.status(403).send('User not found.')
    } else {
      // Return user's data
      return res.status(200).json({
        full_name: user.full_name,
        phone_num: user.phone_num,
        height: user.height,
        weight: (weight.length === 0 || weight[0].weight === null) ? null : weight[0].weight,
        dob: user.dob, 
        age: userHelper.getAge(user.dob),
        gender: user.gender,
        ethnicity: user.ethnicity,
        education_status: user.education_status,
        employment_status: user.employment_status,
        occupation: user.occupation,
        marital_status: user.marital_status,
        smoker: user.smoker,
        cigs_per_day: user.cigs_per_day,
        e_cig: user.e_cig,
        body_fat_percentage: user.body_fat_percentage,
        medical_history: user.medical_history,
        medication: user.medication,
        biochemistry: user.biochemistry,
        signup_date: user.signup_date
      });
    }
  } catch (error) {
    res.status(403).send('Error occured while fetching user.')
  }
})

/**
 * GET api: Get user details by id
 * url: domain/user/id
 */
router.get('/id', async (req, res, next) => {
  const uid = req.query.id;

  try {
    const user = await models.User.findByPk(uid);
    const weight = await models.Weight.findAll({
      limit: 1,
      where: { uid: uid },
      order: [['date', 'DESC']]
    });

    if (user === null) {
      res.status(403).send('User not found.')
    } else {
      // Return user's data
      return res.status(200).json({
        full_name: user.full_name,
        phone_num: user.phone_num,
        height: user.height,
        weight: (weight.length === 0 || weight[0].weight === null) ? null : weight[0].weight,
        dob: user.dob,
        age: userHelper.getAge(user.dob),
        gender: user.gender,
        ethnicity: user.ethnicity,
        education_status: user.education_status,
        employment_status: user.employment_status,
        occupation: user.occupation,
        marital_status: user.marital_status,
        smoker: user.smoker,
        e_cig: user.e_cig,
        body_fat_percentage: user.body_fat_percentage,
        cigs_per_day: user.cigs_per_day,
        medical_history: user.medical_history,
        medication: user.medication,
        biochemistry: user.biochemistry,
        signup_date: user.signup_date
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
  try {
    // current timestamp in milliseconds
    let ts = Date.now();
    let date_ob = new Date(ts);

    await models.User.create({
      uid: uid,
      full_name: body.full_name,
      phone_num: body.phone_num,
      height: body.height,
      dob: body.dob,
      gender: body.gender,
      ethnicity: body.ethnicity,
      education_status: body.education_status,
      employment_status: body.employment_status,
      occupation: body.occupation,
      marital_status: body.marital_status,
      smoker: body.smoker,
      cigs_per_day: body.cigs_per_day,
      pharmacy_id: body.pharmacy_id,
      signup_date: date_ob,
      e_cig: body.e_cig,
      medical_history: {},
      medication: [],
      biochemistry: {},
    });

    await models.Weight.create({
      uid: uid,
      date: date_ob,
      weight: body.weight
    });

    return res.status(200).send('Successfully created user!')
  } catch (error) {
    return res.status(403).send(`Error: ${error}`)
  }

});

/**
 * POST api: Update user details by id
 * url: domain/user/update
 */
router.post('/update', async (req, res, next) => {
  const body = req.body;
  const uid = body.id;
  const updateValues = JSON.parse(req.body.updateValues);

  try {
    await models.User.update(updateValues, {
      where: {
        uid: uid
      }
    });

    return res.status(200).send('Successfully updated user!')
  } catch (error) {
    return res.status(403).send(`Error: ${error}`)
  }
});

/**
 * GET api: Find if user exists or not
 * url: domain/user/exists
 */
router.get('/exists', async (req, res, next) => {
  const uid = res.locals.id;

  try {
    // Find entry with uid
    const token = await models.User.findByPk(uid);

    if (token === null) {
      return res.status(200).json({
        exists: false,
      });
    } else {
      return res.status(200).json({
        exists: true,
      });
    }
  } catch (error) {
    return res.status(403).send(`Error: ${error}`);
  }
});

module.exports = router;