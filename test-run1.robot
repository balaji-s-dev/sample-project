*** Settings ***
Documentation     TS0002 Automated Test Suite
Library           SeleniumLibrary
Library           BuiltIn

Suite Setup       Suite Setup Keywords
Test Setup        Method Setup
Test Teardown     Method Teardown
Suite Teardown    Suite Teardown Keywords


*** Variables ***
${BASE_URL}           https://opensource-demo.orangehrmlive.com
${TIMEOUT}            1s
${DELAY}              0.5s
${DASHBOARD_URL}           https://opensource-demo.orangehrmlive.com/web/index.php/dashboard/index
${VIEWSYSTEMUSERS_URL}           https://opensource-demo.orangehrmlive.com/web/index.php/admin/viewSystemUsers
${SAVESYSTEMUSER_URL}           https://opensource-demo.orangehrmlive.com/web/index.php/admin/saveSystemUser
${AUTOCOMPLETE_VALUE}           balajioffl
${ELEMENT_1}           xpath=//button[normalize-space()='Admin']
${ELEMENT_2}           xpath=//div[contains(@class, 'oxd-grid-4')]/div[contains(@class, 'oxd-grid-item')]/div[contains(@class, 'oxd-input-group')]/div[2]/input[contains(@class, 'oxd-input')][contains(@class, 'oxd-input')]
${ELEMENT_3}           xpath=//button[normalize-space()='Search']
${ELEMENT_4}           xpath=//button[normalize-space()='Add']
${ELEMENT_5}           xpath=//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input
${ELEMENT_6}           id=app
${ELEMENT_7}           id=app__2
${ELEMENT_8}           xpath=//button[normalize-space()='Save']
${ELEMENT_9}           xpath=(//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input)[2]
${ELEMENT_10}           xpath=(//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input)[3]
${ELEMENT_11}           xpath=(//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input)[4]
${ELEMENT_12}           xpath=(//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input)[5]
${ELEMENT_13}           xpath=(//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input)[6]


*** Keywords ***
Suite Setup Keywords
    Log    Suite setup started
        ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
        Call Method    ${options}    add_argument    --headless
        Call Method    ${options}    add_argument    --no-sandbox
        Call Method    ${options}    add_argument    --disable-dev-shm-usage
        Call Method    ${options}    add_argument    --disable-gpu
        Call Method    ${options}    add_argument    --disable-software-rasterizer
        Call Method    ${options}    add_argument    --no-first-run
        Call Method    ${options}    add_argument    --disable-extensions
        Call Method    ${options}    add_argument    --disable-web-security
        Call Method    ${options}    add_argument    --allow-running-insecure-content
        Call Method    ${options}    add_argument    --user-data-dir\=/tmp/chrome_63120ceb7b2f4e888cf499b7ae753d98
        Call Method    ${options}    add_argument    --remote-debugging-port\=0
        Call Method    ${options}    add_argument    --user-agent\=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36
        Log To Console    ${options.arguments}
        Create Webdriver    Chrome    options=${options}

Suite Teardown Keywords
    Log    Suite teardown started
        Run Keywords    Capture Page Screenshot    AND    Close Browser
    Log    Browser closed successfully

Method Setup
    Log    Test setup started
    Log    Test setup completed

Method Teardown
    Log    Test teardown started
    Log    Test teardown completed

Capture Screenshot On Failure
    Run Keyword If Test Failed    Capture Page Screenshot


*** Test Cases ***

TS0002
    [Documentation]    TS0002
    Maximize Browser Window
    Set Window Size    1920    1080
    Sleep    ${DELAY}
    Go To    ${DASHBOARD_URL}
    Wait Until Location Contains    /web/index.php/dashboard/index    ${TIMEOUT}
    Wait Until Element Is Visible    ${ELEMENT_1}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_1}     ${TIMEOUT}
    Click Element    ${ELEMENT_1}
    Go To    ${VIEWSYSTEMUSERS_URL}
    Wait Until Location Contains    /web/index.php/admin/viewSystemUsers    ${TIMEOUT}
    Wait Until Element Is Visible    ${ELEMENT_2}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_2}     ${TIMEOUT}
    Input Text    ${ELEMENT_2}     Balaji
    Wait Until Element Is Visible    ${ELEMENT_3}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_3}     ${TIMEOUT}
    Click Element    ${ELEMENT_3}
    Wait Until Element Is Visible    ${ELEMENT_4}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_4}     ${TIMEOUT}
    Click Element    ${ELEMENT_4}
    Go To    ${SAVESYSTEMUSER_URL}
    Wait Until Location Contains    /web/index.php/admin/saveSystemUser    ${TIMEOUT}
    Wait Until Element Is Visible    ${ELEMENT_5}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_5}     ${TIMEOUT}
    Input Text    ${ELEMENT_5}     user1
    Wait Until Element Is Visible    ${ELEMENT_6}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_6}     ${TIMEOUT}
    Input Text    ${ELEMENT_6}     ${AUTOCOMPLETE_VALUE}
    Wait Until Element Is Visible    ${ELEMENT_7}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_7}     ${TIMEOUT}
    Input Text    ${ELEMENT_7}     balaji123
    Wait Until Element Is Visible    ${ELEMENT_8}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_8}     ${TIMEOUT}
    Click Element    ${ELEMENT_8}
    Wait Until Element Is Visible    ${ELEMENT_9}     2000 ms
    Wait Until Element Is Visible    ${ELEMENT_10}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_10}     ${TIMEOUT}
    Double Click Element    ${ELEMENT_10}
    Wait Until Element Is Visible    ${ELEMENT_11}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_11}     ${TIMEOUT}
    Input Text    ${ELEMENT_11}     balaji
    Wait Until Element Is Visible    ${ELEMENT_12}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_12}     ${TIMEOUT}
    Input Text    ${ELEMENT_12}     ${AUTOCOMPLETE_VALUE}
    Wait Until Element Is Visible    ${ELEMENT_13}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_13}     ${TIMEOUT}
    Double Click Element    ${ELEMENT_13}
