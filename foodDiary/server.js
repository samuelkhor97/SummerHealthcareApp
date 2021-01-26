let express = require('express');
const {sequelize, models} = require('../models/index');
let router = express.Router();
const moment = require('moment');
const Op = sequelize.Sequelize.Op;

/**
 * GET api: Get all food info
 * url: domain/food-diary/all
 */
router.get('/all', async (req, res, next) => {
    try{
        const all_foods =  await models.Food_Data.findAll({});
        return res.status(200).json(all_foods);
    } catch (error) {
        return res.status(403).send(error)
    }
});

/**
 * POST api: Create a card
 * url: domain/food-diary/create
 */
router.post('/create-card', async (req, res, next) => {
    const uid = res.locals.id;
    const body = req.body;

    try{
        models.Food_Diary_Card.create({
            uid: uid,
            date: body.date,
            card_name: body.card_name,
            photo_url: "not yet"
        });
        return res.status(200).send('Successfully created a card!');
    } catch (error) {
        return res.status(403).send(error)
    }
});

/**
 * GET api: Get all cards for the user on the data specified
 * url: domain/food-diary/all-cards
 */
router.get('/all-cards', async (req, res, next) => {
    const uid = res.locals.id;
    const date = req.query.date;

    let date_obj = new Date(date);

    try{
        // models.Food_Bridge.create({
        //     card_id: body.card_id,
        //     food_id: body.food_id
        // });
        var card_holder = [];
        const all_cards = await models.Food_Diary_Card.findAll({
            where: {
                uid: uid,
                date: date_obj
            },
            include: [
                {
                    model: models.Food_Data,
                    attributes: ["food_id", "food_name", "calories"],
                    // all: true,
                    through: {
                        attributes: [],
                    },
                }
            ],
            raw: true,
            // group: "card_id",
            order: ["card_id"],
        });
        
        
        console.log(all_cards.length);
        return res.status(200).json(all_cards);
    } catch (error) {
        return res.status(403).send(error)
    }
});



/**1
 * GET api: Get all on-demand request (pending only) (SLI side)
 * url: domain/on-demand/all
 */
router.get('/all_request', async (req, res, next) => {
    const sli_id = res.locals.id;
    
    try {
      
      const result = await models.Booking.findAll({
        where: {
          sli_id: sli_id,
          status: 'pending'
        },
        include: [
          { model: models.User, attributes: [] },
        ],
        raw: true,
        attributes:[
          "booking_id",
          "uid",
          "sli_id",
          "date",
          "time",
          "notes",
          "status",
          "hospital_name",
          [models.Sequelize.col('User.name'), 'user_name'],
          [models.Sequelize.col('User.gender'), 'user_gender'],
          [models.Sequelize.col('User.age'), 'user_age'],
          [models.Sequelize.col('User.profile_pic'), 'user_profile_pic']
        ]
      });
  
      return res.status(200).json(result);
    } catch (error) {
      return res.status(403).send(error)
    }
  });
module.exports = router;