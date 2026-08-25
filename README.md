# Birthday Site — Deployment Guide

This repo contains a single-file static site: `birthday-fun (4).html`.

## Goal
Publish this project to GitHub and deploy to Vercel as a static site.

## Quick steps (recommended)

1. Initialize the repo locally and commit:

```bash
cd "c:\Users\Suleman Ahmed\Desktop\Wali birthday"
git init
git add .
git commit -m "Initial site"
```

2. Create a GitHub repository and push

- Option A — GitHub CLI (recommended):

```bash
# replace YOUR-REPO with the name you want
gh repo create YOUR-REPO --public --source=. --remote=origin --push
```

- Option B — GitHub web:
  - Create a new repo at https://github.com/new (leave README unchecked)
  - Copy the remote URL and run:

```bash
git remote add origin https://github.com/USERNAME/YOUR-REPO.git
git branch -M main
git push -u origin main
```

3. Deploy to Vercel

- Option A — Vercel web UI (no CLI):
  - Visit https://vercel.com/import and choose "GitHub".
  - Select your repository, set the root directory to `/` (default), and for Framework Preset choose "Other" (static).
  - Click Deploy.

- Option B — Vercel CLI:

```bash
npm i -g vercel
vercel login
cd "c:\Users\Suleman Ahmed\Desktop\Wali birthday"
vercel --prod
```

Vercel will detect a static site and deploy the HTML file as-is.

## Useful tips
- If the favicon filename is long or contains spaces, consider renaming it to `favicon.png` and updating the `<link rel="icon">` href in the HTML.
- To change the site URL, configure a custom domain in the Vercel dashboard.

## Troubleshooting
- If your files don’t appear after first deploy, confirm `birthday-fun (4).html` is at the repo root.
- If GitHub push fails, ensure you have proper auth (GitHub CLI or PAT) configured.

If you want, I can:
- Rename the favicon file to `favicon.png` and update the HTML for you.
- Generate a `.github/workflows/deploy.yml` GitHub Action to automatically run `vercel` on push (needs a Vercel token).

Tell me which of the above you'd like me to do next and I’ll prepare the files/patches.