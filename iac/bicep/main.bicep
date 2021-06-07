param baseName string
param apiPublisherName string = 'Microsoft'
param apiPublisherEmail string = 'chwieder@microsoft.com'

resource vnet 'Microsoft.Network/virtualNetworks@2020-07-01' = {
  name: '${baseName}-vnet'
  location: resourceGroup().location

  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'gateway-subnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'apim-subnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
      {
        name: 'bastion-subnet'
        properties: {
          addressPrefix: '10.0.10.0/24'
        }
      }
    ]
  }
}

resource apim 'Microsoft.ApiManagement/service@2021-01-01-preview' = {
  name: '${baseName}-apim'
  location: resourceGroup().location

  sku: {
    name: 'Developer'
    capacity: 1
  }

  identity: {
    type: 'SystemAssigned'
  }

  properties: {
    publisherName: apiPublisherName
    publisherEmail: apiPublisherEmail
    //notificationSenderEmail: 'apimgmt-noreply@mail.windowsazure.com'

    // hostnameConfigurations: [
    //   {
    //     type: 'Proxy'
    //     hostName: '${baseName}-apim.azure-api.net'
    //     negotiateClientCertificate: false
    //     defaultSslBinding: true
    //     certificateSource: 'BuiltIn'
    //   }
    // ]

    virtualNetworkType: 'Internal'
    
    virtualNetworkConfiguration: {
      subnetResourceId: '${vnet.id}/subnets/apim-subnet'
    }

    // customProperties: {
    //   'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'False'
    //   'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'False'
    //   'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Ssl30': 'False'
    //   'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Ciphers.TripleDes168': 'False'
    //   'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'False'
    //   'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'False'
    //   'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'False'
    //   'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'False'
    // }
  }
}
