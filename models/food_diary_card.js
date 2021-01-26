module.exports = (sequelize, DataTypes) => {
    const Food_Diary_Card = sequelize.define('Food_Diary_Card', {
        card_id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        card_name: {
            type: DataTypes.STRING,
        },
        date: {
            type: DataTypes.DATE,
            set: function(fieldName){
                this.setDataValue('date', new Date(fieldName))
            }
        },
        photo_url: {
            type: DataTypes.STRING,
        },
    }, {timestamps: false,});

    Food_Diary_Card.associate = models => {
        Food_Diary_Card.belongsTo(models.User, {
            foreignKey: {
                name: 'uid',
                allowNull: false,
                as: "food_card"
            }
        });
        
        Food_Diary_Card.belongsToMany(models.Food_Data, {
            through: models.Food_Bridge,
            foreignKey: 'card_id',
            timestamps: false,
        });

    };

    return Food_Diary_Card;
};