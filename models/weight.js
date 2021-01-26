module.exports = (sequelize, DataTypes) => {
    const Weight = sequelize.define('Weight', {
        weight_id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
        },
        date: {
            type: DataTypes.DATE,
        },
        weight: {
            type: DataTypes.DECIMAL,
        },
    }, {timestamps: false,});

    Weight.associate = models => {
        Weight.belongsTo(models.User, {
            foreignKey: {
                name: 'uid',
                allowNull: false
            }
        });
    };

    return Weight;
};