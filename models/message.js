module.exports = (sequelize, DataTypes) => {
    const Message = sequelize.define('message', {
        text: {
            type: DataTypes.STRING,
            allowNull: false,
            validate: {
                notEmpty: true,
            },
        }
    }, {timestamps: false,});

    Message.associate = models => {
        Message.belongsTo(models.User);
    };

    return Message;
};