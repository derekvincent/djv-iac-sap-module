

module "sap-ansible-abap-test" {
    source = "../"
    json_format = false
    sid =  "ECD"
    hostname = "saptestserver"
    domainname =  "clockwork.corp"
    ip_address =  "10.100.0.8"
    swap_device =  "/dev/sdw"
    volume_groups= [
        {
            name: "sap", 
            devices: ["/dev/sdf"],
            logical_volumes: [
                { name: "usr_sap", size: "50G", mount: "/usr/sap", fstype: "xfs" },
                { name: "sapmnt", size: "100%FREE", mount: "/sapmnt", fstype: "xfs" }
            ]
        },
        {
            name: "ase",
            devices: ["/dev/sdh"],
            logical_volumes: [
                { name: "ase", size: "30G", mount: "/sybase/[SID]/", fstype: "xfs" }, 
                { name: "logs", size: "40G", mount: "/sybase/[SID]/saplog_1", fstype: "xfs" },
                { name: "data", size: "100%FREE", mount: "/sybase/[SID]/sapdata_1", fstype: "xfs" }
            ]
        },
        {
            name: "backup",
            devices: ["/dev/sdo"] 
            logical_volumes: [
                { name: "backups", size: "100G", mount: "/sybase/DAC/backup", fstype: "xfs" },
                { name: "archive_logs", size: "100%FREE", mount: "/sybase/DAC/archive_logs", fstype: "xfs"}
            ]                   
        }
    ]
    block_devices = [
        {
           name: "Software",
           device: "/dev/sdg",
           size: "100%FREE", 
           mount: "/sybase/DAC/archive_logs", 
           fstype: "xfs"

        },
        {
           name: "Software2",
           device: "/dev/sdt",
           size: "100%FREE", 
           mount: "/sybase/[SID]/archive_logs", 
           fstype: "xfs"

        }        
    ]
    saptrans_efs = {"use2-az1": {
        filesystem_id: "fs-3df46f45"
        filesystem_host: "fs-3df46f45.efs.us-east-2.amazonaws.com"
        filesystem_ip: "10.100.12.25"
        tls: true
        iam: true
        access_point: "fsap-01230fe8d391ac5b6"
    }}
}
