module.exports = (sequelize, DataTypes) => {
    const Pharmacy = sequelize.define('Pharmacy', {
        pharmacy_id: {
            type: DataTypes.STRING,
            primaryKey: true
        },
        location: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        phone_num: {
            type: DataTypes.STRING,
            unique: true,
            allowNull: false,
        },
    }, {timestamps: false,});

    Pharmacy.associate = models => {
        Pharmacy.hasMany(models.User, {
            onDelete: 'CASCADE',
            foreignKey: {
                name: 'pharmacy_id',
                allowNull: true
            }
        });

    };

    return Pharmacy;
};