#!/bin/bash

# Takes a single parameter input
#
# 1. We create a user.
# 2. Then add user to group that is allowed to list buckets, nothing more.
# 3. Then we build the bucket.
# 4. Set bucket policy so it's changeable by the newly created user.
# 5. Finally we need to create an access token for the user.
BUCKETNAME=$1

./create-aws-user-and-key.sh $BUCKETNAME

# Create a bucket in Ireland, because Craft2 S3 functionality needs a little
# older authentication scheme only found in certain AWS data centers.
aws s3api create-bucket --bucket $BUCKETNAME --region eu-west-1 \
  --create-bucket-configuration LocationConstraint=eu-west-1
# Finally we add versioning because it's quite unpleasant to lose important data.
aws s3api put-bucket-versioning --bucket $BUCKETNAME \
  --versioning-configuration Status=Enabled

./give-user-access-to-bucket.sh $BUCKETNAME
