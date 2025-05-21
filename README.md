# cluster

## TODO

- Document properly
- Ensure firewall rules are up to date
- Review security posture
- Loadbalancer address Cloudflare
- Email routing Cloudflare

## Design

### Decisions

k3s script rather than using provider

- Provider would be tricky due to use of a private subnet & Bastion host
- Maintenance burden not large as not mission critical & config setup to allow for easy rebuilds

Cilium:

- Host network, single gateway exposed on port 1024 as it is not privileged
- Tried Nodeport but was too random & couldn't be controlled
- Didn't want to align too tightly with OCI loadbalancer

OCI Secret Vault

- Had to explicitly allow compute instances access
- This is useful as otherwise I end up in a paradox of needing to store credentials to be able to setup & be able to read credentials

Argo

- Auth with Github to save me somehow losing the password

Networking

- Single domain so wildcard & pass all requests through
- Cluster on private subnet
- Loadbalancer on public subnet

## Install

- Add necessary `.tfvars` (private key was generated here: https://cloud.oracle.com/identity/domains/my-profile/api-keys)
- Run `task apply-infra`
- Populate any secrets (this will involve prep work like creating a Github App)
- Run `task upgrade-all`
