git rev-parse --git-dir >/dev/null || exit 1
echo $(git log -1 --format=format:%H) > manifest.uuid
echo C $(cat manifest.uuid) > manifest
git log -1 --format=format:%ci%n | sed 's/ [-+].*$//;s/ /T/;s/^/D /' >> manifest
