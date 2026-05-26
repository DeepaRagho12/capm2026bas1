
const cds = require('@sap/cds');

const proxy = require('@sap/cds-odata-v2-adapter-proxy');
cds.on('bootstrap', app => {
    app.use(proxy({
        // options  
    }));
});

module.exports = cds.server;