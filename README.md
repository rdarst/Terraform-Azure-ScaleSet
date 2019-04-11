# Terraform-Azure-ScaleSet
Check Point Lab deployment with ScaleSets and Windows/Linux Jump Servers

The demo requires that the autoprovisioning is already setup with an existing R80.20 or later management server

Make sure you have accepted the agreement for the Check Point R80.20 BYOL gateway either in the portal or by using PowerShell

Adjust the tags on the ScaleSet to match your profile in the autoprovisioning setup as part of Check Point Azure Scale Set Solution

- Based on R80.20 gateways
- Simple setup with multiple DMZ's and route tables. 
- Linux Jump Server with public IP to gain access to the enviroment
- Windows RDP via the ScaleSet to a jump host behind the gateway for testing

