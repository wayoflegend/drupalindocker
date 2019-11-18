#!/usr/bin/env bash

DRUPAL_DIR="${PWD}/drupal/web"
DRUPAL_VENDOR="${PWD}/drupal/vendor"

echo "Php Code beautyfier will try to fix some code errors:"
${DRUPAL_VENDOR}/bin/phpcbf --standard=vendor/drupal/coder/coder_sniffer/Drupal --extensions="php,module,inc,install,test,profile,theme,css,info,txt,md,yml" ${DRUPAL_DIR}/modules/custom/
${DRUPAL_VENDOR}/bin/phpcbf --standard=vendor/drupal/coder/coder_sniffer/Drupal --extensions="php,module,inc,install,test,profile,theme,css,info,txt,md,yml" ${DRUPAL_DIR}/themes/custom/
echo "Automatic fix successfully done."
echo "Inspecting custom modules ...."
${DRUPAL_VENDOR}/bin/phpcs --standard=vendor/drupal/coder/coder_sniffer/Drupal --extensions="php,module,inc,install,test,profile,theme,css,info,txt,md,yml" ${DRUPAL_DIR}/modules/custom/ --report-summary
echo "Inspecting custom theme ...."
${DRUPAL_VENDOR}/bin/phpcs --standard=vendor/drupal/coder/coder_sniffer/Drupal --extensions="php,module,inc,install,test,profile,theme,css,info,txt,md,yml" ${DRUPAL_DIR}/themes/custom/ --report-summary
echo "Inspection successfully finished. But if you still see errors displayed you better fix it before someone will try to ****kill you******."
echo "Starting PHPStan - PHP Static Analysis Tool :"
${DRUPAL_VENDOR}/bin/phpstan analyse -l 4 -c phpstan.neon --error-format awesome --paths-file=${DRUPAL_DIR}/modules/custom/ ${DRUPAL_DIR}/themes/custom/ --debug
echo "Be careful with PHPStan warnings because somtimes no really required to fix service calling or reported unknow variables."
