# Git Workflow - Branch Setup & Pull Request

## Quick Start

### Option 1: Using Command Line (Git Bash or Terminal)

```bash
# 1. Navigate to project directory
cd "c:\Users\Johnd\OneDrive\Desktop\Com_Prog-grouptask\grouptask4\Grouptask4-project-data\Grouptask4-Feature4\BrewEase_-_Reward"

# 2. Initialize git if not already initialized
git init

# 3. Configure git (one-time setup)
git config user.email "your-email@example.com"
git config user.name "Your Name"

# 4. Stage all changes
git add -A

# 5. Create initial commit on main/master
git commit -m "Initial commit: Add provider files and documentation"

# 6. Create a new feature branch
git checkout -b fix/provider-compilation-errors

# 7. View the branch
git branch -a

# 8. Push to remote (if you have a remote configured)
git push origin fix/provider-compilation-errors

# 9. Create pull request on GitHub/GitLab web interface
```

### Option 2: Using GitHub Desktop (if installed)

1. Open GitHub Desktop
2. Click "File" → "Add Local Repository"
3. Select your project folder
4. Click "Publish repository" to add it to GitHub
5. Click "Create Branch" button
6. Name it: `fix/provider-compilation-errors`
7. Make sure "Based on" is set to your default branch
8. Click "Publish branch"
9. Go to GitHub website and create a Pull Request

### Option 3: Using VS Code Git Integration

1. Open the project in VS Code
2. Open the Source Control panel (Ctrl+Shift+G)
3. If not initialized: Click "Initialize Repository"
4. Stage all changes:
   - Click the `+` button next to each file or
   - Click the `+` button at the top to "Stage All Changes"
5. Enter commit message: "fix: resolve Riverpod provider compilation errors and type mismatches"
6. Click the checkmark button to commit
7. Click the branch icon (bottom left)
8. Click "Create new branch"
9. Name it: `fix/provider-compilation-errors`
10. Choose which branch to base it on (usually `main` or `master`)

## Files Modified

The following files have been changed and are ready to commit:

```
lib/
  ├── features/
  │   ├── order/presentation/providers/order_provider.dart
  │   ├── transaction/presentation/providers/transaction_provider.dart
  │   ├── notification/presentation/providers/notification_provider.dart
  │   └── ... (other feature files)
  └── presentation_providers.dart
```

## Verification Checklist

Before creating the pull request, verify:

- [ ] All files compile without errors
- [ ] Branch name is: `fix/provider-compilation-errors`
- [ ] Commit message clearly describes the changes
- [ ] PR description includes the changes summary (see PULL_REQUEST_SUMMARY.md)
- [ ] All files are staged and committed
- [ ] Branch is pushed to remote (if using GitHub)

## Creating the Pull Request

### On GitHub

1. Go to your repository on GitHub.com
2. You should see a "Compare & pull request" button
3. Click it
4. Set:
   - **Base:** `main` (or your default branch)
   - **Compare:** `fix/provider-compilation-errors`
5. Fill in the PR title: "Fix Riverpod provider compilation errors and type mismatches"
6. Copy the content from `PULL_REQUEST_SUMMARY.md` into the description
7. Add any additional context if needed
8. Click "Create pull request"

### On GitLab

1. Go to your repository on GitLab.com
2. Go to "Merge Requests" → "New merge request"
3. Set:
   - **Source branch:** `fix/provider-compilation-errors`
   - **Target branch:** `main` (or your default branch)
4. Click "Compare branches and continue"
5. Fill in the title and description
6. Click "Create merge request"

## Troubleshooting

### Git not initialized
```bash
git init
```

### Can't find git command
- Install Git from: https://git-scm.com/download/win
- Restart your terminal/VS Code

### Connection error when pushing
- Check your remote: `git remote -v`
- Add remote if missing: `git remote add origin <repository-url>`
- Verify credentials: `git config credential.helper`

### Branch not appearing
```bash
git fetch origin
git branch -a
```

### Want to undo changes before committing
```bash
git reset --hard HEAD
```

## Remote Setup (if needed)

```bash
# Check current remotes
git remote -v

# Add a remote (replace with your repository URL)
git remote add origin https://github.com/your-username/repo-name.git

# Verify
git remote -v

# Set the default branch
git branch -M main
git push -u origin main
```

## After PR is Created

1. Share the PR link with your team
2. Request reviewers
3. Address any feedback/comments
4. Once approved, merge to main branch
5. Delete the feature branch (both locally and remotely)

## Cleanup After Merge

```bash
# Switch back to main
git checkout main

# Pull latest changes
git pull origin main

# Delete local feature branch
git branch -d fix/provider-compilation-errors

# Delete remote feature branch
git push origin --delete fix/provider-compilation-errors
```

---

**Status:** Ready to proceed ✅
**All compilation errors:** Resolved ✅
**Documentation:** Complete ✅
