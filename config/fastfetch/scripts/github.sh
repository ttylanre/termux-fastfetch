#!/bin/bash
CACHE_FILE="$HOME/.cache/fastfetch_gh.cache"
USERNAME="ttylanre"

# Cache for 1 hour
if [ -f "$CACHE_FILE" ] && [ $(( $(date +%s) - $(stat -c %Y "$CACHE_FILE") )) -lt 3600 ]; then
    cat "$CACHE_FILE"
    exit 0
fi

# If no token is set, fallback gracefully
if [ -z "$GH_TOKEN" ]; then
    echo "󰊤 Token missing"
    exit 1
fi

# GraphQL query to fetch total contributions for the current year
YEAR=$(date +%Y)
QUERY="{\"query\": \"query { user(login: \\\"$USERNAME\\\") { contributionsCollection(from: \\\"${YEAR}-01-01T00:00:00Z\\\") { contributionCalendar { totalContributions } } repositories(first: 100, ownerAffiliations: OWNER) { totalCount } } }\"}"

RESPONSE=$(curl -s -X POST \
  -H "Authorization: bearer $GH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$QUERY" "https://api.graphql.github.com/graphql")

if echo "$RESPONSE" | jq -e '.data.user' >/dev/null 2>&1; then
    CONTRIB=$(echo "$RESPONSE" | jq '.data.user.contributionsCollection.contributionCalendar.totalContributions')
    REPOS=$(echo "$RESPONSE" | jq '.data.user.repositories.totalCount')
    
    OUTPUT="󰊤 Commits ($YEAR): $CONTRIB  󰏦 Repos: $REPOS"
    echo "$OUTPUT" > "$CACHE_FILE"
    echo "$OUTPUT"
else
    echo "󰊤 API Error"
fi
