module.exports = (sequelize, DataTypes) => {
    const Pharmacy = sequelize.define('Pharmacy', {
        pharmacy_id: {
            type: DataTypes.INTEGER,
            primaryKey: true,
            autoIncrement: true
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
        Pharmacy.hasMany(models.Pharmacist, {
            foreignKey: {
                name:  'pharmacy_id',
                allowNull: false
            }
        });
    };

    return Pharmacy;
};