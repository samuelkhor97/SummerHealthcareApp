let express = require('express');
const {sequelize, models} = require('../models/index');
let router = express.Router();

/**
 * POST api: Create weight entry
 * url: domain/weight/add
 */
router.post('/add', async (req, res, next) => {
    const body = req.body;
    const uid = body.uid;

    try {
      models.Weight
      .create({
        uid: uid,
        date: body.date,
        weight: body.weight
      });
      
      return res.status(200).send('Successfully added weight entry!');
    } catch (error){
      return res.status(403).send(`Error: ${error}`);
    }
 
});

/**
 * GET api: Create weight entry
 * url: domain/weight/all
 */
router.get('/all', async (req, res, next) => {
    const uid = req.query.uid;

    try{
        const all_weights =  await models.Weight.findAll({
            where: {
                uid: uid
            }
        });
        return res.status(200).json(all_weights);
    } catch (error) {
        return res.status(403).send(error)
    }  
});

router.post('/edit', async (req, res, next) => {
  const body = req.body;
  const uid = body.uid;

  try {
    // retrieve weight record chosen
    const weight = await models.Weight.findOne({
      where: {
        uid: uid,
        date: body.date,
        weight: body.old_weight
      }
    });

    // Update weight record if it is found and then save
    if (weight){
      weight.set('weight', body.new_weight);
      await weight.save();
    }
    else {
      return res.status(404).send('Weight record not valid')
    }
  
    return res.status(200).send('Successfully updated weight.')
  } catch (error) {
    return res.status(403).send(error);
  }
});

module.exports = router;