const Sequelize = require('sequelize');

const sequelize = new Sequelize(
    process.env.DB_NAME,
    process.env.DB_USER,
    process.env.DB_PASS,
    {
        host: process.env.DB_HOST,
        port: process.env.DB_PORT,
        dialect: 'postgres',
    },
);

const models = {
    User: require('./user')(sequelize, Sequelize),
    Pharmacist: require('./pharmacist')(sequelize, Sequelize),
    Pharmacy: require('./pharmacy')(sequelize, Sequelize),
    User_Pharmacist: require('./user_pharmacist')(sequelize, Sequelize),
    Sugar_Level: require('./sugar_level')(sequelize, Sequelize),
    Weight: require('./weight')(sequelize, Sequelize),
};

// testConnection();

Object.keys(models).forEach(key => {
    if ('associate' in models[key]) {
        models[key].associate(models);
    }
});

async function testConnection() {
    try {
        await sequelize.authenticate();
        console.log('Db connection has been established successfully.');
    } catch (error) {
        console.error('Unable to connect to the database:', error);
    }
}

module.exports = {sequelize, models};