module.exports = (sequelize, DataTypes) => {
    const User_Pharmacist = sequelize.define('User_Pharmacist', {}, {timestamps: false,});

    return User_Pharmacist;
};