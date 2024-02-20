### **Overview**

This terragrunt code lets you create standard GKE Cluster along with additional resources.

### **Before proceeding**
Make sure you have changed backend bucket in root terragrunt.hcl and specified your project id in *dev/common.hcl*. Also make sure you have created service account with all the necessary permissions and generated service account keys. Also don't forget to check if you have enabled Resource Manager and GKE APIs in Google Cloud Platform.

### **Getting Started**

First things first, build toolkit image for quick start. It simply installs all the necessary tools. Then run the container and open bash session:

```bash
docker build -t gke-standard -f ./Dockerfile.toolkit .
docker run -it --name gke-standard gke-standard bash
```

Then create */terraform/key.json* and pass the content of service account json key file. Then you can export GOOGLE_APPLICATION_CREDENTIALS environment variable and navigate to *dev/* directory:

```bash
export GOOGLE_APPLICATION_CREDENTIALS=/terraform/key.json
cd dev
```

Run following commands to initialize terraform modules, check and then apply changes:

```bash
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply
```

That's it, your cluster will be created in a few minutes. You can get kubeconfig using *gcloud*:

```bash
gcloud container clusters get-credentials CLUSTER_NAME
```

### **Additional Resources Created**
- VPC
- Subnet with two secondary ranges
- External address
- Cloud Nat
- Service account for nodes in node pool