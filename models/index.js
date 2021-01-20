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
    Pharmacy: require('./pharmacy')(sequelize, Sequelize),
    Sugar_Level: require('./sugar_level')(sequelize, Sequelize),
    Weight: require('./weight')(sequelize, Sequelize),
    Food_Data: require('./food_data')(sequelize, Sequelize),
};

Object.keys(models).forEach(key => {
    if ('associate' in models[key]) {
        models[key].associate(models);
    }
});

module.exports = {sequelize, models};