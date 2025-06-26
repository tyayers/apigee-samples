# API Hub Portal Publishing Sample

This sample shows how unmanaged APIs can be registered to API Hub, turned into managed APIs in Apigee, and then published to an Apigee portal.

Let's get started!

---

## Prepare project dependencies

### 1. Ensure that prerequisite tools are installed, and that you have needed permissions.

- [gcloud CLI](https://cloud.google.com/sdk/docs/install) will be used for automating GCP tasks, see the docs site for installation instructions.
- [apigeecli](https://github.com/apigee/apigeecli) will be used for Apigee automation, see the docs site for installation instructions.
- [Apigee](https://cloud.google.com/apigee/docs/api-platform/get-started/provisioning-intro) and [Apigee API Hub](https://cloud.google.com/apigee/docs/apihub/what-is-api-hub) provisioned in a GCP region.
- GCP roles needed:
  - roles/apigee.apiAdminV2 - needed to deploy an Apigee proxy.
  - roles/apigee.portalAdmin - needed to manage the Apigee integrated developer portal.
  - roles/apihub.editor - needed to manage API Hub data
- An [Apigee Integrated Developer Portal](https://cloud.google.com/apigee/docs/api-platform/publish/portal/build-integrated-portal) needs to be provisioned and visible at in the [Apigee Portals Console](https://console.cloud.google.com/apigee/portals)

### 2. Ensure you have an active GCP account selected in the Cloud Shell.

```sh
gcloud auth login
```

## Set environment variables

First update the `env.sh` file with your environment variables. Click <walkthrough-editor-open-file filePath="apihub-portal-publish/env.sh">here</walkthrough-editor-open-file> to open the file in the editor.

* `PROJECT_ID` the project where your Apigee organization is located.
* `REGION` the externally reachable hostname of the Apigee environment group that contains APIGEE_ENV.
* `APIGEE_ENV` the Apigee environment where the demo resources should be created.
* `APIGEE_HOST` the Apigee host of the environment / environment group to reach the proxy
* `APIGEE_PORTAL_URL` the Apigee integrated portal URL (visible [here](https://console.cloud.google.com/apigee/portals)), must be the `*.apigee.io` URL, not a custom domain.

After saving, switch to the `apihub-portal-publish` directory and source the env file.

```sh
cd apihub-portal-publish
source env.sh
```

## Register unmanaged API in API Hub

Register the unmanaged API at https://mocktarget.apigee.net/help to API Hub. This can make it visible, and prepare to added management and portal documentation.

```sh
./deploy-unmanaged-api.sh
```

## Add management to the API and register in an Apigee portal

Now add an Apigee proxy to the unmanaged API and register it in an Apigee portal, and document the results in API Hub as a new deployment.

```sh
./deploy-managed-api.sh
```

## Congratulations

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

You're all set!

**Don't forget to clean up after yourself**. Execute the following commands to undeploy and delete all sample resources.

```sh
./cleanup-solution.sh
```
