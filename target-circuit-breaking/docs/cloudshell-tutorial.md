# Target Circuit Breaking

---
This sample shows how to implement various circuit breaking and target failover techniques using [Apigee Target Server Load Balancing](https://cloud.google.com/apigee/docs/api-platform/deploy/load-balancing-across-backend-servers).

Let's get started!

---

## Setup environment

Ensure you have an active GCP account selected in the Cloud shell

```sh
gcloud auth login
```

Navigate to the `target-circuit-breaker` directory in the Cloud shell.

```sh
cd target-circuit-breaker
```

Edit the provided sample `env.sh` file, and set the environment variables there.

Click <walkthrough-editor-open-file filePath="target-circuit-breaker/env.sh">here</walkthrough-editor-open-file> to open the file in the editor

Then, source the `env.sh` file in the Cloud shell.

```sh
source ./env.sh
```

---

## Deploy Apigee components

Next, let's create and deploy the Apigee resources necessary to test a target circuit breaker.

```sh
./deploy-target-circuit-breaker.sh
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
