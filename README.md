# Azure VNet with VNet Flow Logs - Terraform Configuration

This Terraform configuration creates a complete Azure setup with:
- Virtual Network (VNet) with VNet Flow Logs enabled
- Custom storage account for flow logs with 2-day retention
- Linux VM with public IP
- Log Analytics Workspace for Traffic Analytics

## Prerequisites

1. **Azure CLI** installed and configured
   ```bash
   az login
   ```

2. **Terraform** installed (version 1.0 or later)
   ```bash
   terraform version
   ```

3. **SSH Key Pair** for VM access
   ```bash
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/azure_vm_key
   ```

## Quick Start

### 1. Clone or download these files

Ensure you have all the following files:
- `main.tf`
- `variables.tf`
- `outputs.tf`
- `terraform.tfvars.example`

### 2. Configure variables

Copy the example file and customize it:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and add your SSH public key:
```hcl
ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2E... your-email@example.com"
```

To get your public key:
```bash
cat ~/.ssh/azure_vm_key.pub
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review the plan

```bash
terraform plan
```

### 5. Deploy

```bash
terraform apply
```

Type `yes` when prompted to confirm.

## What Gets Created

| Resource | Description |
|----------|-------------|
| Resource Group | Container for all resources |
| Virtual Network | 10.0.0.0/16 address space with VNet Flow Logs |
| Subnet | 10.0.1.0/24 subnet |
| Storage Account | For VNet flow logs with 2-day retention |
| Network Watcher | Uses existing one (Azure auto-creates per region) |
| NSG | Network security group with SSH rule |
| VNet Flow Logs | Virtual Network flow logs to storage account |
| Log Analytics | For Traffic Analytics (optional but included) |
| Public IP | Static public IP for VM |
| Network Interface | NIC for the VM |
| Linux VM | Ubuntu 22.04 LTS VM |

## Accessing Your VM

After deployment, Terraform will output the SSH command:

```bash
ssh azureuser@<PUBLIC_IP>
```

Or use the private key you specified:
```bash
ssh -i ~/.ssh/azure_vm_key azureuser@<PUBLIC_IP>
```

## Viewing Flow Logs

### Via Azure Portal
1. Navigate to your Storage Account
2. Go to "Containers" → "insights-logs-flowlogflowevent"
3. Browse the JSON files by date/time

### Via Azure CLI
```bash
# List flow log files
az storage blob list \
  --account-name <storage-account-name> \
  --container-name insights-logs-flowlogflowevent \
  --output table

# Download a specific log file
az storage blob download \
  --account-name <storage-account-name> \
  --container-name insights-logs-flowlogflowevent \
  --name <blob-name> \
  --file flowlog.json
```

## Configuration Details

### Flow Logs Retention
- **Storage retention**: 2 days (configured in storage account blob properties)
- **Flow logs retention**: 2 days (configured in flow log resource)

### Traffic Analytics
- **Enabled**: Yes (with 10-minute intervals)
- **Log Analytics retention**: 30 days

To disable Traffic Analytics, remove or comment out the `traffic_analytics` block in `main.tf`.

## Customization

### Change VM Size
Edit `terraform.tfvars`:
```hcl
vm_size = "Standard_D2s_v3"  # or any other size
```

### Change Region
Edit `terraform.tfvars`:
```hcl
location = "eastus"  # or any Azure region
```

### Change Network Configuration
Edit `main.tf` to modify:
- VNet address space (default: 10.0.0.0/16)
- Subnet address prefix (default: 10.0.1.0/24)

### Add More NSG Rules
Add additional `security_rule` blocks in the `azurerm_network_security_group` resource.

## Cost Considerations

This setup incurs costs for:
- Virtual Machine (depends on size)
- Public IP (static)
- Storage Account (minimal for flow logs)
- Log Analytics Workspace (per GB ingested)
- Network Watcher (flow logs processing)

Approximate monthly cost: $30-50 USD for the default configuration.

## Cleanup

To destroy all resources:
```bash
terraform destroy
```

Type `yes` when prompted.

## Troubleshooting

### Storage account name already exists
Storage account names must be globally unique. If you get an error, change the name in `variables.tf` or let the random suffix handle it.

### Network Watcher already exists
The configuration now uses the existing Network Watcher in your subscription automatically via a data source. Azure creates one Network Watcher per region automatically, and the configuration will find and use it.

### SSH connection refused
- Ensure the NSG allows SSH from your IP
- Verify the VM has started successfully
- Check that you're using the correct SSH key

## Security Notes

⚠️ **Important Security Considerations:**

1. **SSH Access**: The default NSG rule allows SSH from any source IP. In production, restrict this to specific IPs:
   ```hcl
   source_address_prefix = "YOUR_IP/32"
   ```

2. **SSH Keys**: Never commit private keys to version control. Keep them secure.

3. **Storage Account**: Flow logs may contain sensitive network information. Ensure proper access controls.

4. **Admin Credentials**: Use strong SSH keys and consider disabling password authentication.

## Additional Resources

- [Azure VNet Flow Logs Documentation](https://learn.microsoft.com/azure/network-watcher/vnet-flow-logs-overview)
- [Terraform AzureRM Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Network Watcher](https://learn.microsoft.com/azure/network-watcher/network-watcher-monitoring-overview)
