const cds = require('@sap/cds');
const { where } = require('@sap/cds/lib/ql/cds-ql');
const { employee } = cds.entities('dip.db.master');

const mysrvdemo = function(srv){
  srv.on('somesrv', (req, res) => {
    return `hey ` + req.data.msg;

  });  
  //Read operation
  srv.on('READ', 'ReadEmployeeSrv', async (req) => {  
    let result = [];
    let whereCondition = req.data;

    console.log(whereCondition);

    if(whereCondition.hasOwnProperty('ID')){
        result = await cds.tx(req).run(
            SELECT.from(employee).where({ ID: whereCondition.ID })
        );
    } else {
        result = await cds.tx(req).run(
            SELECT.from(employee).limit(1)
        );
    }

    return result;
});

//create 
srv.on("CREATE", "CreateEmployeeSrv", async(req,res) => {

    console.log(req.data);

    var dataset = [];
    
    for (let i = 0; i < req.data.length; i++) {

        const element = req.data[i];

        var rString = randomString(32, '0123456789abcdefghijklmnopqrstuvwxyz');

        element.ID = rString.toUpperCase();

        dataset.push(element);

    }

    console.log(dataset);

    let returnData = await cds.transaction(req).run([

        INSERT.into(employee).entries(dataset)

    ]).then((resolve, reject) => {

        if(typeof(resolve) !== 'undefined'){

            return req.data;

        }else{

            req.error(500, "There was an issue in insert");

        }

    }).catch(err => {

        req.error(500, "there was an error " + err.toString());

    });

    return returnData;

});


//update operation
srv.on("UPDATE", "UpdateEmployeeSrv", async(req,res) =>{
    console.log(req.data);
    let returnData = await cds.transaction(req).run([

        UPDATE(employee).set({
          nameFirst: req.data.nameFirst
        }).where({ID: req.data.ID}),
        UPDATE(employee).set({
          nameLast: req.data.nameLast
        }).where({ID: req.data.ID})
      
]).then( (resolve, reject) => {

    if(typeof(resolve) !== undefined){
        return req.data;
    }else{
        req.error(500, "There was an issue in update");
    }

}).catch( err => {
    req.error(500, "there was an error " + err.toString());
});
  return returnData;
}); 


//delete operation
srv.on("DELETE", "DeleteEmployeeSrv", async(req,res) => {
    console.log(req.data);
    let returnData = await cds.transaction(req).run([

        DELETE.from(employee).where({ID: req.data.ID})
      
]).then( (resolve, reject) => {

    if(typeof(resolve) !== undefined){
        return req.data;
    }else{
        req.error(500, "There was an issue in update");
    }

}).catch( err => {
    req.error(500, "there was an error " + err.toString());
});
  return returnData;
});      
}
module.exports = mysrvdemo;