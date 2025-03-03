#!/bin/bash


# Set project variables
PROJECT_ID="my-flask-cloud-run"
SERVICE_NAME="flask-app"
REGION="europe-west1"
IMAGE_NAME="gcr.io/$PROJECT_ID/$SERVICE_NAME"


# Exit on error
set -e


echo "🚀 Building Docker image for amd64 (x86_64) architecture..."
docker buildx build --platform linux/amd64 -t $IMAGE_NAME --push .


echo "🌍 Deploying to Cloud Run..."
gcloud run deploy $SERVICE_NAME \
   --image $IMAGE_NAME \
   --platform managed \
   --region $REGION \
   --allow-unauthenticated \
   --project=$PROJECT_ID


echo "🔍 Retrieving Cloud Run URL..."
URL=$(gcloud run services describe $SERVICE_NAME \
   --platform managed \
   --region $REGION \
   --format 'value(status.url)' \
   --project=$PROJECT_ID)


echo "✅ Deployment complete! Your app is live at: $URL"
