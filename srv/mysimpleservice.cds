using {dip.db.master, dip.db.transaction } from '../db/datamodel';

service mysrvdemo{
    function somesrv(msg : String) returns String;

    @readonly
    entity ReadEmployeeSrv as projection on master.employee;
    @insertonly
    entity CreateEmployeeSrv as projection on master.employee;
    @updateonly
    entity UpdateEmployeeSrv as projection on master.employee;
    @deleteonly
    entity DeleteEmployeeSrv as projection on master.employee;

    
}
