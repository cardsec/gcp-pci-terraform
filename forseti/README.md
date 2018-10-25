## Installation
Set-up borrowed [from](https://github.com/terraform-google-modules/terraform-google-forseti)

### Service Account and Project set-up
Change into the helpers directory

Set up remote state in Cloud Storage
```
gsutil mb -p ${TF_ADMIN} gs://${TF_ADMIN}-forseti-helper

cat > backend.tf <<EOF
terraform {
 backend "gcs" {
   bucket  = "${TF_ADMIN}-forseti-helper"
   prefix  = "terraform/state"
   project = "${TF_ADMIN}-forseti-helper"
 }
}
EOF

gsutil versioning set on gs://${TF_ADMIN}-forseti-helper
```
Edit the ```vars.tf``` file with your account information

### run terraform
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

### Forseti Install
In the forseti directory

Set up remote state in Cloud Storage
```
gsutil mb -p ${TF_ADMIN} gs://${TF_ADMIN}-forseti

cat > backend.tf <<EOF
terraform {
 backend "gcs" {
   bucket  = "${TF_ADMIN}-forseti"
   prefix  = "terraform/state"
   project = "${TF_ADMIN}-forseti"
 }
}
EOF

gsutil versioning set on gs://${TF_ADMIN}-forseti-helper
```

Create and download the service account key for the forseti service account that was created in the helper directory.
```
gcloud iam service-accounts keys create key.json --iam-account foresti@forseti-[RANDOMNUMBER].iam.gserviceaccount.com
```

Edit the ```vars.tf``` file with your account information

### run terraform
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
