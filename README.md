## Pre-requisites
- Telegram bot token, stored as a GitHub secret
  - `TOKEN`
- [ ] Other environment variables are currently not supported. TODO.
- [ ] Role + policy creation is currently not supported. TODO.

## Usage
1. Create a new GitHub Actions workflow file in your repository. `.github/workflows/deploy.yml`
2. Add the following to the workflow file:
```yaml

name: Deploy Bot
run-name: Deploy ${{ inputs.BOT_NAME }} by @${{ github.actor }}

on:
  workflow_dispatch:
    inputs:
      BOT_NAME:
        description: "Name of the bot to deploy in kebab-case"
        required: true

jobs:
  deploy:
    uses: applepiofmyeye/telebot-deployment/.github/workflows/deploy.yml@master
    permissions:
      id-token: write
      contents: read
    with:
      BOT_NAME: ${{ github.event.inputs.BOT_NAME }}
    secrets:
      TOKEN: ${{ secrets.TOKEN }}
```

