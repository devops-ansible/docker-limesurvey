#!/usr/bin/env bash

set -eu -o pipefail

DOWNLOAD_URL="$(
  curl -fsSL https://community.limesurvey.org/downloads/ |
  sed -nE 's/.*(https:\/\/download\.limesurvey\.org\/latest-master\/[^"[:space:]<>]+\.zip).*/\1/p' |
  head -n 1
)"

if [[ -z "$DOWNLOAD_URL" ]]; then
    echo "ERROR: Could not find LimeSurvey download URL"
    exit 1
fi

echo "Downloading LimeSurvey from: $DOWNLOAD_URL"

wget "$DOWNLOAD_URL" -O /tmp/limesurvey.zip
unzip /tmp/limesurvey.zip -d /tmp/

mv  /tmp/limesurvey  /tmp/html
mv  /tmp/html        "${APACHE_WORKDIR}"/..
rm  -rf  /tmp/*

# LimeSurvey compatibility fixes
patch_limesurvey() {
    local file old new

    # Fix 1: Missing language in question group translations
    file="${APACHE_WORKDIR}/application/models/QuestionGroup.php"
    old='"select" => "group_name, description"'
    new='"select" => "group_name, description, language"'

    if grep -Fq "$new" "$file"; then
        echo "SKIP: QuestionGroup.php already fixed"
    elif grep -Fq "$old" "$file"; then
        sed -i 's/"select" => "group_name, description"/"select" => "group_name, description, language"/' "$file"
        grep -Fq "$new" "$file" || return 1
        echo "PATCHED: QuestionGroup.php"
    else
        echo "ERROR: Unexpected QuestionGroup.php structure" >&2
        return 1
    fi
}

patch_limesurvey

mv  /docker_install/templates/*             /templates/
mv  /docker_install/10_install_on_start.sh  /boot.d/
rm  -rf  /docker_install

chown -R www-data:www-data "${APACHE_WORKDIR}"
