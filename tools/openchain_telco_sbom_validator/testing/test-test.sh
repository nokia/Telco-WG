#! /usr/bin/env bash
# -*- coding: utf-8 -*-

# © 2024 Nokia
# Licensed under the Apache License 2.0
# SPDX-License-Identifier: Apache-2.0

source bash_test_tools

# Documentation is here: https://thorsteinssonh.github.io/bash_test_tools/
. ../.env/bin/activate
pip3 install -e ../

function test_no_supplier_no_checksum
{
    echo "Test: test_no_supplier_no_checksum"
    run "python3 ../src/openchain_telco_sbom_validator/cli.py test-sbom-01.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "The SPDX file test-sbom-01.spdx is not compliant with the OpenChain Telco SBOM Guide"
}

function test_no_supplier_no_checksum_v10
{
    echo "Test: test_no_supplier_no_checksum"
    run "python3 ../src/openchain_telco_sbom_validator/cli.py --guide-version 1.0 --strict test-sbom-01.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "The SPDX file test-sbom-01.spdx is not compliant with the OpenChain Telco SBOM Guide"
}

function test_no_supplier_no_checksum_v10_strict
{
    echo "Test: test_no_supplier_no_checksum"
    run "python3 ../src/openchain_telco_sbom_validator/cli.py --guide-version 1.0 --strict test-sbom-01.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "libldap-2.4-2 | PackageChecksum field is"
    assert_output_contains "The SPDX file test-sbom-01.spdx is not compliant with the OpenChain Telco SBOM Guide"
}


function test_no_name_no_version_no_supplier
{
    echo "Test: test_no_name_no_version_no_supplier"
    run "python3 ../src/openchain_telco_sbom_validator/cli.py test-sbom-02.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "Package without a name"
    assert_output_contains "golang.org/x/sync-empty-  | Package without a package"
    assert_output_contains "golang.org/x/sync-        | Package without a package"
    assert_output_contains "The SPDX file test-sbom-02.spdx is not compliant with the OpenChain Telco SBOM Guide"
}

function test_no_name_no_version_no_supplier_v10_strict
{
    echo "Test: test_no_name_no_version_no_supplier"
    run "python3 ../src/openchain_telco_sbom_validator/cli.py test-sbom-02.spdx --guide-version 1.0 --strict"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "Package without a name"
    assert_output_contains "golang.org/x/sync-empty-  | Package without a package"
    assert_output_contains "golang.org/x/sync-        | Package without a package"
    assert_output_contains "golang.org/x/sync-empty-  | PackageChecksum field is"
    assert_output_contains "golang.org/x/sync-        | PackageChecksum field is"
    assert_output_contains "The SPDX file test-sbom-02.spdx is not compliant with the OpenChain Telco SBOM Guide"
}



function test_no_homepage_open_chain_offline
{
    echo "Test: test_no_homepage_open_chain_offline"
    run "python3 ../src/openchain_telco_sbom_validator/cli.py test-sbom-03.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "Empty        | homepage must be a valid"
    assert_output_contains "InvalidURL   | homepage must be a valid"
    assert_output_contains "The SPDX file test-sbom-03.spdx is not compliant with the OpenChain Telco SBOM Guide"
}

function test_no_homepage_open_chain_online
{
    echo "Test: test_no_homepage_open_chain_online"
    run "python3 ../src/openchain_telco_sbom_validator/cli.py --strict-url-check test-sbom-03.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "Empty        | homepage must be a valid"
    assert_output_contains "InvalidURL   | homepage must be a valid"
    assert_output_contains "The SPDX file test-sbom-03.spdx is not compliant with the OpenChain Telco SBOM Guide"
}

