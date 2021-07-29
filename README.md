# SAP Terraform Deployment Modules

These modules are used in the deployment and management of SAP based systems. 

## SAP-ABAP 
The SAP ABAP module is used for the base of a SAP based system. It is actually used in the deployment of both ABAP and JAVA based systems. 

More info [README](./sap-abap/README.md) 
## SAP Ansible ABAP

The Ansible module takes a specific set of values from the Terraform and generates an output object of Ansible compatible variables to be used in the ansible deployment. 

More info [README](./sap-ansible-abap/README.md) 

## SAP Security Group

This will generate a base security group for a CI, DI, and ASCS for ABAP based SAP instances. They group will be targeted based on the SAP system number input and leverage standard ports as defined by SAP. Additional ingress/egress rules are allowed to passed in. 

More info [README](./sap-security-group/README.md) 
## SAP J2EE Security Group 

This will generate a base security group for a CI, DI, and ASCS for J2EE based SAP instances. They group will be targeted based on the SAP system number input and leverage standard ports as defined by SAP. Additional ingress/egress rules are allowed to passed in. 

More info [README](./sap-j2ee-security-group/README.md) 


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->