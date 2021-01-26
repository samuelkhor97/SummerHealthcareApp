module.exports = (sequelize, DataTypes) => {
    const User = sequelize.define('User', {
        uid: {
            type: DataTypes.STRING,
            primaryKey:  true,
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
        height: {
            type: DataTypes.DECIMAL,
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
        education_status: {
            type: DataTypes.STRING,
            allowNull: false
        },
        employment_status: {
            type: DataTypes.STRING,
            allowNull: false
        },
        occupation: {
            type: DataTypes.STRING,
            allowNull: false
        },
        marital_status: {
            type: DataTypes.STRING,
            allowNull: false
        },
        smoker: {
            type: DataTypes.BOOLEAN,
            allowNull: false
        },
        cigs_per_day: {
            type: DataTypes.INTEGER,
            allowNull: false
        },
        e_cig: {
            type: DataTypes.BOOLEAN,
            allowNull: false
        },
        signup_date: {
            type: DataTypes.DATE,
            allowNull: false
        }
    }, {timestamps: false,});

    User.associate = models => {
        User.hasMany(models.Sugar_Level, {
            onDelete: 'CASCADE',
            foreignKey: {
                name: 'uid',
                allowNull: false
            }
        });
        User.hasMany(models.Weight, {
            onDelete: 'CASCADE',
            foreignKey: {
                name: 'uid',
                allowNull: false
            }
        });

        User.hasMany(models.Food_Diary_Card, {
            onDelete: 'CASCADE',
            foreignKey: {
                name: 'uid',
                allowNull: false
            }
        });
    };

    return User;
};