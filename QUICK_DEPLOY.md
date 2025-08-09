# 🚀 Quick Deploy Guide

**3-minute setup for GitHub Pages deployment**

## Step 1: Update Configuration (2 minutes)

Edit `website/docusaurus.config.ts`:

```typescript
// Replace these values
url: 'https://YOUR-GITHUB-USERNAME.github.io',
organizationName: 'YOUR-GITHUB-USERNAME',
projectName: 'flutter_starter', // or your actual repo name
```

## Step 2: Deploy (1 minute)

```bash
# From project root
git add .
git commit -m "Deploy Flutter Starter website"
git push origin main
```

## Step 3: Enable GitHub Pages

1. Go to repository **Settings → Pages**
2. Set **Source** to "GitHub Actions"
3. **Save**

## Result

**Your site will be live at:**
`https://YOUR-USERNAME.github.io/flutter_starter/`

**Deployment time:** 5-10 minutes

---

**That's it! Your professional Flutter course website is now live! 🎉**
