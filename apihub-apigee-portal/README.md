# API Hub Developer Portal Migration
This sample shows how external APIs registered in API Hub can be automatically on-ramped into an [Apigee integrated developer portal](https://cloud.google.com/apigee/docs/api-platform/publish/portal/build-integrated-portal).

## Prerequisites
- [gcloud CLI](https://cloud.google.com/sdk/docs/install) will be used for automating GCP tasks, see the docs site for installation instructions.
- [apigeecli](https://github.com/apigee/apigeecli) will be used for Apigee automation, see the docs site for installation instructions.
- [Apigee](https://cloud.google.com/apigee/docs/api-platform/get-started/provisioning-intro) and [Apigee API Hub](https://cloud.google.com/apigee/docs/apihub/what-is-api-hub) provisioned in a GCP region.
- GCP roles needed:
  - roles/apigee.apiAdminV2 - needed to deploy an Apigee proxy.
  - roles/apigee.environmentAdmin - needed to manage the Keystore and Target configuration.

## (QuickStart) Setup using CloudShell

Use the following GCP CloudShell tutorial, and follow the instructions in Cloud Shell. Alternatively, follow the instructions below.

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/open?cloudshell_git_repo=https://github.com/GoogleCloudPlatform/apigee-samples&cloudshell_git_branch=main&cloudshell_workspace=.&cloudshell_tutorial=apihub-portal-migration/docs/cloudshell-tutorial.md)

## Setup instructions

### Step 1: Set your GCP project environment variables

To begin, set your environment variables to be used in the `env.sh` file.

* `PROJECT_ID` the project where your Apigee organization is located.
* `REGION` the externally reachable hostname of the Apigee environment group that contains APIGEE_ENV.
* `APIGEE_ENV` the Apigee environment where the demo resources should be created.
* `APIGEE_HOST` the Apigee host of the environment / environment group to reach the proxy

Now source the file, and create a default Apigee CLI token to use for subsequent calls.

```sh
source env.sh
```

### Step 2: Register an unmanaged API in API Hub

```sh
# create new attribute for apis to be published to apigee
apigeecli apihub attributes create --allowed-values "apihub-attr.json" --data-type "ENUM" --description "Portal published state of an API" --display-name "Portal Published State" -i "portal-published-state" -s "DEPLOYMENT" -o "$PROJECT_ID" -r "$REGION" -t $(gcloud auth print-access-token)

# copy definitions and set env variables in local files
cp apihub-api.json apihub-api.local.json
sed -i "s,PROJECT_ID,$PROJECT_ID,g" ./apihub-api.local.json
sed -i "s,REGION,$REGION,g" ./apihub-api.local.json
cp apihub-api-version.json apihub-api-version.local.json
sed -i "s,PROJECT_ID,$PROJECT_ID,g" ./apihub-api-version.local.json
sed -i "s,REGION,$REGION,g" ./apihub-api-version.local.json

# create deployment
apigeecli apihub deployments create -i "apigee-unmanaged-api-v1-deployment" -n "Apigee Mock Target API Deployment" --dep-type "unmanaged" --description "Apigee Mock Target API running in another cloud" --display-name "Apigee Mock Target API External Deployment" --endpoints "https://mocktarget.apigee.net" --resource-uri "https://mocktarget.apigee.net" --slo-type "99-99" -o "$PROJECT_ID" -r "$REGION" -t $(gcloud auth print-access-token)

# create api, version and spec in api hub
apigeecli apihub apis create -i "apigee-unmanaged-api" -f apihub-api.local.json -r "$REGION" -o "$PROJECT_ID" -t $(gcloud auth print-access-token)
apigeecli apihub apis versions create -i "apigee-unmanaged-api-v1" --api-id "apigee-unmanaged-api" -f apihub-api-version.local.json -r "$REGION" -o "$PROJECT_ID" -t $(gcloud auth print-access-token)
apigeecli apihub apis versions specs create -i "apigee-unmanaged-api-v1-spec" --api-id "apigee-unmanaged-api" --version "apigee-unmanaged-api-v1" -d "Apigee Mock Target API v1 Spec" -f "./oas.yaml" -r $REGION -o $PROJECT_ID -t $(gcloud auth print-access-token)

# create version
apigeecli apihub apis versions 
```