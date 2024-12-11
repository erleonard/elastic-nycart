targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment that can be used as part of naming resource convention')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

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
  }
}

@description('Output the default hostname')
output endpoint string = swa.outputs.defaultHostname

@description('Output the static web app name')
output staticWebAppName string = swa.outputs.name
