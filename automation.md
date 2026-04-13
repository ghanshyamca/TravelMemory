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
<img width="1527" height="405" alt="image" src="https://github.com/user-attachments/assets/6da816a8-8254-4b33-a6a7-eb488f84f969" />
<img width="1885" height="936" alt="image" src="https://github.com/user-attachments/assets/2085a37a-2905-4e56-8837-bc2015cc58c3" />
<img width="1866" height="779" alt="image" src="https://github.com/user-attachments/assets/dac5a687-c73f-4e14-a5b2-f2b09354e605" />
<img width="1919" height="940" alt="image" src="https://github.com/user-attachments/assets/5f77062a-96d8-4a18-9d99-a72ffa40c805" />
<img width="1919" height="988" alt="image" src="https://github.com/user-attachments/assets/2e472ad3-af09-42e1-a41b-4a5dd4dbca30" />
<img width="1919" height="873" alt="image" src="https://github.com/user-attachments/assets/01917791-3080-41e1-ba50-472ead7ef734" />


## 3. Capture Terraform Outputs

```powershell
terraform output
```
<img width="1919" height="170" alt="image" src="https://github.com/user-attachments/assets/c9f43e34-8a2f-4710-9ca8-de0e15f7ec6f" />

Record:

- `web_instance_public_ip`
- `db_instance_private_ip`

## EC2 Instances Screenshot
<img width="1616" height="126" alt="image" src="https://github.com/user-attachments/assets/4f0eae3a-5329-40b1-97fe-8e43f638d6c7" />


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

<img width="1845" height="970" alt="image" src="https://github.com/user-attachments/assets/d6033c5d-c13d-4c50-a267-05ba2c02c5fe" />
<img width="1916" height="811" alt="image" src="https://github.com/user-attachments/assets/0298a73b-ab5f-4794-9bbc-1b919b3f1599" />


## 7. Validate Application

1. Open: `http://54.177.219.251/`
2. Check API health: `http://54.177.219.251/api/hello`

<img width="1920" height="1180" alt="image" src="https://github.com/user-attachments/assets/0edf327f-1754-41d1-907b-6e842ac93c0d" />


## Optional Cleanup

To remove infrastructure

```powershell
terraform destroy
```
