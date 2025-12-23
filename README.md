# cluster

## TODO

- Document properly
- Review security posture
- Loadbalancer address Cloudflare
- Email routing Cloudflare
- Migrate to Open Tofu rather than Terraform
- Switchover "portfolio" references to "production"
- Wait for webhook when installing external secrets & cert manager charts
- Better handling of 500 error when email is not verified
- Google login with Auth0 - set up for production
- DNS for connecting to MySQL server from Temporal

- Document process to manually create & import federated settings org config `terraform import module.mongodb.mongodbatlas_federated_settings_org_config.org_config [federated settings id]-[org id]` before being able to operate on it.

- Move Temporal (and any other relevant thing) into apps. 
- Ensure Argo chart will recursively find apps in apps & break things out into subdirectories.

## Design

### Decisions

k3s script rather than using provider

- Provider would be tricky due to use of a private subnet & Bastion host
- Maintenance burden not large as not mission critical & config setup to allow for easy rebuilds

Cilium:

- Tried Nodeport but was too random & couldn't be controlled
- Didn't want to align too tightly with OCI loadbalancer

OCI Secret Vault

- Had to explicitly allow compute instances access
- This is useful as otherwise I end up in a paradox of needing to store credentials to be able to setup & be able to read credentials

Argo

- Auth with Github to save me somehow losing the password
- Secrets must be uploaded as base64 but as plain text. Effectively double base64 encodes them but it won't work otherwise

Networking

- Single domain so wildcard & pass all requests through
- Cluster on private subnet
- Loadbalancer on public subnet

Artifact Registry

- Github Container Registry only has auth for individual, not Github Apps.
- Oracle Cloud only has auth for individuals too via access tokens. Can create other accounts to mimic service accounts but the plan is to then use their access tokens too which feels like a workaround.
- Docker Hub only allows for 1 free private repo in its free tier. Subscription tiers feel like they will cost more than other solutions.
- Familiarity with GCP & haven't had quibbles with it in the past. Aim will be to reduce the size of the container images.

If working with GCP for this, I might as well work with secrets & such for this too

MongoDB

- Attempted to use OIDC auth but only available on M10 clusters rather than free tier
- OIDC would be available on self hosted but wouldn't be able to control with Terraform & a lot more hassle
- x509 auth available but again, hassle compared to username & password, hence uname and password

## Download

```
git submodule init
git submodule update
```

## Install

- Add necessary `.tfvars` (private key was generated here: https://cloud.oracle.com/identity/domains/my-profile/api-keys)
- Run `terraform apply`
- Run `task merge-kube-config`
- Update secrets with output of `cat ~/.kube/config` (k3s_client_key, k3s_ca_certificate, k3s_client_certificate)
- Populate any other secrets (this will involve prep work like creating a Github App)
- Run `task upgrade-all`
- From Argo, enable auto sync on Identity app & run the cron job to create the secret
- Enable auto sync on the other applications
