# 🏗️ CI/CD Architecture

## Overview

This document describes the automated build and deployment pipeline for the Personal Expenses Flutter application.

## Workflow Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         GitHub Repository                        │
│                     (Personal Expenses App)                      │
└────────────┬────────────────────────────────────┬────────────────┘
             │                                    │
             │ Pull Request to Master             │ Manual Trigger
             ▼                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                     GitHub Actions Workflow                      │
│                  (build-and-deploy-appetize.yml)                 │
└────────────┬──────────────┬──────────────┬──────────┬───────────┘
             │              │              │          │
             │              │              │          │
    ┌────────▼─────┐ ┌─────▼─────┐ ┌─────▼────┐ ┌───▼──────┐
    │   Checkout   │ │   Setup   │ │  Build   │ │  Deploy  │
    │  Repository  │ │   Flutter │ │   APK    │ │   APK    │
    │              │ │  & Java   │ │          │ │          │
    └──────────────┘ └─────┬─────┘ └────┬─────┘ └────┬─────┘
                           │            │            │
                    ┌──────▼──────┐     │            │
                    │Cache Pub    │     │            │
                    │Dependencies │     │            │
                    └─────────────┘     │            │
                                        │            │
                                  ┌─────▼──────┐     │
                                  │   Upload   │     │
                                  │  Artifacts │     │
                                  │  (30 days) │     │
                                  └────────────┘     │
                                                     │
                                              ┌──────▼───────┐
                                              │ Appetize.io  │
                                              │   Hosting    │
                                              │ (Live Demo)  │
                                              └──────────────┘
