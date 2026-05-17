const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const { EmployeeSet } = this.entities;

    this.before('UPDATE', EmployeeSet, (req) => {

        console.log('UPDATE called');

        if (parseFloat(req.data.salaryAmount) >= 1000000) {

            req.error(500, 'Salary cannot be greater than 1000000');

        }

    });

});
