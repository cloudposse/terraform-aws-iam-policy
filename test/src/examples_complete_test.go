package test

import (
	"math/rand"
	"strconv"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

// Test the Terraform module in examples/complete using Terratest.
func TestExamplesComplete(t *testing.T) {
	t.Parallel()

	rand.Seed(time.Now().UnixNano())
	randID := strconv.Itoa(rand.Intn(100000))
	attributes := []string{randID}

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
		// We always include a random attribute so that parallel tests
		// and AWS resources do not interfere with each other
		Vars: map[string]interface{}{
			"attributes": attributes,
		},
	}
	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	jsonPolicy := terraform.OutputRequired(t, terraformOptions, "json")
	oldJsonPolicy := terraform.OutputRequired(t, terraformOptions, "json")

	// Verify we're getting back the outputs we expect
	assert.Greater(t, len(jsonPolicy), 0)
	assert.Greater(t, len(oldJsonPolicy), 0)
	assert.Equal(t, jsonPolicy, oldJsonPolicy, "jsonPolicy and oldJsonPolicy should match")

	expectedPolicy := "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"s3:ListBucket\",\n        \"s3:GetBucketAcl\"\n      ],\n      \"Resource\": [\n        \"arn:aws:s3:::${BucketName}\"\n      ]\n    },\n    {\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"s3:GetObject\",\n        \"s3:GetBucketAcl\"\n      ],\n      \"Resource\": [\n        \"arn:aws:s3:::${BucketName}/*\"\n      ]\n    },\n    {\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"kms:Decrypt\",\n        \"kms:GenerateDataKey\"\n      ],\n      \"Resource\": [\n        \"arn:aws:kms:::key/*\"\n      ],\n      \"Condition\": {\n        \"ForAllValues:StringLike\": {\n          \"kms:EncryptionContext:aws:s3:arn\": [\n            \"arn:aws:s3:::${BucketName}\"\n          ],\n          \"kms:ViaService\": [\n            \"s3.${Region}.amazonaws.com\"\n          ]\n        }\n      }\n    },\n    {\n      \"Sid\": \"ListMyBucket\",\n      \"Effect\": \"Allow\",\n      \"Action\": \"s3:ListBucket\",\n      \"Resource\": \"arn:aws:s3:::test\",\n      \"Condition\": {\n        \"StringLike\": {\n          \"cloudwatch:namespace\": \"x-*\"\n        }\n      }\n    },\n    {\n      \"Sid\": \"WriteMyBucket\",\n      \"Effect\": \"Allow\",\n      \"Action\": [\n        \"s3:PutObject\",\n        \"s3:GetObject\",\n        \"s3:DeleteObject\"\n      ],\n      \"Resource\": \"arn:aws:s3:::test/*\",\n      \"Condition\": {\n        \"StringLike\": {\n          \"cloudwatch:namespace\": \"x-*\"\n        }\n      }\n    }\n  ]\n}"
	assert.Equal(t, expectedPolicy, jsonPolicy, "jsonPolicy should match expected policy")
}
