require('dotenv').config()

const {models, sequelize} = require('./models/index');
const express = require('express')
const cors = require('cors')
const app = express();
const port = process.env.PORT

// api routes
const adminRoutes = require('./admin/server');
const chatroomRoutes = require('./chatroom/server');
const foodDiaryRoutes = require('./foodDiary/server');
const healthProvRoutes = require('./healthcareProviders/server');
const monitoringRoutes = require('./monitoring/server');
const readingsRoutes = require('./readings/server');
const usersRoutes = require('./users/server');

// enable cors everywhere, will configure later depending on needs
app.use(cors())

app.use('/api', adminRoutes);
app.use('/api', chatroomRoutes);
app.use('/api', foodDiaryRoutes);
app.use('/api', healthProvRoutes);
app.use('/api', monitoringRoutes);
app.use('/api', readingsRoutes);
app.use('/api', usersRoutes);

app.get('/ping', (req, res) => res.status(200).send('OK'));

initialize();

async function initialize() {
    if (process.env.DB_SYNC === 'true')
        await sequelize.sync({force:true});
    app.listen(port, () => {
        console.log(`Listening at port: ${port}`)
    }); 
}