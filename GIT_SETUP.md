# Git Setup & Commit Guide

## Option 1: Simple Commit (Recommended)

### Step 1: Initialize Git Repository
```bash
cd /Users/petrosdhespollari/git/MovieFlix
git init
```

### Step 2: Add All Files
```bash
git add .
```

### Step 3: Commit with Detailed Message
```bash
git commit -m "feat: Implement MovieFlix iOS application for ATCOM assessment" \
-m "" \
-m "Complete iOS movie browser with UIKit home screen and SwiftUI detail screen." \
-m "" \
-m "Features:" \
-m "- Popular movies with infinite scroll & pull-to-refresh" \
-m "- Real-time search with debouncing" \
-m "- Persistent favorites (UserDefaults)" \
-m "- Skeleton loading animations" \
-m "- Movie details with cast, reviews, similar movies" \
-m "- Parallel API calls using DispatchGroup" \
-m "- Image caching with NSCache" \
-m "- Share functionality" \
-m "" \
-m "Tech Stack: Swift 5.0+, iOS 14+, UIKit, SwiftUI, Combine" \
-m "Architecture: MVVM, no external dependencies" \
-m "" \
-m "All ATCOM assignment requirements met ✓"
```

### Step 4: Create GitHub Repository
1. Go to https://github.com/new
2. Repository name: `MovieFlix` (or `movieflix-ios`)
3. Select **Private** (important!)
4. Don't initialize with README
5. Click "Create repository"

### Step 5: Push to GitHub
```bash
# Add remote (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/MovieFlix.git

# Rename branch to main (if needed)
git branch -M main

# Push to GitHub
git push -u origin main
```

### Step 6: Invite Reviewer
1. Go to your repository on GitHub
2. Click "Settings" → "Collaborators"
3. Click "Add people"
4. Enter: `pavlos.papaiakovou@atcom.gr`
5. Send invitation

---

## Option 2: Detailed Commit (Professional)

### Use the detailed commit message from COMMIT_MESSAGE.txt:

```bash
cd /Users/petrosdhespollari/git/MovieFlix
git init
git add .

# Use the full commit message from file
git commit -F COMMIT_MESSAGE.txt
```

Then follow steps 4-6 from Option 1.

---

## Option 3: Interactive Commit

```bash
cd /Users/petrosdhespollari/git/MovieFlix
git init
git add .
git commit
```

Then paste the content from COMMIT_MESSAGE.txt in your editor.

---

## Verification Commands

### Check Git Status
```bash
git status
```

### View Commit History
```bash
git log --oneline
```

### View Commit Details
```bash
git show HEAD
```

### Check Remote
```bash
git remote -v
```

---

## Troubleshooting

### Problem: Git not initialized
```bash
git init
```

### Problem: Wrong remote URL
```bash
# Remove wrong remote
git remote remove origin

# Add correct remote
git remote add origin https://github.com/YOUR_USERNAME/MovieFlix.git
```

### Problem: Authentication failed
```bash
# Use Personal Access Token instead of password
# Create token at: https://github.com/settings/tokens
```

### Problem: Push rejected
```bash
# Force push (only if it's a new repo)
git push -f origin main
```

---

## Complete Setup Script

Copy and paste this entire block (update YOUR_USERNAME):

```bash
#!/bin/bash

# Navigate to project
cd /Users/petrosdhespollari/git/MovieFlix

# Initialize git
git init

# Add all files
git add .

# Commit
git commit -m "feat: Implement MovieFlix iOS application for ATCOM assessment" \
-m "" \
-m "Complete iOS movie browser with UIKit home screen and SwiftUI detail screen." \
-m "" \
-m "Features:" \
-m "- Popular movies with infinite scroll & pull-to-refresh" \
-m "- Real-time search with debouncing" \
-m "- Persistent favorites (UserDefaults)" \
-m "- Skeleton loading animations" \
-m "- Movie details with cast, reviews, similar movies" \
-m "- Parallel API calls using DispatchGroup" \
-m "- Image caching with NSCache" \
-m "- Share functionality" \
-m "" \
-m "Tech Stack: Swift 5.0+, iOS 14+, UIKit, SwiftUI, Combine" \
-m "Architecture: MVVM, no external dependencies" \
-m "" \
-m "All ATCOM assignment requirements met ✓"

echo "✓ Git repository initialized and committed"
echo ""
echo "Next steps:"
echo "1. Create a private repository on GitHub"
echo "2. Run: git remote add origin https://github.com/YOUR_USERNAME/MovieFlix.git"
echo "3. Run: git push -u origin main"
echo "4. Invite pavlos.papaiakovou@atcom.gr as collaborator"
```

---

## Alternative: Using GitHub CLI

If you have GitHub CLI installed:

```bash
# Navigate to project
cd /Users/petrosdhespollari/git/MovieFlix

# Initialize and commit
git init
git add .
git commit -m "feat: Implement MovieFlix iOS application for ATCOM assessment"

# Create private repo and push (GitHub CLI)
gh repo create MovieFlix --private --source=. --push

# Add collaborator
gh repo invite pavlos.papaiakovou@atcom.gr
```

---

## Recommended Commit Title & Body

### Title (50 chars max):
```
feat: Implement MovieFlix iOS application
```

### Body (Detailed):
```
Complete iOS movie browser application for ATCOM assessment.

Features:
- UIKit home screen with popular movies, search, infinite scroll
- SwiftUI detail screen with full movie information
- Persistent favorites using UserDefaults
- Skeleton loading animations (UIKit & SwiftUI)
- Parallel API calls with DispatchGroup
- Image caching with NSCache
- Real-time search with debouncing
- Share functionality

Technical Stack:
- Swift 5.0+, iOS 14+
- MVVM architecture
- No external dependencies
- Clean code with best practices

All assignment requirements implemented and tested ✓

Assignment: ATCOM iOS Developer Position
Developer: Petros Dhespollari
Deadline: November 16, 2025
```

---

## Quick Reference

```bash
# Initialize
git init

# Stage all
git add .

# Commit
git commit -m "your message"

# Add remote
git remote add origin <url>

# Push
git push -u origin main

# Check status
git status
```

---

## Final Checklist Before Push

- [ ] Git initialized (`git init`)
- [ ] All files added (`git add .`)
- [ ] Committed with good message
- [ ] GitHub repository created (PRIVATE!)
- [ ] Remote added
- [ ] Pushed successfully
- [ ] Collaborator invited (pavlos.papaiakovou@atcom.gr)
- [ ] Repository is PRIVATE
- [ ] README.md visible on GitHub
- [ ] All files uploaded

---

Good luck with your submission! 🚀
