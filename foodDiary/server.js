let express = require('express');
const {sequelize, models} = require('../models/index');
let router = express.Router();

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

// /**
//  * POST api: Create a card
//  * url: domain/food-diary/create
//  */
// router.post('/create', async (req, res, next) => {
//     const uid = res.locals.id;
//     const body = req.body;

//     try{
        
//         return res.status(200).json(all_foods);
//     } catch (error) {
//         return res.status(403).send(error)
//     }
// });


module.exports = router;