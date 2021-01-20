module.exports = (sequelize, DataTypes) => {
    const Food_Diary_Card = sequelize.define('Food_Diary_Card', {
        card_name: {
            type: DataTypes.STRING,
            primaryKey: true,
            unique: true
        },
        date: {
            type: DataTypes.DATEONLY,
            primaryKey: true
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
                primaryKey: true
            }
        });


    };

    return Food_Diary_Card;
};