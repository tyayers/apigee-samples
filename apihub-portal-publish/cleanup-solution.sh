echo "👉 Starting clean-up of resources..."

# delete API Hub API
apigeecli apihub apis delete --id "apigee-sample-api" -o "$PROJECT_ID" -r "$REGION" -t $(gcloud auth print-access-token) --force

# delete API Hub deployments
apigeecli apihub deployments delete -i "apigee-sample-unmanaged-v1-deployment" -o "$PROJECT_ID" -r "$REGION" -t $(gcloud auth print-access-token)

apigeecli apihub deployments delete -i "apigee-sample-managed-v1-deployment" -o "$PROJECT_ID" -r "$REGION" -t $(gcloud auth print-access-token)

# delete portal doc
apigeecli apidocs delete -i "$CATALOG_ID" -s "$APIGEE_PORTAL_ID" -o "$PROJECT_ID" -t $(gcloud auth print-access-token)

# delete apigee product
apigeecli products delete -n "apihub-portal-product" -o "$PROJECT_ID" -t $(gcloud auth print-access-token)

# delete proxy
apigeecli apis undeploy -n "apihub-portal-publish" -e "$APIGEE_ENV" -o "$PROJECT_ID" -t $(gcloud auth print-access-token)
apigeecli apis delete -n "apihub-portal-publish" -o "$PROJECT_ID" -t $(gcloud auth print-access-token)

# delete proxy local file
rm apihub-portal-publish.zip

echo "👌 Clean-up of resources complete!"