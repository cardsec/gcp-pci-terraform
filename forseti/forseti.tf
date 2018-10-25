/******************************************
   Forseti Module Install
  *****************************************/
 module "forseti-install-simple" {
   source                       = "github.com/terraform-google-modules/terraform-google-forseti"
   gsuite_admin_email           = "anners@google.com"
   project_id                   = "forseti-2ba6de973e226990"
   download_forseti             = "true"
   forseti_repo_branch          = "dev"
   notification_recipient_email = "anners@google.com"
   #credentials_file_path        = "${base64decode(google_service_account_key.forseti.private_key)}"
   credentials_file_path        = "/tmp/key.json"
 }
