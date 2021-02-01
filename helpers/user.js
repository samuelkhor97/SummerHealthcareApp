function getAge(birthDateString) {
    var today = new Date();
    birthDateString = birthDateString.split('-');
    // convert dd-MM-yyyy format into MM-dd-yyyy which is the valid format for Date()
    birthDateString = birthDateString[1] + '/' + birthDateString[0] + '/' + birthDateString[2];
    var birthDate = new Date(birthDateString);
    var age = today.getFullYear() - birthDate.getFullYear();
    var m = today.getMonth() - birthDate.getMonth();
    if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
        age--;
    }
    return age;
}

module.exports = {
    getAge
}