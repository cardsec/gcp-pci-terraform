/******************************************
   Forseti Module Install
  *****************************************/
 module "forseti-install-simple" {
   source                       = "github.com/terraform-google-modules/terraform-google-forseti"
   gsuite_admin_email           = "susan@girlsgonewildwood.com"
   project_id                   = "${google_project.forseti.project_id}"
   download_forseti             = "true"
   forseti_repo_branch          = "dev"
   notification_recipient_email = "ann@girlsgonewildwood.com"
   #credentials_file_path        = "${base64decode(google_service_account_key.forseti.private_key)}"
   credentials_file_path        = "/tmp/forseti.json"
 }
