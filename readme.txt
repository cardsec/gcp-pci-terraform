

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

Or the one liner:
$gcloud alpha resource-manager liens list --project pci-84f5a5b09bf5e045 |  gcloud alpha resource-manager liens delete `awk 'FNR == 2 {print $1}'` --project pci-84f5a5b09bf5e045

#If you get:
The project cannot be created because you have exceeded your allotted project quota.

You will need to create an new service account or increase your limits
