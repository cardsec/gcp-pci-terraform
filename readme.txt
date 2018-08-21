#set up is borrowed from https://cloud.google.com/community/tutorials/managing-gcp-projects-with-terraform

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/resourcemanager.projectCreator

gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/billing.admin

#sharedVPC
  gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/compute.xpnAdmin


  removing liens on shared vpcs
  https://cloud.google.com/vpc/docs/deprovisioning-shared-vpc#disable_host_project

#If you get:
google_project.nonpci_shared (destroy): 1 error(s) occurred:

* google_project.nonpci_shared: Error deleting project "project-name": googleapi: Error 400: A lien to prevent deletion was placed on the project by [xpn.googleapis.com]. Remove the lien to allow deletion., failedPrecondition

Then run:
$ gcloud alpha resource-manager liens list --project nonpci-a556d36d53435f23
NAME                                                 ORIGIN              REASON
p673528304634-ld4b476ac-5ab3-4021-825b-7d56ed09ecf3  xpn.googleapis.com  This lien is added to prevent the deletion of this shared VPC host project. This project should be disabled as a shared VPC host before it is deleted, otherwise it can cause networking outages in attached service projects.

$ gcloud alpha resource-manager liens delete p673528304634-ld4b476ac-5ab3-4021-825b-7d56ed09ecf3 --project nonpci-a556d36d53435f23
Deleted [liens/p673528304634-ld4b476ac-5ab3-4021-825b-7d56ed09ecf3].

#If you get:
The project cannot be created because you have exceeded your allotted project quota.

You will need to create an new service account or increase your limits

$ export TF_ADMIN=x-${USER}-terraform-admin
$ gcloud projects create ${TF_ADMIN} \
  --organization ${TF_VAR_org_id} \
  --set-as-default
$ gcloud beta billing projects link ${TF_ADMIN} \
  --billing-account ${TF_VAR_billing_account}

$ gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"

$ gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform@${TF_ADMIN}.iam.gserviceaccount.com

$ gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/viewer

$ gcloud projects add-iam-policy-binding ${TF_ADMIN} \
  --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
  --role roles/storage.admin

  gcloud services enable cloudresourcemanager.googleapis.com
  gcloud services enable cloudbilling.googleapis.com
  gcloud services enable iam.googleapis.com
  gcloud services enable compute.googleapis.com


  gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
    --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
    --role roles/resourcemanager.projectCreator

  gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
    --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
    --role roles/billing.admin

  #sharedVPC
    gcloud organizations add-iam-policy-binding ${TF_VAR_org_id} \
    --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com \
    --role roles/compute.xpnAdmin

  #cloudSQL
  gcloud organizations add-iam-policy-binding ${TF_VAR_org_id}     --member serviceAccount:terraform@${TF_ADMIN}.iam.gserviceaccount.com     --role roles/cloudsql.admin

    gsutil mb -p ${TF_ADMIN} gs://${TF_ADMIN}

    cat > backend.tf <<EOF
    terraform {
     backend "gcs" {
       bucket  = "${TF_ADMIN}"
       path    = "/terraform.tfstate"
       project = "${TF_ADMIN}"
     }
    }
    EOF

$ gsutil versioning set on gs://${TF_ADMIN}

$ export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}
$ export GOOGLE_PROJECT=${TF_ADMIN}
