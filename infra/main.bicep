targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

param ELASTIC_SEARCH_INDEX string
param ELASTIC_VECTOR_FIELD string
param ELASTIC_EMBEDDING_MODEL_ID string
param ELASTIC_COMPLETION_MODEL_ID string
param ELASTIC_INFERENCE_PIPELINE_MODEL_ID string
param AZURE_EMBEDDING_API_VERSION string
param AZURE_COMPLETION_API_VERSION string

param ELASTIC_CLUSTER string
param ELASTIC_API_KEY string
param ENDPOINT_BASE string
param ENDPOINT string
param AZURE_API_KEY string
param AZURE_EMBEDDING_RESOURCE_NAME string
param AZURE_EMBEDDING_DEPLOYMENT_ID string
param AZURE_COMPLETION_RESOURCE_NAME string
param AZURE_COMPLETION_DEPLOYMENT_ID string
param ASSISTANT_ID string

@description('String to make resource names unique')
var random = uniqueString(subscription().subscriptionId, location)

// tags that should be applied to all resources.
var tags = {
  'azd-env-name': environmentName
}

resource rg 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

@description('Create a static web app')
module swa 'br/public:avm/res/web/static-site:0.6.1' = {
  name: 'staticSiteDeployment'
  scope: rg
  params: {
    name: 'swa-${random}'
    location: location
    tags: union(tags, { 'azd-service-name': 'web' })
    sku: 'Standard'
    appSettings: {
      APP_LOCATION: location
      ELASTIC_SEARCH_INDEX: ELASTIC_SEARCH_INDEX
      ELASTIC_VECTOR_FIELD: ELASTIC_VECTOR_FIELD
      ELASTIC_EMBEDDING_MODEL_ID: ELASTIC_EMBEDDING_MODEL_ID
      ELASTIC_COMPLETION_MODEL_ID: ELASTIC_COMPLETION_MODEL_ID
      ELASTIC_INFERENCE_PIPELINE_MODEL_ID: ELASTIC_INFERENCE_PIPELINE_MODEL_ID
      AZURE_EMBEDDING_API_VERSION: AZURE_EMBEDDING_API_VERSION
      AZURE_COMPLETION_API_VERSION: AZURE_COMPLETION_API_VERSION
      ELASTIC_CLUSTER: ELASTIC_CLUSTER
      ELASTIC_API_KEY: ELASTIC_API_KEY
      ENDPOINT_BASE: ENDPOINT_BASE
      ENDPOINT: ENDPOINT
      AZURE_API_KEY: AZURE_API_KEY
      AZURE_EMBEDDING_RESOURCE_NAME: AZURE_EMBEDDING_RESOURCE_NAME
      AZURE_EMBEDDING_DEPLOYMENT_ID: AZURE_EMBEDDING_DEPLOYMENT_ID
      AZURE_COMPLETION_RESOURCE_NAME: AZURE_COMPLETION_RESOURCE_NAME
      AZURE_COMPLETION_DEPLOYMENT_ID: AZURE_COMPLETION_DEPLOYMENT_ID
      ASSISTANT_ID: ASSISTANT_ID
    }
  }
}

@description('Output the default hostname')
output endpoint string = swa.outputs.defaultHostname

@description('Output the static web app name')
output staticWebAppName string = swa.outputs.name
