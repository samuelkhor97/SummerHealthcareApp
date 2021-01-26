module.exports = (sequelize, DataTypes) => {
    const Food_Data = sequelize.define('Food_Data', {
        food_id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
        },
        food_name: {
            type: DataTypes.STRING,
            allowNull: false
        },
        calories: {
            type: DataTypes.STRING,
            allowNull: false
        },
        protein: {
            type: DataTypes.STRING,
            allowNull: false
        },
        total_fat: {
            type: DataTypes.STRING,
            allowNull: false
        },
        saturated_fat: {
            type: DataTypes.STRING,
            allowNull: false
        },
        dietary_fibre: {
            type: DataTypes.STRING,
            allowNull: false
        },
        carbohydrate: {
            type: DataTypes.STRING,
            allowNull: false
        },
        cholesterol: {
            type: DataTypes.STRING,
            allowNull: false
        },
        sodium: {
            type: DataTypes.STRING,
            allowNull: false
        },
    }, {timestamps: false,});

    Food_Data.associate = models => {
        Food_Data.belongsToMany(models.Food_Diary_Card, {
            through: models.Food_Bridge,
            foreignKey: 'food_id',
            timestamps: false,
            as: 'food_info' 
        });
    };

    return Food_Data;
};