# Target Circuit Breaking Sample

---
This sample shows how to implement various circuit breaking and target failover techniques using [Apigee Target Server Load Balancing](https://cloud.google.com/apigee/docs/api-platform/deploy/load-balancing-across-backend-servers).

Let's get started!

---

## Prepare project dependencies

### 1. Ensure that prerequisite tools are installed, and that you have needed permissions

- [gcloud CLI](https://cloud.google.com/sdk/docs/install) will be used for automating GCP tasks, see the docs site for installation instructions.
- [apigeecli](https://github.com/apigee/apigeecli) will be used for Apigee automation, see the docs site for installation instructions.
- [hey](https://github.com/rakyll/hey) will be used to generate load to trigger the circuit breaking.
- [Apigee](https://cloud.google.com/apigee/docs/api-platform/get-started/provisioning-intro) and [Apigee API Hub](https://cloud.google.com/apigee/docs/apihub/what-is-api-hub) provisioned in a GCP region. The original API Hub test data that come from provisioning should be available.
- GCP roles needed:
  - roles/apigee.apiAdminV2 - needed to deploy an Apigee proxy.
  - roles/run.developer - needed to deploy the rate limited target service to cloud run.

### 2. Ensure you have an active GCP account selected in the Cloud Shell

```sh
gcloud auth login
```

## Set environment variables

First update the `env.sh` file with your environment variables. Click <walkthrough-editor-open-file filePath="apihub-portal-publish/env.sh">here</walkthrough-editor-open-file> to open the file in the editor.

* `PROJECT_ID` the project where your Apigee organization is located.
* `REGION` the externally reachable hostname of the Apigee environment group that contains APIGEE_ENV.
* `APIGEE_ENV` the Apigee environment where the demo resources should be created.
* `APIGEE_HOST` the Apigee host of the environment / environment group to reach the proxy

After saving, switch to the `target-circuit-breaking` directory and source the env file.

```sh
cd target-circuit-breaking
source env.sh
```

## Deploy Apigee components

Next, let's create and deploy the Apigee resources necessary to test a target circuit breaker.

```sh
./deploy-solution.sh
```

### Test the APIs

Run the following command to test the unhealthy target:

```sh
hey https://$APIGEE_HOST/v1/samples/target-circuit-breaking/unhealthy
```

Observe how a subset of the results get a 429, meaning a quota is exhausted in `target1`. Even though we have a second target `target2` configured, because of the weights, it's not enough to completely solve the problem.

Next, repeat the command on the healthy endpoint, which recognizes `429` as an unhealthy condition, and uses `target2` as a more effective fallback.

```sh
hey https://$APIGEE_HOST/v1/samples/target-circuit-breaking/healthy
```

Observe how the we get all `200` responses now, since the circuit breaker is working correctly.

Now test `v2` of the API, which has solved the quota problem and always delivers healthy responses. Also as a bonus in `v2`, we can send a message that will be ingested in a Pub/Sub message queue.

```sh
hey https://$APIGEE_HOST/v2/samples/target-circuit-breaking/healthy?message=apigeerocks
```

Observe how all results are now `200` since v2 is more stable than v1, however a simple circuit breaker configuration can always help guarantee stability.

---

## Conclusion

<walkthrough-conclusion-trophy></walkthrough-conclusion-trophy>

Congratulations! You've successfully implemented target circuit breaking in Apigee.

<walkthrough-inline-feedback></walkthrough-inline-feedback>

## Cleanup

If you want to clean up the artifacts from this example in your Apigee Organization, first source your `env.sh` script, and then run

```bash
./clean-up-threat-protection.sh
```
