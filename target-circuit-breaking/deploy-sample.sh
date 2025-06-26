# Copyright 2025 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

if [ -z "$PROJECT_ID" ]; then
  echo "No PROJECT_ID variable set"
  exit
fi

if [ -z "$REGION" ]; then
  echo "No REGION variable set"
  exit
fi

if [ -z "$APIGEE_ENV" ]; then
  echo "No APIGEE_ENV variable set"
  exit
fi

if [ -z "$APIGEE_HOST" ]; then
  echo "No APIGEE_HOST variable set"
  exit
fi

echo "💻 Enabling services..."
gcloud services enable "artifactregistry.googleapis.com" --project "$PROJECT_ID"
gcloud services enable "cloudbuild.googleapis.com" --project "$PROJECT_ID"
gcloud services enable "run.googleapis.com" --project "$PROJECT_ID"

echo "💻 Assigning permissions to default service account..."
PROJECT_NUMBER=$(gcloud projects describe $PROJECT_ID --format="value(projectNumber)")
gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:$PROJECT_NUMBER-compute@developer.gserviceaccount.com" --role='roles/storage.objectViewer'

echo "💻 Deploying test backend service to cloud run..."
yes | gcloud run deploy "target-service" --source . --project "$PROJECT_ID" --region "$REGION" --no-allow-unauthenticated --set-env-vars applyRateLimit=true
gcloud run deploy "target-service2" --source . --project "$PROJECT_ID" --region "$REGION" --no-allow-unauthenticated