# CI/CD Pipeline for Spring Boot Application

This repository utilizes a **sophisticated CI/CD pipeline powered by GitHub Actions** to automate the testing, building, and deployment of the Spring Boot application across two main environments: **Staging** and **Production**.

The pipeline is split into two primary paths:

- **Main Branch (Release Path)** – Handles official, versioned releases (CI, Build, Artifact Storage).
- **Feature/Development Branches (Snapshot Path)** – Provides pre-release builds for testing and manual deployment to Staging/Production for validation.

---

## 🚀 Workflows Overview

| File                              | Name                       | Trigger                     | Target Environment | Key Functionality                                                                                                                                                   |
|-----------------------------------|----------------------------|-----------------------------|-------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `continuous-integration.yml`      | Continuous Integration     | Push to **main** branch     | Artifact Storage (S3) | Runs tests, determines the next version using Semantic Release, builds the final production-ready JAR, and uploads it to S3.                                          |
| `branch-build.yml`                | Branch CI                  | Push to any non-main branch | Artifact Storage (S3) | Runs tests, builds a snapshot JAR tagged with the branch name, and uploads it to S3. **Note:** Only runs if the last commit message contains `run build`.             |
| `staging-continuous-delivery.yml` | Manually Deploy to Staging | `workflow_dispatch` (Manual)| Staging            | Deploys the latest official release artifact from S3 to the Staging ASG.                                                                                             |
| `continuous-delivery.yml`         | Manually Deploy to Production | `workflow_dispatch` (Manual) | Production        | Deploys the latest official release artifact from S3 to the Production ASG. Includes automatic rollback on deployment failure.                                        |
| `staging-branch-deploy.yml`       | Branch Deploy for Staging  | `workflow_dispatch` (Manual)| Staging            | Deploys a specific feature branch build (snapshot) to the Staging ASG.                                                                                               |
| `branch-deploy.yml`               | Branch Deploy for Production | `workflow_dispatch` (Manual) | Production        | Deploys a specific feature branch build (snapshot) to the Production ASG. **Use with extreme caution.**                                                              |
| `rollback-to-previous-version.yml`| Rollback to Previous Version | `workflow_dispatch` (Manual) | Production        | Immediately rolls back the Production environment to the second-last successfully deployed version.                                                                   |

---

## 🛠️ Deployment Strategy – ASG Rolling Update

All deployment workflows (`*-deploy.yml`, `continuous-delivery.yml`, `rollback-to-previous-version.yml`) implement a **rolling update strategy** using **AWS Auto Scaling Groups (ASG)** and **User Data** configuration.

The general deployment sequence involves:

1. Retrieve the target application JAR version from S3.  
2. Fetch the current and previous deployment versions.  
3. Update the ASG's Launch Configuration/Template to point to the new application version.  
4. Increment the ASG's desired capacity to trigger a rolling replacement of instances.  
5. Wait for the new instances to pass health checks (e.g., Load Balancer Target Group health checks).  
6. Decrease the ASG's desired capacity back to the original value, phasing out the old instances.

---

## 🛡️ Automatic Rollback

The production deployment workflows (`continuous-delivery.yml`, `branch-deploy.yml`) are configured to attempt a rollback to the previous working version **if the health checks fail after the ASG update**.  
If the rollback itself fails, a detailed failure report is generated.

---

## 📧 Failure Notification Mechanism

If a deployment or rollback job targeting the Production environment fails health checks, a dedicated email notification is sent using the **[gautamkrishnar/awesome-action-mailer](https://github.com/gautamkrishnar/awesome-action-mailer)** GitHub Action.

The email includes:

- A descriptive subject (e.g., `Deployment Failure & Rollback - [Repository Name]`)
- Details about the failure
- The status of the automatic rollback attempt
- Manual cleanup instructions for the ASG in case automated rollback or cleanup steps could not fully resolve the capacity issue
- A direct link to the failed GitHub Actions workflow run

---

## 📝 Usage Guide

### 1️⃣ Releasing a New Version (Push to main)

1. Merge your feature branch into the **main** branch.  
2. The `continuous-integration.yml` workflow will automatically run.  
3. Based on your commit messages (following the [Conventional Commits](https://www.conventionalcommits.org/) specification), **Semantic Release** will automatically:
   - Determine the new version (e.g., `v1.0.0`)
   - Create a new Git Tag and GitHub Release
   - Build the application and upload the artifact to S3.

### 2️⃣ Manual Deployment of a Release (CD)

Once a new release is available (step 1 complete):

1. Navigate to the **Actions** tab in GitHub.  
2. Select either **Manually Deploy to Staging** or **Manually Deploy to Production**.  
3. Click **Run workflow**.

### 3️⃣ Testing a Feature Branch (Snapshot Deployment)

1. Ensure your last commit on the feature branch contains the phrase **`run build`** in the commit message. This triggers the `branch-build.yml` CI.  
2. Navigate to the **Actions** tab in GitHub.  
3. Select **Branch Deploy for Staging**.  
4. Click **Run workflow** and provide the exact branch name (e.g., `feature/new-login`).

### 4️⃣ Emergency Rollback

In case of a production issue:

1. Navigate to the **Actions** tab in GitHub.  
2. Select **Rollback to Previous Version for Production**.  
3. Click **Run workflow**. This will instantly attempt to deploy the version that was live before the current version.

---

## ⚙️ Required Repository Secrets

Ensure these are set in your repository settings (**Settings → Secrets and variables → Actions**):

| Secret Name           | Purpose                                        | Scope (Environments)          |
|-----------------------|------------------------------------------------|--------------------------------|
| `AWS_ACCESS_KEY_ID`   | AWS Key for Production deployment.             | Production                    |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret for Production deployment.        | Production                    |
| `AWS_REGION`          | AWS Region for Production resources.           | Production                    |
| `STAGING_AWS_REGION`  | AWS Region for Staging resources.              | Staging                       |
| `RELEASE_ARTIFACT_BUCKET` | The S3 bucket name where built JARs are stored. | Global                    |
| `ASG_NAME`            | Name of the Production Auto Scaling Group.     | Production                    |
| `STAGING_ASG_NAME`    | Name of the Staging Auto Scaling Group.        | Staging                       |
| `GITHUB_TOKEN`        | Provided by GitHub; required for Semantic Release and API calls. | Global |
| `MAIL_USERNAME`       | SMTP username for sending failure emails.      | Global (for Prod failure notifications) |
| `MAIL_PASSWORD`       | SMTP password for sending failure emails.      | Global (for Prod failure notifications) |
| `MAIL_SERVER`         | SMTP server hostname (e.g., `smtp.gmail.com`). | Global (for Prod failure notifications) |
| `MAIL_PORT`           | SMTP server port (e.g., `465` for SSL).        | Global (for Prod failure notifications) |
| `MAIL_TO`             | Comma-separated list of recipient emails.      | Global (for Prod failure notifications) |

---

**Happy Deploying! 🚀**
