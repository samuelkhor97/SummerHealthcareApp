module.exports = (sequelize, DataTypes) => {
    const Sugar_Level = sequelize.define('Sugar_Level', {
        sugar_level_id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        date: {
            type: DataTypes.DATE,
        },
        sugar_level: {
            type: DataTypes.DECIMAL,
        },
    }, {timestamps: false,});

    Sugar_Level.associate = models => {
        Sugar_Level.belongsTo(models.User, {
            foreignKey: {
                name: 'uid',
                allowNull: false
            }
        });
    };

    return Sugar_Level;
};