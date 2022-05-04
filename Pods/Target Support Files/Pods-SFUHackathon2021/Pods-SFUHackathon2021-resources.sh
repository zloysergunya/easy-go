#!/bin/sh
set -e
set -u
set -o pipefail

function on_error {
  echo "$(realpath -mq "${0}"):$1: error: Unexpected failure"
}
trap 'on_error $LINENO' ERR

if [ -z ${UNLOCALIZED_RESOURCES_FOLDER_PATH+x} ]; then
  # If UNLOCALIZED_RESOURCES_FOLDER_PATH is not set, then there's nowhere for us to copy
  # resources to, so exit 0 (signalling the script phase was successful).
  exit 0
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

RESOURCES_TO_COPY=${PODS_ROOT}/resources-to-copy-${TARGETNAME}.txt
> "$RESOURCES_TO_COPY"

XCASSET_FILES=()

# This protects against multiple targets copying the same framework dependency at the same time. The solution
# was originally proposed here: https://lists.samba.org/archive/rsync/2008-February/020158.html
RSYNC_PROTECT_TMP_FILES=(--filter "P .*.??????")

case "${TARGETED_DEVICE_FAMILY:-}" in
  1,2)
    TARGET_DEVICE_ARGS="--target-device ipad --target-device iphone"
    ;;
  1)
    TARGET_DEVICE_ARGS="--target-device iphone"
    ;;
  2)
    TARGET_DEVICE_ARGS="--target-device ipad"
    ;;
  3)
    TARGET_DEVICE_ARGS="--target-device tv"
    ;;
  4)
    TARGET_DEVICE_ARGS="--target-device watch"
    ;;
  *)
    TARGET_DEVICE_ARGS="--target-device mac"
    ;;
esac

