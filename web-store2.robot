*** Settings ***
Documentation     TS0002 Automated Test Suite
Library           SeleniumLibrary
Library           BuiltIn

Suite Setup       Suite Setup Keywords
Test Setup        Method Setup
Test Teardown     Method Teardown
Suite Teardown    Suite Teardown Keywords


*** Variables ***
${BASE_URL}           https://demowebshop.tricentis.com
${TIMEOUT}            15s
${DELAY}              0.5s
${ELEMENT_1}           link=Books
${ELEMENT_2}           xpath=//div[contains(@class, 'item-box')]/div[contains(@class, 'product-item')]/div[contains(@class, 'picture')]/a/img[@title='Show details for Computing and Internet']


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
        Call Method    ${options}    add_argument    --user-data-dir\=/tmp/chrome_c3533740a3c54dcd9903b961d75aba30
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
    Go To    ${BASE_URL}
    Sleep    2000ms
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
    Set Window Size    1280    720
    Sleep    ${DELAY}
    Go To    ${BASE_URL}
    Wait Until Location Contains    demowebshop.tricentis.com    ${TIMEOUT}
    Wait Until Element Is Visible    ${ELEMENT_1}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_1}     ${TIMEOUT}
    Click Element    ${ELEMENT_1} 
    Wait Until Element Is Visible    ${ELEMENT_2}     ${TIMEOUT}
    Wait Until Element Is Enabled    ${ELEMENT_2}     ${TIMEOUT}
    Click Element    ${ELEMENT_2} 
