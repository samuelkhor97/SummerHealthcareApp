require('dotenv').config()

const {models, sequelize} = require('./models/index');
const express = require('express')
const cors = require('cors')
const app = express();
const bodyParser = require('body-parser');
const port = process.env.PORT
const firebaseAdmin = require('./firebase/firebase-admin');

function verifyUser(req, res, next){
    if (req.headers.authorization) {
        // admin tokens for debugging
        if (req.headers.authorization === 'adminuser') {
            let uid = 1;
            res.locals.id = uid.toString();
            next();
        } else if (req.headers.authorization === "adminpharmacist"){
            let phar_id = 100;
            res.locals.id = phar_id.toString();
            next();
        } else {
            // firebase auth, stores user/pharmacist id into res.locals.id
            firebaseAdmin.auth().verifyIdToken(req.headers.authorization)
                .then(auth => {
                    console.log('User id: ', auth.uid);
                    res.locals.id = auth.uid;
                    next();
                })
                .catch(() => {
                    res.status(403).send('Unauthorized');
                });
        }
    } else {
        res.status(403).send('Unauthorized');
    }
}

// api routes
// const adminRoutes = require('./admin/server');
const chatroomRoutes = require('./chatroom/server');
const foodDiaryRoutes = require('./foodDiary/server');
const pharmacistRoutes = require('./pharmacist/server');
const weightRoutes = require('./weight/server');
const sugarlevelRoutes = require('./sugarlevel/server');
const mibandRoutes = require('./miband/server');
const usersRoutes = require('./users/server');

// middleware
app.use(cors()) // enable cors everywhere, will configure later depending on needs// enable cors everywhere, will configure later depending on needs
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/', verifyUser);
// app.use('/admin', adminRoutes);
app.use('/chat', chatroomRoutes);
app.use('/food-diary', foodDiaryRoutes);
app.use('/pharmacist', pharmacistRoutes);
app.use('/weight', weightRoutes);
app.use('/user', usersRoutes);
app.use('/sugar-level', sugarlevelRoutes);
app.use('/mi-band', mibandRoutes);

initialize();

async function initialize() {
    if (process.env.DB_SYNC === 'true')
        await sequelize.sync(
            {
                force:true
            }
        );
    app.listen(port, () => {
        console.log(`Listening at port: ${port}`)
    }); 
}