install_resource()
{
  if [[ "$1" = /* ]] ; then
    RESOURCE_PATH="$1"
  else
    RESOURCE_PATH="${PODS_ROOT}/$1"
  fi
  if [[ ! -e "$RESOURCE_PATH" ]] ; then
    cat << EOM
error: Resource "$RESOURCE_PATH" not found. Run 'pod install' to update the copy resources script.
EOM
    exit 1
  fi
  case $RESOURCE_PATH in
    *.storyboard)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .storyboard`.storyboardc" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.xib)
      echo "ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile ${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib $RESOURCE_PATH --sdk ${SDKROOT} ${TARGET_DEVICE_ARGS}" || true
      ibtool --reference-external-strings-file --errors --warnings --notices --minimum-deployment-target ${!DEPLOYMENT_TARGET_SETTING_NAME} --output-format human-readable-text --compile "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename \"$RESOURCE_PATH\" .xib`.nib" "$RESOURCE_PATH" --sdk "${SDKROOT}" ${TARGET_DEVICE_ARGS}
      ;;
    *.framework)
      echo "mkdir -p ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      mkdir -p "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      echo "rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" $RESOURCE_PATH ${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}" || true
      rsync --delete -av "${RSYNC_PROTECT_TMP_FILES[@]}" "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
      ;;
    *.xcdatamodel)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH"`.mom\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodel`.mom"
      ;;
    *.xcdatamodeld)
      echo "xcrun momc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd\"" || true
      xcrun momc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcdatamodeld`.momd"
      ;;
    *.xcmappingmodel)
      echo "xcrun mapc \"$RESOURCE_PATH\" \"${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm\"" || true
      xcrun mapc "$RESOURCE_PATH" "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}/`basename "$RESOURCE_PATH" .xcmappingmodel`.cdm"
      ;;
    *.xcassets)
      ABSOLUTE_XCASSET_FILE="$RESOURCE_PATH"
      XCASSET_FILES+=("$ABSOLUTE_XCASSET_FILE")
      ;;
    *)
      echo "$RESOURCE_PATH" || true
      echo "$RESOURCE_PATH" >> "$RESOURCES_TO_COPY"
      ;;
  esac
}
if [[ "$CONFIGURATION" == "Debug" ]]; then
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/bg.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/bg.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ca.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ca.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/cs.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/cs.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/da.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/da.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/de.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/de.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/en.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/en.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/es.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/es.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/fr.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/fr.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/gl.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/gl.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/he.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/he.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ja.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ja.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ko.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ko.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/lt.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/lt.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/pt-BR.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/pt-BR.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ru.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ru.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/sv.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/sv.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/uk.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/uk.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/vi.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/vi.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/zh-Hans.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/zh-Hans.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/zh-Hant.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/zh-Hant.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/en.lproj/OrnamentsLocalizable.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Location/Pucks/IndicatorAssets.xcassets"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ar.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ar.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/Contents.json"
  install_resource "${BUILT_PRODUCTS_DIR}/MapboxNavigation/MapboxNavigation.framework/Base.lproj/Navigation.storyboardc"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/bg.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ca.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ca.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ca.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/da.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/da.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/da.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/de.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/de.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/de.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/el.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/el.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/el.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/en.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/en.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/en.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es-ES.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es-ES.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es-ES.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/fa.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/fr.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/fr.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/fr.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/he.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/he.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/he.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/hu.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/hu.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/hu.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/it.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ja.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ja.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ja.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ko.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ko.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ko.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/lt.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/nl.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-BR.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-BR.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-PT.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-PT.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-PT.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ru.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ru.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ru.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/sl.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/sv.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/sv.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/sv.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/tr.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/tr.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/tr.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/uk.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/uk.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/uk.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/vi.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/vi.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/vi.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/yo.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/yo.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/yo.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/zh-Hans.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/zh-Hans.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/zh-Hant.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/carplay"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/close.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/exit-left.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/exit-right.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/feedback"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/location.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/minus.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/overview.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/pan-map.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/plus.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/recenter.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/report_checkmark.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/reroute-sound.dataset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/RouteAnnotations"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/scroll.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/search-monocle.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/star.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/triangle.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/volume_off.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/volume_up.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ar.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Base.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/bg.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ca.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/da.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/de.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/el.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/en.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es-ES.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/fa.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/fr.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/he.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/hu.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/it.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ja.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ko.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/lt.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/nl.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-BR.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-PT.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ru.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/sl.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/sv.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/tr.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/uk.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/vi.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/yo.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/zh-Hans.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/zh-Hant.lproj"
fi
if [[ "$CONFIGURATION" == "Release" ]]; then
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/bg.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/bg.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ca.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ca.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/cs.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/cs.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/da.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/da.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/de.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/de.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/en.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/en.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/es.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/es.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/fr.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/fr.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/gl.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/gl.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/he.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/he.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ja.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ja.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ko.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ko.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/lt.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/lt.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/pt-BR.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/pt-BR.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ru.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/ru.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/sv.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/sv.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/uk.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/uk.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/vi.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/vi.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/zh-Hans.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/zh-Hans.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/zh-Hant.lproj/CompassDirectionLong.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/Compass/zh-Hant.lproj/CompassDirectionShort.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Ornaments/en.lproj/OrnamentsLocalizable.strings"
  install_resource "${PODS_ROOT}/MapboxMaps/Sources/MapboxMaps/Location/Pucks/IndicatorAssets.xcassets"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ar.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ar.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/Contents.json"
  install_resource "${BUILT_PRODUCTS_DIR}/MapboxNavigation/MapboxNavigation.framework/Base.lproj/Navigation.storyboardc"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/bg.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ca.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ca.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ca.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/da.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/da.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/da.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/de.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/de.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/de.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/el.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/el.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/el.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/en.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/en.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/en.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es-ES.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es-ES.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es-ES.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/fa.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/fr.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/fr.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/fr.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/he.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/he.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/he.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/hu.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/hu.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/hu.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/it.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ja.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ja.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ja.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ko.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ko.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ko.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/lt.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/nl.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-BR.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-BR.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-PT.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-PT.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-PT.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ru.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ru.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ru.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/sl.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/sv.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/sv.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/sv.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/tr.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/tr.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/tr.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/uk.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/uk.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/uk.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/vi.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/vi.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/vi.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/yo.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/yo.lproj/Localizable.stringsdict"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/yo.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/zh-Hans.lproj/Localizable.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/zh-Hans.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/zh-Hant.lproj/Navigation.strings"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/carplay"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/close.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/exit-left.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/exit-right.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/feedback"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/location.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/minus.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/overview.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/pan-map.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/plus.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/recenter.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/report_checkmark.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/reroute-sound.dataset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/RouteAnnotations"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/scroll.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/search-monocle.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/star.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/triangle.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/volume_off.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets/volume_up.imageset"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ar.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Assets.xcassets"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/Base.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/bg.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ca.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/da.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/de.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/el.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/en.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es-ES.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/es.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/fa.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/fr.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/he.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/hu.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/it.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ja.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ko.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/lt.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/nl.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-BR.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/pt-PT.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/ru.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/sl.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/sv.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/tr.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/uk.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/vi.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/yo.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/zh-Hans.lproj"
  install_resource "${PODS_ROOT}/MapboxNavigation/Sources/MapboxNavigation/Resources/zh-Hant.lproj"
fi

mkdir -p "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
if [[ "${ACTION}" == "install" ]] && [[ "${SKIP_INSTALL}" == "NO" ]]; then
  mkdir -p "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$RESOURCES_TO_COPY" / "${INSTALL_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
fi
rm -f "$RESOURCES_TO_COPY"

if [[ -n "${WRAPPER_EXTENSION}" ]] && [ "`xcrun --find actool`" ] && [ -n "${XCASSET_FILES:-}" ]
then
  # Find all other xcassets (this unfortunately includes those of path pods and other targets).
  OTHER_XCASSETS=$(find -L "$PWD" -iname "*.xcassets" -type d)
  while read line; do
    if [[ $line != "${PODS_ROOT}*" ]]; then
      XCASSET_FILES+=("$line")
    fi
  done <<<"$OTHER_XCASSETS"

  if [ -z ${ASSETCATALOG_COMPILER_APPICON_NAME+x} ]; then
    printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
  else
    printf "%s\0" "${XCASSET_FILES[@]}" | xargs -0 xcrun actool --output-format human-readable-text --notices --warnings --platform "${PLATFORM_NAME}" --minimum-deployment-target "${!DEPLOYMENT_TARGET_SETTING_NAME}" ${TARGET_DEVICE_ARGS} --compress-pngs --compile "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}" --app-icon "${ASSETCATALOG_COMPILER_APPICON_NAME}" --output-partial-info-plist "${TARGET_TEMP_DIR}/assetcatalog_generated_info_cocoapods.plist"
  fi
fi
