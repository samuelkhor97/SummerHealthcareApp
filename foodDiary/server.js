let express = require('express');
const {sequelize, models} = require('../models/index');
let router = express.Router();

// imports for photo uploading
const bucket = require('../firebase/storage');
const formidable = require('formidable');
const shortId = require('shortid');

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

router.post('/food_pic', async (req, res) => {
    const uid = res.locals.id;
    const food_id = req.query.food_id;
    const card_name = req.query.card_name;
    const date = req.query.date;
    const date_obj = new Date(date);

    const form = formidable();

    // Event listeners for form.parse() below
    // Add file extension to file path explicitly
    form.on('fileBegin', (filename, file) => {
        file.path = file.path + '.' + file.type.split('/').pop();
    });

    form.parse(req, async (error, fields, files) => {
        if (error) {
            return res.status(403).send(error.message);
        }

        try { 
        const food_card = await models.Food_Diary_Card.findOne({
            where: {
                uid: uid,
                date: date_obj,
                card_name: card_name
            }
        });

        const card_id = food_card.card_id
    
        // Generate file name
        const generatedFileName = `profile${shortId.generate()}.${files.image.name.split('.').pop()}`;

        // Store image into Google Cloud Storage
        await bucket.upload(files.image.path, {
            gzip: true,
            destination: generatedFileName,
        });

        // Update uri in db
        await models.Food_Bridge.update(
            {
                photo_url: generatedFileName,
            },
            {
                where: {
                    food_id: food_id,
                    card_id: card_id
                },
            }
        );

        return res.status(200).send('Food image successfully uploaded.');
        } catch (error) {
            return res.status(403).send(error.message);
        }
    });
});

router.get('/attachment', async (req, res) => {
    const filename = req.query.filename;

    try {
        let stream = bucket.file(filename).createReadStream();

        stream.on('data', function (data) {
            res.write(data);
        });
    
        stream.on('error', function (err) {
            return res.status(403).send(err.message);
        });
    
        stream.on('end', function () {
            res.end();
        });
    } catch (error) {
        return res.status(403).send(error.message);
    }
});
module.exports = router;