function test_invalid_creator_comment
{
    echo "Test: test_invalid_creator_comment"
    run "python3 ../src/openchain_telco_sbom_validator/cli.py --strict-url-check test-sbom-04.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "General       | CreatorComment (No CISA"
    assert_output_contains "The SPDX file test-sbom-04.spdx is not compliant with the OpenChain Telco SBOM Guide"
}

function test_no_creator_comment
{
    echo "Test: test_no_creator_comment"
    run "python3 ../src/openchain_telco_sbom_validator/cli.py --strict-url-check $DEBUG test-sbom-05.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "General       | CreatorComment is missing"
    assert_output_contains "The SPDX file test-sbom-05.spdx is not compliant with the OpenChain Telco SBOM Guide"
}

function test_no_version_json
{
    echo "Test: test_no_version_json"
    run "python3 ../src/openchain_telco_sbom_validator/cli.py --strict-url-check test-sbom-06.spdx.json"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "scanoss/engine | Package without a version"
    assert_output_contains "The SPDX file test-sbom-06.spdx.json is not compliant with the OpenChain Telco SBOM Guide"
}

function test_ok_json
{
    echo "Test: test_ok_json"
    run "python3 ../src/openchain_telco_sbom_validator/cli.py --strict-url-check test-sbom-07.spdx.json"
    echo "$output"
    assert_terminated_normally
    assert_exit_success
    assert_has_output
    assert_output_contains "The SPDX file test-sbom-07.spdx.json is compliant with the OpenChain Telco SBOM Guide"
}

function test_cli_empty
{
    echo "Test: test_cli_empty"
    run "openchain-telco-sbom-validator"
    assert_terminated_normally
    assert_exit_fail
    assert_has_error
    assert_error_contains "ERROR! Input is a mandatory parameter."
}

function test_cli_version
{
    echo "Test: test_cli_version"
    run "openchain-telco-sbom-validator --version"
    echo "$output"
    assert_terminated_normally
    assert_exit_success
    assert_has_output
    assert_output_contains "OpenChain Telco SBOM Validator version"
}

function test_linked_no_strict
{
    echo "Test: test_linked_none"
    run "openchain-telco-sbom-validator --strict linked-sboms-01/linked-sbom-01.spdx.json"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "1 | Invalid"
    assert_output_contains "The SPDX file linked-sboms-01/linked-sbom-01.spdx.json is not compliant with the OpenChain Telco SBOM Guide"
}

function test_linked_no_non_strict
{
    echo "Test: test_linked_none"
    run "openchain-telco-sbom-validator linked-sboms-01/linked-sbom-01.spdx.json"
    echo "$output"
    assert_terminated_normally
    assert_exit_success
    assert_has_output
    assert_output_contains "The SPDX file linked-sboms-01/linked-sbom-01.spdx.json is compliant with the OpenChain Telco SBOM Guide version 1.1"
}


function test_linked_none
{
    echo "Test: test_linked_none"
    run "openchain-telco-sbom-validator --strict --reference-logic none linked-sboms-01/linked-sbom-01.spdx.json"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "1 | Invalid"
    assert_output_contains "The SPDX file linked-sboms-01/linked-sbom-01.spdx.json is not compliant with the OpenChain Telco SBOM Guide"
}

function test_linked_yocto_all
{
    echo "Test: test_linked_none"
    run "openchain-telco-sbom-validator --reference-logic yocto-all linked-sboms-01/linked-sbom-01.spdx.json"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "13 | SPDX validation error (SPDX)"
    assert_output_contains "One or more of the SPDX files linked-sbom-01.spdx.json, alarm.spdx.json, recipe-alarm.spdx.json, runtime-alarm.spdx.json, em-accessories.spdx.json, alignmentpavendors.spdx.json, recipe-alignmentpavendors.spdx.json, runtime-alignmentpavendors.spdx.json, alps.spdx.json, runtime-alps.spdx.json, kernel-5.15.155-r42.spdx.json, runtime-kernel-5.15.155-r42.spdx.json are not compliant with the OpenChain Telco SBOM Guide version 1.1"
}

function test_linked_yocto_all_nojson
{
    echo "Test: test_linked_none"
    run "openchain-telco-sbom-validator --reference-logic yocto-all linked-sboms-03/linked-sbom-03.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_success
    assert_has_output
    assert_output_contains "All of the SPDX files linked-sbom-03.spdx, recipe-xz.spdx, recipe-glibc.spdx are compliant with the OpenChain Telco SBOM Guide version 1.1"
}


function test_linked_yocto-contains-only
{
    echo "Test: test_linked_none"
    run "openchain-telco-sbom-validator --reference-logic yocto-contains-only linked-sboms-01/linked-sbom-01.spdx.json"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "2 | SPDX validation error (SPDX)"
    assert_output_contains "One or more of the SPDX files linked-sbom-01.spdx.json, alarm.spdx.json, alignmentpavendors.spdx.json, alps.spdx.json are not compliant with the OpenChain Telco SBOM Guide"
}

function test_linked_nonexistent
{
    echo "Test: test_linked_none"
    run "openchain-telco-sbom-validator --reference-logic nonexistent linked-sboms-01/linked-sbom-01.spdx.json"
    echo "$output"
    echo "$error"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_error_contains 'ERROR - Referring logic “nonexistent” is not in the registered referring logic list “none”, “yocto-all”, “yocto-contains-only”, “checksum-all”'
}

function test_linked_checksum_all
{
    echo "Test: test_linked_checksum_all"
    run "openchain-telco-sbom-validator --reference-logic checksum-all linked-sboms-01/linked-sbom-01.spdx.json"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains " 13 | SPDX validation error (SPDX)"
    assert_output_contains "One or more of the SPDX files linked-sbom-01.spdx.json, alarm.spdx.json, recipe-alarm.spdx.json, runtime-alarm.spdx.json, em-accessories.spdx.json, alignmentpavendors.spdx.json, recipe-alignmentpavendors.spdx.json, runtime-alignmentpavendors.spdx.json, alps.spdx.json, runtime-alps.spdx.json, kernel-5.15.155-r42.spdx.json, runtime-kernel-5.15.155-r42.spdx.json are not compliant with the OpenChain Telco SBOM Guide version 1.1"
}

function test_ok_package_homepage_nok_non_strict
{
    echo "Test: test_nok_package_homepage_non_strict"
    run "openchain-telco-sbom-validator test-sbom-08.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_success
    assert_has_output
    assert_output_contains "The SPDX file test-sbom-08.spdx is compliant with the OpenChain Telco SBOM Guide version 1.1"
}

function test_nok_package_nok_homepage_strict
{
    echo "Test: test_nok_package_homepage_strict"
    run "openchain-telco-sbom-validator test-sbom-08.spdx --strict-url-check"
    echo "$output"
    assert_terminated_normally
    assert_exit_successs
    assert_has_output
    assert_output_contains "points to a nonexisting"
    assert_output_contains "The SPDX file test-sbom-08.spdx is compliant with the OpenChain Telco SBOM Guide version 1.1"
}


function test_nok_linked_incorrect_ref_logic
{
    echo "Test: test_nok_linked_incorrect_ref_logic"
    run "openchain-telco-sbom-validator --reference-logic not-correct linked-sboms-01/linked-sbom-01.spdx.json"
    echo "$output"
    assert_terminated_normally
    assert_exit_fail
    assert_has_output
    assert_output_contains "Referring logic “not-correct” is not in the registered referring logic list “none”, “yocto-all”, “yocto-contains-only”, “checksum-all”"
}

function test_ok_purl_nok_non_strict
{
    echo "Test: test_ok_purl_nok_non_strict"
    run "openchain-telco-sbom-validator --strict test-sbom-09.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_success
    assert_has_output
    assert_output_contains "The SPDX file test-sbom-09.spdx is compliant with the OpenChain Telco SBOM Guide version 1.1 in strict mode (with RECOMMENDED also)"
}

function test_ok_package_homepage_nok_non_strict
{
    echo "Test: test_nok_package_homepage_non_strict"
    run "openchain-telco-sbom-validator test-sbom-08.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_success
    assert_has_output
    assert_output_contains "The SPDX file test-sbom-08.spdx is compliant with the OpenChain Telco SBOM Guide version 1.1"
}

function test_ok_purl_ok_non_strict
{
    echo "Test: test_ok_purl_nok_non_strict"
    run "openchain-telco-sbom-validator --strict test-sbom-09.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_success
    assert_has_output
    assert_output_contains "The SPDX file test-sbom-09.spdx is compliant with the OpenChain Telco SBOM Guide version 1.1 in strict mode (with RECOMMENDED also)"
}

function test_ok_purl_nok_non_strict
{
    echo "Test: test_ok_purl_nok_non_strict"
    run "openchain-telco-sbom-validator --strict test-sbom-09.spdx"
    echo "$output"
    assert_terminated_normally
    assert_exit_success
    assert_has_output
    assert_output_contains "The SPDX file test-sbom-09.spdx is compliant with the OpenChain Telco SBOM Guide version 1.1 in strict mode (with RECOMMENDED also)"
}

function test_nok_purl_ok_strict
{
    echo "Test: test_nok_purl_nok_strict"
    run "openchain-telco-sbom-validator test-sbom-09.spdx --strict --strict-purl-check"
    assert_output_contains "Useless"
    assert_output_contains "The SPDX file test-sbom-09.spdx is compliant with the OpenChain Telco SBOM Guide version 1.1 in strict mode (with RECOMMENDED also)"
}

function test_nok_linked_incorrect_ref_logic
{
    echo "Test: test_nok_linked_incorrect_ref_logic"
    run "openchain-telco-sbom-validator --strict --reference-logic not-correct linked-sboms-01/linked-sbom-01.spdx.json"
    assert_error_contains "ERROR - Referring logic “not-correct” is not"
    assert_output_contains "3 | Missing mandatory field from Package"
    assert_output_contains "The SPDX file linked-sboms-01/linked-sbom-01.spdx.json is not compliant with the OpenChain Telco SBOM Guide version 1.1 in strict mode (with RECOMMENDED also)"
}


function test_ok_noassert
{
    echo "Test: test_ok_noassert"
    run "openchain-telco-sbom-validator --noassertion test-sbom-10.spdx.json"
    echo "$output"
    assert_terminated_normally
    assert_exit_success
    assert_has_output
    assert_output_contains "The SPDX file test-sbom-10.spdx.json is compliant with the OpenChain Telco SBOM Guide version 1.1"
    assert_output_contains "NOASSERTION"
}

testrunner
deactivate