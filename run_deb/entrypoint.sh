#!/bin/sh
set -eu

app=/usr/local/bin/pyinstaller_project
ldd_output=/tmp/pyinstaller-project-ldd.txt
ldd_version=/tmp/pyinstaller-project-ldd-version.txt

echo "== image libc/runtime =="
ldd --version > "$ldd_version" 2>&1 || true
sed -n '1p' "$ldd_version"

for path in /lib/ld-musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 /lib/x86_64-linux-gnu/libc.so.6; do
    if [ -e "$path" ]; then
        echo "present: $path"
    else
        echo "missing: $path"
    fi
done

echo "== runtime link check =="
if ldd "$app" > "$ldd_output" 2>&1; then
    status=0
else
    status=$?
fi

cat "$ldd_output"

if [ "$status" -ne 0 ] || grep -Eq 'not found|Error relocating|not a dynamic executable' "$ldd_output"; then
    echo "== mismatch summary ==" >&2
    if grep -Eq 'libc\.musl|ld-musl' "$ldd_output"; then
        echo "Artifact expects musl/Alpine runtime support." >&2
    fi
    if grep -Eq '__.*_chk|Error relocating' "$ldd_output"; then
        echo "Artifact expects glibc/Debian runtime support." >&2
    fi
    echo "Runtime link check failed. This artifact was probably built against a different libc/runtime than this image." >&2
    exit 127
fi

echo "== starting app =="
exec "$app"
