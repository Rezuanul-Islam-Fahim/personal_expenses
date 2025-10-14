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
- **Access**: Via GitHub Actions artifacts with direct download link

### 5. **Deployment to Appetize.io**

#### Conditions:
- Only on `pull_request` events
- Requires `APPETIZE_API_TOKEN` secret

#### Process:
1. Selects the universal release APK
2. Uploads to Appetize.io via API (supports first-time deployment and updates)
3. Receives public key for the deployed app
4. Generates shareable URL
5. Handles both new app creation and existing app updates

### 6. **Notifications & Reporting**

#### PR Comments:
- Automatic comment on pull requests
- Includes APK name with version
- Shows version and build number separately
- Direct download link to artifacts
- Live preview URL from Appetize.io

#### Workflow Summary:
- APK name with full version
- Version and build number breakdown
- Build information
- Direct download link for APK
- Deployment status with live preview URL
- Artifact links

## Security

### Secrets Required:
- `APPETIZE_API_TOKEN`: Token for Appetize.io deployment (optional)

### Token Setup:
1. Create account on [Appetize.io](https://appetize.io)
2. Generate API token from account settings
3. Add to GitHub repository secrets:
   - Go to: Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `APPETIZE_API_TOKEN`
   - Value: Your token

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
2. **Deployment Failures**: Verify APPETIZE_API_TOKEN
3. **Cache Issues**: Clear cache and re-run (rarely needed with proper cache keys)
4. **Version Parsing**: Ensure pubspec.yaml has correct version format (X.Y.Z+BUILD)

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
3. **Secrets**: Never commit API tokens or keys
4. **Documentation**: Update this file when workflow changes
5. **Monitoring**: Regularly check workflow runs for failures
6. **Cache Management**: Let GitHub manage cache invalidation automatically
7. **PR Reviews**: Check deployment preview before merging

## Resources

- [Flutter CI/CD Documentation](https://docs.flutter.dev/deployment/cd)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Appetize.io API Documentation](https://docs.appetize.io/)
- [Flutter Build Modes](https://docs.flutter.dev/testing/build-modes)

---

**Last Updated**: October 2025  
**Maintained by**: [Your Name]
