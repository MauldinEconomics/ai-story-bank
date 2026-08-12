#!/bin/bash
# Run this once the DNS CNAME (host: stories -> paleofaire.github.io) is live.
# It restores the custom domain and points every URL back at it.
set -e
cd "$(dirname "$0")"
NEW="https://stories.rationaloptimistsociety.com"
OLD="https://paleofaire.github.io/ai-story-bank"
printf 'stories.rationaloptimistsociety.com\n' > CNAME
for f in index.html robots.txt sitemap.xml README.md; do
  [ -f "$f" ] && /usr/bin/sed -i '' "s|$OLD|$NEW|g" "$f"
done
git add -A && git commit -q -m "Switch to stories.rationaloptimistsociety.com" && git push -q origin main
gh api -X PUT repos/PaleoFaire/ai-story-bank/pages -f cname=stories.rationaloptimistsociety.com 2>/dev/null || true
echo "Done. Allow a few minutes for the certificate, then enable HTTPS enforcement:"
echo "  gh api -X PUT repos/PaleoFaire/ai-story-bank/pages -F https_enforced=true"
