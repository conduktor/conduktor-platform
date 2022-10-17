# Data Masking

The Conduktor Platform enables you to meet compliance regulations and obfuscate personal or sensitive data. 
When you create a policy inside the platform, they will be acknowledged when data is consumed within the Platform UI.
 
For example, when:
* Consuming Kafka messages in the Console
* Consuming Kafka messages in Conduktor Testing

## Important ⚠️

* Note that data masking does not impact how the underlying data is stored.

* Note that policies are applied globally at an organization level. In the future, support will be added for fine-grained policies, 
that can be applied for specific groups of users.

<img alt="Data Masking Policies" src="https://user-images.githubusercontent.com/2573301/190902543-1c547369-6c19-4520-a7cf-2dc395680173.png">


## Create a Policy 
Navigate to Data Masking via the home screen or the primary navigation switcher.

Select **Add Policy** and fill out the form with the policy details.

* **Policy Name**: Unique name for identifying your policy
* **Compliance**: The compliance regulation the policy adheres to (GDPR, PCI-DSS) 
* **Information Kind**: The kind of information for obfuscation (e.g. PII, Financial) 
* **Masking Rule**: How the obfuscation should be implemented (e.g. hide-all, hide-last-3)
* **Risk Level**: Categorization for the risk level associated with the policy
* **Fields**: List of fields that should be obfuscated with the masking rule

<img alt="Create Policy" src="https://user-images.githubusercontent.com/2573301/190901945-339ad04c-4216-4fdf-b2da-f8cafb2a96f4.png">


## Validate a Policy
Once you have created a policy, you should validate it through the Conduktor Console. 

* Navigate to a topic that contains data where your policy should be applied
    * _Alternatively, use the 'Produce' tab to mock a message that matches your policy rules_
* Check that the expected fields are obfuscated using the appropriate masking rule

![image](https://user-images.githubusercontent.com/2573301/190902888-91efdab7-36c8-4820-b9ad-b99cb05fee9c.png)



