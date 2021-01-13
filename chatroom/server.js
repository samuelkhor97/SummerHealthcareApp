let express = require('express');

let router = express.Router();

router.get('/pingChat', validateUser, pingChat);

function validateUser(req, res, next) {
    if (['127.0.0.1', 'localhost'].includes(req.hostname))
        next();
}

function pingChat(req, res, next) {
    return res.json({
        message: 'OK'
    });
}

module.exports = router;