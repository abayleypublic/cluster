# cluster

**Populate properly later**

## Design

### Decisions

Using k3s script install instead of a Terraform provider because...

Using Loadbalancer of IP 10.0.64.50 as Cilium Gateway

## Install

- Add necessary `.tfvars` (private key was generated here: https://cloud.oracle.com/identity/domains/my-profile/api-keys)
- Run `task apply-infra`
- Populate any secrets (this will involve prep work like creating a Github App)
- Run `task upgrade-all`