```

## Pipeline Stages

### 1. **Trigger Events**
The workflow automatically runs on:
- **Pull Requests** targeting the `master` branch
- **Manual** workflow dispatch

### 2. **Environment Setup**
- **OS**: Ubuntu Latest
- **Java**: Version 17 (Zulu distribution) with Gradle caching
- **Flutter**: Version 3.35.6 (stable channel) with Flutter SDK caching
- **Pub Dependencies**: Cached based on pubspec.lock hash
- **Caching Strategy**: Multi-layer caching for Java, Flutter SDK, and Pub dependencies

### 3. **Build Process**

#### Step 3.1: Code Checkout
```yaml
- Uses: actions/checkout@v4
- Fetches the latest code from the repository
```

#### Step 3.2: Environment Configuration
```yaml
- Sets up Java 17 with Gradle caching
- Installs Flutter with intelligent caching
- Verifies installations
```

#### Step 3.3: Dependency Installation
```yaml
- Runs: flutter pub get
- Downloads all project dependencies
- Cached for faster subsequent builds
```

#### Step 3.4: APK Generation
```yaml
- Builds single release APK (not split by ABI)
- Creates universal binary compatible with all architectures
```

#### Step 3.5: Versioning
```yaml
- Extracts version from pubspec.yaml (format: X.Y.Z+BUILD)
- Version: The semver part (e.g., 1.0.0)
- Build Number: The number after + (e.g., 1)
- Renames APK: personal_expenses-X.Y.Z+BUILD.apk
```

### 4. **Artifact Management**
- **Upload**: Single universal APK
- **Naming**: `personal_expenses-X.Y.Z+BUILD` (e.g., personal_expenses-1.0.0+1)
- **File**: `personal_expenses-X.Y.Z+BUILD.apk`
- **Retention**: 30 days
- **Access**: Via GitHub Actions artifacts with direct download link using artifact ID
- **Direct Download**: Uses GitHub API to fetch artifact ID for one-click download links

### 5. **Deployment to Appetize.io**

#### Conditions:
- Runs on both `pull_request` events and `workflow_dispatch`
- Requires `APPETIZE_API_TOKEN` secret
- Optional `APPETIZE_PUBLIC_KEY` secret for app updates

#### Process:
1. **Check for existing app**: Determines if `APPETIZE_PUBLIC_KEY` secret exists
2. **First-time deployment** (if no public key exists):
   - Uploads APK to Appetize.io using Basic Authentication (`-u "token:"`)
   - Receives `publicKey` and `publicURL` from response
   - Displays warning to save public key for future updates
3. **Update existing app** (if public key exists):
   - Updates existing app using saved public key
   - Uses endpoint: `POST /v1/apps/{publicKey}`
   - Preserves app history and settings
4. **Deployment info aggregation**: Consolidates public key and URL from either path
5. **Generates shareable URL**: Creates live preview link from publicURL

### 6. **Notifications & Reporting**

#### Artifact ID Retrieval:
- Uses GitHub API to fetch artifact ID after upload
- Enables direct download links instead of just workflow page links

#### PR Comments:
- Automatic comment on pull requests
- Includes APK name with version
- Shows version and build number separately
- Direct download link to artifacts (using artifact ID for immediate download)
- Live preview URL from Appetize.io (using publicURL from API response)
- Clean, formatted deployment information

#### Workflow Summary:
- APK name with full version
- Version and build number breakdown
- Build information (branch, commit SHA)
- Direct download link for APK (with artifact ID)
- Deployment status with live preview URL (from publicURL)
- First-time deployment warning with instructions to save public key
- Step-by-step guide for adding APPETIZE_PUBLIC_KEY secret

## Security

### Secrets Required:
- `APPETIZE_API_TOKEN`: Token for Appetize.io deployment (required)
- `APPETIZE_PUBLIC_KEY`: Public key from first deployment (optional, for app updates)

### Token Setup:
1. **APPETIZE_API_TOKEN** (Required):
   - Create account on [Appetize.io](https://appetize.io)
   - Generate API token from account settings
   - Add to GitHub repository secrets:
     - Go to: Settings → Secrets and variables → Actions
     - Click "New repository secret"
     - Name: `APPETIZE_API_TOKEN`
     - Value: Your token

2. **APPETIZE_PUBLIC_KEY** (Optional, but recommended):
   - After first successful deployment, workflow will display the public key
   - Copy the public key from workflow summary
   - Add to GitHub repository secrets:
     - Go to: Settings → Secrets and variables → Actions
     - Click "New repository secret"
     - Name: `APPETIZE_PUBLIC_KEY`
     - Value: The public key from first deployment
   - **Purpose**: Enables app updates instead of creating new apps each time
   - **Without this**: Each deployment creates a new app instance

### Authentication Method:
- **API Authentication**: Uses Basic Authentication format (`-u "token:"`)
- **Not Bearer Token**: Appetize API requires Basic Auth, not `Authorization: Bearer`

## Performance Optimization

### Caching Strategy:
1. **Gradle Cache**: Java/Gradle dependencies cached by setup-java action
2. **Flutter SDK Cache**: Flutter SDK cached by subosito/flutter-action
3. **Pub Dependencies Cache**: Pub cache and .dart_tool cached based on pubspec.lock hash
4. **Build Cache**: Speeds up subsequent builds by 3-5x

### Cache Keys:
- **Gradle**: Managed automatically by setup-java
- **Flutter**: `flutter-:os:-:channel:-:version:-:arch:`
- **Pub**: `${{ runner.os }}-pub-${{ hashFiles('**/pubspec.lock') }}`

### Build Time:
- **First Build**: ~10-15 minutes (full dependency download)
- **Cached Build**: ~2-3 minutes (all caches hit)

## Output Artifacts

### APK File:
- **Name**: `personal_expenses-X.Y.Z+BUILD.apk` (e.g., `personal_expenses-1.0.0+1.apk`)
- **Type**: Universal APK (compatible with all Android architectures)
- **Format**: Single APK file, not split by ABI

### Artifact Upload:
- **Artifact Name**: `personal_expenses-X.Y.Z+BUILD` (e.g., `personal_expenses-1.0.0+1`)
- **Contains**: Single universal APK file

### Deployment:
- **Live Demo**: https://appetize.io/app/[PUBLIC_KEY]
- **Trigger**: On pull request to master branch
- **Duration**: Active as long as Appetize.io account is valid

## Monitoring & Debugging

### Workflow Status:
- View in GitHub Actions tab
- Check individual step logs
- Review build summary

### Common Issues:
1. **Build Failures**: Check Flutter/Java versions
2. **Deployment Failures**: 
   - Verify APPETIZE_API_TOKEN is set correctly
   - Check API authentication format (Basic Auth, not Bearer)
   - Review Appetize.io API response in workflow logs
3. **Cache Issues**: Clear cache and re-run (rarely needed with proper cache keys)
4. **Version Parsing**: Ensure pubspec.yaml has correct version format (X.Y.Z+BUILD)
5. **App Update Issues**: 
   - Ensure APPETIZE_PUBLIC_KEY is saved from first deployment
   - Verify public key matches the app you want to update
6. **Multiple App Instances**: Add APPETIZE_PUBLIC_KEY to prevent creating new apps

## Extensibility

### Adding New Features:
- **Code Signing**: Add keystore and signing config
- **Play Store Upload**: Integrate Google Play publishing
- **Firebase**: Add Firebase App Distribution
- **Notifications**: Add Slack/Discord webhooks
- **Multiple Environments**: Add staging/production configs

### Customization:
- Modify trigger branches (currently: pull_request to master)
- Adjust Flutter/Java versions
- Add custom build scripts
- Modify APK naming convention
- Add build flavors (debug, profile, release)

## Best Practices

1. **Version Bumping**: Update version in `pubspec.yaml` before creating PR (format: `X.Y.Z+BUILD`)
2. **Build Numbers**: Increment build number (+BUILD) for each release
3. **Secrets Management**: 
   - Never commit API tokens or keys
   - Save APPETIZE_PUBLIC_KEY after first deployment to enable app updates
   - Keep both APPETIZE_API_TOKEN and APPETIZE_PUBLIC_KEY in GitHub Secrets
4. **Documentation**: Update this file when workflow changes
5. **Monitoring**: Regularly check workflow runs for failures
6. **Cache Management**: Let GitHub manage cache invalidation automatically
7. **PR Reviews**: Check deployment preview before merging
8. **First Deployment**: 
   - Check workflow summary for public key
   - Add public key to secrets immediately
   - Subsequent deployments will update the same app

## Resources

- [Flutter CI/CD Documentation](https://docs.flutter.dev/deployment/cd)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Appetize.io API Documentation](https://docs.appetize.io/)
- [Flutter Build Modes](https://docs.flutter.dev/testing/build-modes)

---

**Last Updated**: October 2025  
**Maintained by**: [Your Name]
