# API Hub Portal Publishing Sample
This sample shows how external APIs registered in API Hub can be automatically on-ramped into an [Apigee integrated developer portal](https://cloud.google.com/apigee/docs/api-platform/publish/portal/build-integrated-portal).

## Prerequisites
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) will be used for automating GCP tasks, see the docs site for installation instructions.
- [apigeecli](https://github.com/apigee/apigeecli) will be used for Apigee automation, see the docs site for installation instructions.
- [Apigee](https://cloud.google.com/apigee/docs/api-platform/get-started/provisioning-intro) and [Apigee API Hub](https://cloud.google.com/apigee/docs/apihub/what-is-api-hub) provisioned in a GCP region.
- GCP roles needed:
  - roles/apigee.apiAdminV2 - needed to deploy an Apigee proxy.
  - roles/apigee.portalAdmin - needed to manage the Apigee integrated developer portal.
  - roles/apihub.editor - needed to manage API Hub data
- An [Apigee Integrated Developer Portal](https://cloud.google.com/apigee/docs/api-platform/publish/portal/build-integrated-portal) needs to be provisioned and visible at in the [Apigee Portals Console](https://console.cloud.google.com/apigee/portals)

## (QuickStart) Setup using CloudShell

Use the following GCP CloudShell tutorial, and follow the instructions in Cloud Shell. Alternatively, follow the instructions below.

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/open?cloudshell_git_repo=https://github.com/GoogleCloudPlatform/apigee-samples&cloudshell_git_branch=main&cloudshell_workspace=.&cloudshell_tutorial=apihub-portal-publish/docs/cloudshell-tutorial.md)

## Setup instructions

### Step 1: Set your GCP project environment variables

To begin, set your environment variables to be used in the `env.sh` file.

* `PROJECT_ID` the project where your Apigee organization is located.
* `REGION` the externally reachable hostname of the Apigee environment group that contains APIGEE_ENV.
* `APIGEE_ENV` the Apigee environment where the demo resources should be created.
* `APIGEE_HOST` the Apigee host of the environment / environment group to reach the proxy
* `APIGEE_PORTAL_URL` the Apigee integrated portal URL (visible [here](https://console.cloud.google.com/apigee/portals)), must be the `*.apigee.io` URL, not a custom domain.

Now source the environment variables file.

```sh
source env.sh
```

### Step 2: Register an unmanaged API in API Hub

First register an unmanaged API in API Hub, namely the Apigee Sample API found here: https://mocktarget.apigee.net/help.

```sh
./deploy-unmanaged-api.sh
```

Now check in [API Hub](https://console.cloud.google.com/apigee/api-hub/apis) how the unmanaged API is registered with a deployment and specification.

### Step 3: Create a managed Apigee proxy for unmanaged API

Extend the configuration by registering the API as an Apigee proxy, thereby creating a managed endpoint. Then publish it to an Apigee developer portal, and update API Hub with the new deployment.

```sh
./deploy-managed-api.sh
```

Check the result in [API Hub](https://console.cloud.google.com/apigee/api-hub/apis), and how the new managed API is documented in the Apigee developer portal.

### Step 4: Clean up resources

Clean up all of the resources.

```sh
./cleanup-solution.sh
```

Congrats, you registered an unmanaged API to API Hub, created a managed proxy and developer portal documentation for the API thereby making it managed, and then updated API Hub with the new deployment and documentation information.