module.exports = (sequelize, DataTypes) => {
    const Pharmacist = sequelize.define('Pharmacist', {
        phar_id: {
            type: DataTypes.INTEGER,
            primaryKey:  true,
            autoIncrement: true
        },
        full_name: {
            type: DataTypes.STRING,
            allowNull: false,
        },
        phone_num: {
            type: DataTypes.STRING,
            unique: true,
            allowNull: false,
        },
        age: {
            type: DataTypes.INTEGER,
            allowNull: false,
        },
        gender: {
            type: DataTypes.STRING,
        },
        ethnicity: {
            type: DataTypes.STRING,
            allowNull: false
        },
    }, {timestamps: false,});

    Pharmacist.associate = models => {
        Pharmacist.belongsToMany(models.User, {
            onDelete: 'CASCADE', 
            through: models.User_Pharmacist,
            foreignKey: 'phar_id'
        });
        Pharmacist.belongsTo(models.Pharmacy, {
            foreignKey: 'pharmacy_id'
        });
    };

    return Pharmacist;
};