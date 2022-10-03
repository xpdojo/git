# .\dummy-commit.ps1 1 11
for ($i = $args[0]; $i -le $args[1]; $i++) {
  # write-host $i
  git commit --allow-empty -m "Dummy commit $i"
}
