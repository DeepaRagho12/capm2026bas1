const cds = require('@sap/cds');

module.exports = cds.service.impl(async function () {

    const { EmployeeSet, POs } = this.entities;

    this.before('UPDATE', EmployeeSet, (req,res) => {

        console.log('UPDATE called', req.data.salaryAmount);

        if (parseFloat(req.data.salaryAmount) >= 1000000) {

            req.error(500, 'Salary cannot be greater than 1000000');

        }

    });
  

     this.on('boost', async (req) => {

    try {

        const NODE_KEY = req.params[0].NODE_KEY;

        console.log('Purchase Order with NODE_KEY: ' + NODE_KEY + ' is being boosted');

        const tx = cds.tx(req);

        await tx.update(POs)
            .with({
                GROSS_AMOUNT: { '+=': 2000 },
                NOTE: 'Boosted by 2000'
            })
            .where({ NODE_KEY: NODE_KEY });

        return 'Boosted successfully';

    } catch (error) {

        return "Error boosting purchase order: " + error.toString();

    }

});
this.on('largestOrder', async (req) => {

    try {

        console.log('Fetching largest purchase order');

        const tx = cds.tx(req);

        const reply = await tx.read(POs)
    .orderBy({ GROSS_AMOUNT: 'desc' })
    .limit(1);

        return reply;

    } catch (error) {

        return "Error fetching largest order: " + error.toString();

    }

});
});
