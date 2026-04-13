# TravelMemory Automation Runbook

This guide documents the exact next steps after configuration is done.

## 1. Prepare Terraform Variables

1. Copy `terraform/terraform.tfvars.example` to `terraform/terraform.tfvars`.
2. Update at least these values:
   - `allowed_ssh_cidr` = your public IP in `/32` format
   - `key_pair_name` = your existing EC2 key pair

## 2. Provision AWS Infrastructure

Run from the `terraform` directory:

```powershell
terraform init
terraform validate
terraform plan
terraform apply
```

## 3. Capture Terraform Outputs

```powershell
terraform output
```

Record:

- `web_instance_public_ip`
- `db_instance_private_ip`

## 4. Configure Ansible Inventory

Edit `ansible/inventory.ini` and set:

- `web-server ansible_host` = `web_instance_public_ip`
- `db-server ansible_host` = `db_instance_private_ip`
- `ansible_ssh_common_args` ProxyJump host = `web_instance_public_ip`
- `ansible_ssh_private_key_file` = your `.pem` path

## 5. Set MongoDB Credentials

Edit `ansible/group_vars/all.yml`:

- `mongo_app_password`
- `mongo_admin_password`

Use strong passwords before deployment.

## 6. Run Ansible Deployment

Run from the `ansible` directory:

```powershell
ansible-playbook -i inventory.ini site.yml
```

## 7. Validate Application

1. Open: `http://<web_instance_public_ip>`
2. Check API health: `http://<web_instance_public_ip>/api/hello`

## 8. Prepare Submission Artifacts

1. Update `submission/repository-link.txt` with your final GitHub repository URL.
2. Capture screenshots or video of:
   - Terraform apply success
   - Ansible play recap
   - Frontend page running
   - Backend API response

## Optional Cleanup

To remove infrastructure after demo/submission:

```powershell
terraform destroy
```
