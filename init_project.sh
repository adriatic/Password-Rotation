#!/usr/bin/env zsh
# init_project.sh — scaffolding initializer + initial commit/push for Password-Rotation project

set -euo pipefail

##### CONFIGURATION #####
BASE_DIR="/Users/nik/work/AI/apps/Password-Rotation"
REPO_URL="https://github.com/adriatic/Password-Rotation.git"
INITIAL_COMMIT_MSG="Initial scaffolding commit"
##### END CONFIGURATION #####

echo "Initializing project in $BASE_DIR …"

# Create base directory
mkdir -p "$BASE_DIR"
cd "$BASE_DIR"

# If not already a git repo, initialize and set remote
if [ ! -d ".git" ]; then
  echo " -> Initializing git repository"
  git init
  git remote add origin "$REPO_URL"
else
  echo " -> Git repository already initialized"
fi

# Create directories
mkdir -p script creds logs

# Write .gitignore
cat << 'EOF' > .gitignore
# ignore generated credentials and logs
creds/
logs/
# ignore credential output in script
script/*.cred
EOF

# Write README.md placeholder
cat << 'EOF' > README.md
# Password Rotation Project

This project contains scaffolding for a macOS Zsh-based password-rotation utility.

## Project Structure
Refer to the "Project Structure" section in Project-Definition.md
EOF

# Write empty accounts.txt (placeholder)
touch accounts.txt

# Write scaffold rotate_passwords.zsh
cat << 'EOF' > script/rotate_passwords.zsh
#!/usr/bin/env zsh
#
# Scaffold for Password Rotation Script — placeholder only.

set -euo pipefail

# Configuration
ACCOUNT_LIST="\${PWD}/accounts.txt"
CRED_STORE_DIR="\${PWD}/creds"
LOG_DIR="\${PWD}/logs"
LOG_FILE="\${LOG_DIR}/rotation-\$(date +%F).log"
PW_LENGTH=24

mkdir -p "\$LOG_DIR"
mkdir -p "\$CRED_STORE_DIR"
chmod 700 "\$CRED_STORE_DIR"

log() {
  echo "\$(date +'%F %T') \$*" | tee -a "\$LOG_FILE"
}

generate_password() {
  # TODO: implement real random password generator
  echo "[PLACEHOLDER_PASSWORD]"
}

rotate_password_for_account() {
  local shortname="\$1"
  local service="\$2"
  log "Would rotate password for user='\$shortname', service='\$service'"
  # TODO: implement actual password reset logic
}

main() {
  log "=== Scaffold run start ==="
  while IFS=: read -r user service; do
    if [[ -z "\$user" || -z "\$service" ]]; then
      log "Skipping invalid line: '\$user:\$service'"
      continue
    fi
    rotate_password_for_account "\$user" "\$service"
  done < "\$ACCOUNT_LIST"
  log "=== Scaffold run end ==="
}

main
EOF

chmod +x script/rotate_passwords.zsh

# Write the project definition markdown
cat << EOF > Project-Definition.md
---
title: Password Rotation Project Definition
date: $(date +%F)
tags: [project, password-rotation, automation]
---

# Project: Password Rotation Project  
**Repository:** \`Password-Rotation\` (via GitHub: $REPO_URL)  
**Location on local machine:** \`$BASE_DIR\`

---

## Objective  
Generate the repository structure and scaffold files for the project — no password-rotation logic is executed yet.

## Scope  
- Create directories and placeholder files.  
- Provide a skeleton Zsh script and README.  
- Ignore sensitive output via .gitignore.  
- Ready for you to add logic, secrets integration, scheduling, etc.

## Directory & File Structure  
\`\`\`
Password-Rotation/
├── .gitignore
├── README.md
├── Project-Definition.md
├── accounts.txt
├── script/
│   └── rotate_passwords.zsh
├── creds/
├── logs/
\`\`\`

## Usage  
After running this script, review and edit \`accounts.txt\`, and begin implementing the actual rotation logic.  

EOF

echo "Scaffolding files created."

# Stage everything, commit, and push
echo "Adding files to git, committing and pushing to origin..."
git add .
git commit -m "$INITIAL_COMMIT_MSG"
git branch -M main 2>/dev/null || true
git push -u origin main

echo "✅ Project initialized, committed, and pushed."
