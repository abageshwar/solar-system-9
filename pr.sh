echo "Opening a Pull Request"

curl -X POST \
  'https://api.github.com/repos/abageshwar/gitops-argocd/pulls' \
  -H 'Accept: application/vnd.github+json' \
  -H "Authorization: Bearer $GIT_TOKEN" \
  -H 'Content-Type: application/json' \
  -d '{
    "title": "Updated Solar System Image",
    "head": "feature-gitea",
    "base": "main",
    "body": "Updated deployment specification with a new image version.",
    "assignees": ["abageshwar"]
}'

echo "Success"
