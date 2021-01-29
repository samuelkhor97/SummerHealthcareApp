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
        await models.Food_Diary_Card.create({
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

    const date_obj = new Date(date);

    try{
        const all_cards = await models.Food_Diary_Card.findAll({
            where: {
                uid: uid,
                date: date_obj
            },
            include: [
                {
                    model: models.Food_Data,
                    attributes: ["food_id", "food_name", "calories"],
                    through: {
                        attributes: [],
                    },
                }
            ],
            order: ["card_id"],
        });

        return res.status(200).json(all_cards);
    } catch (error) {
        return res.status(403).send(error);
    }
});


/**
 * POST api: Add a food item to a card
 * url: domain/food-diary/add-food
 */
router.post('/add-food', async (req, res, next) => {
    const uid = res.locals.id;
    const body = req.body;
    const food_id = body.food_id;
    const card_name = body.card_name;
    const date = body.date;
    const date_obj = new Date(date);
    
    try{
        const food_card = await models.Food_Diary_Card.findOne({
            where: {
                uid: uid,
                date: date_obj,
                card_name: card_name
            }
        });

        const card_id = food_card.card_id
        
        await models.Food_Bridge.create({
            card_id: card_id,
            food_id: food_id
        });
        
        return res.status(200).send('Added food item successfully');
    } catch (error) {
        return res.status(403).send(error);
    }
});

module.exports = router;