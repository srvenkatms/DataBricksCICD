v# DataBricksCICD
Devops pipeline for Databricks
# Introduction to Notebook Promotion Pipeline

Welcome to the Notebook Promotion Pipeline! This pipeline streamlines the process of promoting notebooks across different environments in your Azure Databricks workspace. Whether you're moving from development to staging or staging to production, this pipeline automates the deployment process, ensuring consistency and reliability in your notebook deployments.

## Key Features:

- **Environment-Agnostic Configuration:** The pipeline is designed to be environment-agnostic, allowing you to promote notebooks seamlessly across different environments without the need for environment-specific configurations.

- **Flexible Promotion:** Whether you're promoting individual notebooks or entire folders, this pipeline offers flexibility in promoting your assets, accommodating various deployment scenarios.

- **Version Control Integration:** Integrated with version control systems such as Azure Devops, the pipeline ensures that all changes to notebooks are tracked and auditable, providing transparency and accountability throughout the deployment process.

- **Promotion to Enviornments:** Incorporating ADO Environments approval checks to control deployments to production environments.

- **Customizable Deployment Strategy:** Tailor the deployment strategy to suit your organization's specific requirements, whether it's a continuous deployment approach or a scheduled release cycle.

## Pipeline Structure:

- **Source Stage:** Fetches the notebooks from the source environment, typically the development environment, and triggers the deployment process.

- **Promotion Stages:** Consists of one or more stages representing the target environments (e.g., staging, production). Each stage deploys the notebooks to the respective environment, following the defined deployment strategy.

# Prerequisites for Running the Pipeline

Before running the pipeline, ensure the following prerequisites are completed:

## Databricks Provisioning

- **Databricks Environment:** Databricks needs to be provisioned and configured properly. The pipeline is designed to work with two Databricks environments. These environments can be hosted within the same resource group or in different resource groups.

## Service Principal Configuration

- **Service Principal:** A service principal with appropriate permissions is required to access the Databricks workspace. Ensure that the service principal is created and has the necessary permissions to interact with the Databricks environment.




## Getting Started:

To get started with the Notebook Promotion Pipeline, simply configure the pipeline parameters to match your environment settings and deployment preferences. Once configured, trigger the pipeline manually or automate it to run on commits. Pramameter values are read from ADO Environment variables.
Pipeline parameters are read from an Azure DevOps Variable Group. Create a variable group and define variables to store the following information:

- Resource Group Name(s)
- Azure DevOps Service Agent Name
- Azure DevOps Environment Names: One for each deployment environment
- Service Principal ID
- Service Principal Secret: Store the service principal secret value with type 'Secret'.

![Variable Group Example](ADOEnv.png
)


