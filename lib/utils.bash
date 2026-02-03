#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/oxc-project/oxc"
TOOL_NAME="oxlint"
TOOL_TEST="oxlint --version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

if [ -n "${GITHUB_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -oE 'refs/tags/(apps|oxlint)_v[0-9]+\.[0-9]+\.[0-9]+' |
		sed 's/refs\/tags\/apps_v//; s/refs\/tags\/oxlint_v//' |
		sort -u
}

list_all_versions() {
	list_github_tags
}

get_platform() {
	case "$(uname | tr '[:upper:]' '[:lower:]')" in
	darwin) echo "darwin" ;;
	linux) echo "linux" ;;
	*) fail "Platform '$(uname)' not supported!" ;;
	esac
}

get_arch() {
	case "$(uname -m)" in
	x86_64 | amd64) echo "x64" ;;
	aarch64 | arm64) echo "arm64" ;;
	*) fail "Arch '$(uname -m)' not supported!" ;;
	esac
}

get_libc() {
	[ "$(get_platform)" != "linux" ] && return
	if command -v ldd &>/dev/null && ldd --version 2>&1 | grep -qi musl; then
		echo "-musl"
	else
		echo "-gnu"
	fi
}

download_release() {
	local version="$1" filename="$2"
	local asset url url_fallback
	asset="oxlint-$(get_platform)-$(get_arch)$(get_libc).tar.gz"
	url="$GH_REPO/releases/download/apps_v${version}/${asset}"
	url_fallback="$GH_REPO/releases/download/oxlint_v${version}/${asset}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" ||
		curl "${curl_opts[@]}" -o "$filename" -C - "$url_fallback" ||
		fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
