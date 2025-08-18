name: Create S3
on:
 workflow_dispatch:
 push:
   branches: [ main ]
jobs:
 setup-terraform-backend:
   runs-on: ubuntu-latest
   steps:
     - name: Checkout repo
       uses: actions/checkout@v4
     - name: Configure AWS credentials
       uses: aws-actions/configure-aws-credentials@v4
       with:
         aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
         aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
         aws-region: us-west-2
     - name: Create S3 bucket (if not exists)
       run: |
         if ! aws s3api head-bucket --bucket stagebucket12 2>/dev/null; then
           aws s3api create-bucket \
             --bucket stagebucket12 \
             --region us-west-2 \
             --create-bucket-configuration LocationConstraint=us-west-2
           echo "S3 bucket stagebucket12 created"
         else
           echo "S3 bucket already exists"
         fi
     - name: Create DynamoDB table (if not exists)
       run: |
         if ! aws dynamodb describe-table --table-name terraform-lock >/dev/null 2>&1; then
           aws dynamodb create-table \
             --table-name terraform-lock \
             --attribute-definitions AttributeName=LockID,AttributeType=S \
             --key-schema AttributeName=LockID,KeyType=HASH \
             --billing-mode PAY_PER_REQUEST
           echo "DynamoDB table terraform-lock created"
         else
           echo "DynamoDB table already exists"
         fi