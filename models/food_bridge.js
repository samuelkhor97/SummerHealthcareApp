module.exports = (sequelize, DataTypes) => {
    const Food_Bridge = sequelize.define('Food_Bridge', {
        food_id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
        },
        card_id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
        },
        photo_url: {
            type: DataTypes.STRING,
            allowNull: true
        }
    }, {timestamps: false,});

    Food_Bridge.associate = models => {
        Food_Bridge.belongsTo(models.Food_Diary_Card, { targetKey: 'card_id', foreignKey: 'card_id'})
        Food_Bridge.belongsTo(models.Food_Data, { targetKey: 'food_id', foreignKey: 'food_id'})
    }
    return Food_Bridge;
};