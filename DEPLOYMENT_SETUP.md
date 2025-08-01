# dbt CI/CD Deployment Setup Guide

This guide explains how to set up automated dbt deployment using GitHub Actions for your Azure environment.

## 🏗️ Architecture Overview

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Pull Request  │───▶│   CI Pipeline    │───▶│   Code Review   │
│                 │    │  (Tests & Lint)  │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                         │
                                                         ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Staging DB    │◀───│ Staging Deploy   │◀───│  Merge to       │
│                 │    │  (Auto)          │    │  staging branch │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                                         │
                                                         ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│  Production DB  │◀───│ Production Deploy│◀───│  Merge to       │
│                 │    │ (Manual Approval)│    │  main branch    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 🚀 Workflows Created

1. **CI Pipeline** (`.github/workflows/ci.yml`)
   - Triggers: Pull requests to `main` or `staging`
   - Actions: Tests, compilation, validation

2. **Staging Deployment** (`.github/workflows/deploy-staging.yml`)
   - Triggers: Push to `staging` branch
   - Actions: Deploy to staging database automatically

3. **Production Deployment** (`.github/workflows/deploy-production.yml`)
   - Triggers: Push to `main` branch
   - Actions: Deploy to production database (with manual approval)

## ⚙️ Setup Instructions

### Step 1: Configure GitHub Secrets

Go to your GitHub repository → Settings → Secrets and variables → Actions

Add these secrets for **CI/Testing**:
```
DBT_SERVER=your-dev-server.database.windows.net
DBT_DATABASE=your_dev_database
DBT_SCHEMA=dbt_dev
DBT_USER=your_dev_user
DBT_PASSWORD=your_dev_password
```

Add these secrets for **Staging**:
```
DBT_STAGING_SERVER=your-staging-server.database.windows.net
DBT_STAGING_DATABASE=your_staging_database
DBT_STAGING_SCHEMA=dbt_staging
DBT_STAGING_USER=your_staging_user
DBT_STAGING_PASSWORD=your_staging_password
```

Add these secrets for **Production**:
```
DBT_PROD_SERVER=your-prod-server.database.windows.net
DBT_PROD_DATABASE=your_prod_database
DBT_PROD_SCHEMA=dbt_prod
DBT_PROD_USER=your_prod_user
DBT_PROD_PASSWORD=your_prod_password
```

### Step 2: Set Up GitHub Environments

1. Go to Settings → Environments
2. Create two environments:
   - `staging` (no protection rules needed)
   - `production` (add protection rules)

For the **production** environment:
- ✅ Required reviewers: Add yourself and team members
- ✅ Wait timer: 0 minutes (or set a delay if needed)
- ✅ Deployment branches: Only `main` branch

### Step 3: Create Branch Structure

```bash
# Create staging branch
git checkout -b staging
git push -u origin staging

# Go back to main
git checkout main
```

### Step 4: Update dbt_project.yml (if needed)

Ensure your `dbt_project.yml` supports multiple targets:

```yaml
name: 'adrez_poc'
version: '1.0.0'
config-version: 2

profile: 'adrez_poc'

# Model paths
model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

target-path: "target"
clean-targets:
  - "target"
  - "dbt_packages"

models:
  adrez_poc:
    +materialized: table
```

## 🔄 Deployment Workflow

### For Development/Testing:
1. Create feature branch: `git checkout -b feature/new-model`
2. Make changes to dbt models
3. Create Pull Request to `staging` branch
4. CI pipeline runs automatically (tests, compilation)
5. After review, merge to `staging`

### For Staging Deployment:
1. Merge PR to `staging` branch
2. Staging deployment runs automatically
3. Verify changes in staging database

### For Production Deployment:
1. Create PR from `staging` to `main`
2. Review and merge to `main` branch
3. Production deployment workflow starts
4. **Manual approval required** - check GitHub Actions tab
5. Approve deployment to proceed
6. Models deployed to production

## 📋 What Each Workflow Does

### CI Pipeline:
- ✅ Installs dbt and dependencies
- ✅ Creates profiles.yml with dev credentials
- ✅ Runs `dbt deps` to install packages
- ✅ Runs `dbt debug` to test connection
- ✅ Runs `dbt compile` to check SQL syntax
- ✅ Runs `dbt test` to validate data quality

### Staging Deployment:
- 🚀 Runs full dbt pipeline: `seed` → `run` → `test`
- 📊 Generates documentation
- 🔄 Deploys to staging database automatically

### Production Deployment:
- ⏸️ Waits for manual approval
- 🚀 Runs full dbt pipeline: `seed` → `run` → `test`
- 📊 Generates documentation
- 🎯 Deploys to production database

## 🛠️ Troubleshooting

### Common Issues:

1. **Connection Errors**
   - Check your database secrets are correct
   - Ensure firewall allows GitHub Actions IPs
   - Verify SQL Server is accessible from internet

2. **dbt Compilation Errors**
   - Check SQL syntax in your models
   - Ensure all referenced tables/models exist
   - Verify schema names match your configuration

3. **Permission Errors**
   - Ensure database user has CREATE/DROP permissions
   - Check schema permissions for dbt user
   - Verify user can create tables in target schema

### Debug Commands:

```bash
# Test locally before pushing
dbt debug --target staging
dbt compile --target staging
dbt run --target staging --dry-run
```

## 🔐 Security Best Practices

1. **Never commit credentials** to the repository
2. **Use separate databases** for dev/staging/prod
3. **Limit database permissions** for each environment
4. **Enable manual approval** for production deployments
5. **Regular credential rotation** in GitHub secrets

## 📈 Next Steps

Once this is working, you can enhance with:
- Slack notifications for deployment status
- Azure Storage for dbt documentation hosting
- More sophisticated testing strategies
- Rollback procedures
- Environment-specific configurations

## 🆘 Support

If you encounter issues:
1. Check the GitHub Actions logs in the Actions tab
2. Verify all secrets are correctly configured
3. Test database connections manually
4. Review dbt logs for specific error messages 