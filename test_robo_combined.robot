*** Settings ***
Library    SeleniumLibrary
Library    webdriver_manager.chrome    WITH NAME   ChromeManager
Library    webdriver_manager.firefox    WITH NAME   GeckoDriverManager
Library    webdriver_manager.microsoft    WITH NAME   EdgeChromiumDriverManager
Library    OperatingSystem

*** Variables ***
${BROWSER_DRIVER_PATH}
${BROWSER}

*** Test Cases ***
TC1
    Open Web Browser    Chrome    https://www.google.com
TC2
    Open Web Browser    Edge    https://www.google.com
TC3
    Open Web Browser    Firefox    https://www.google.com


*** Keywords ***
Install Webdriver And Set Driver Path
    [Documentation]    Installs the webdriver for the specified BROWSER if not available and sets the driver path.
    Log To Console    ${BROWSER}
    ${BROWSER_DRIVER_PATH}=    Run Keyword If    "${BROWSER.lower()}" == "chrome" or "${BROWSER.upper()}" == "CHROME"   Evaluate    webdriver_manager.chrome.ChromeDriverManager().install()
    ...    ELSE IF    "${BROWSER.lower()}" == "firefox" or "${BROWSER.upper()}" == "FIREFOX"   Evaluate    webdriver_manager.firefox.GeckoDriverManager().install()
    ...    ELSE IF    "${BROWSER.lower()}" == "edge" or "${BROWSER.upper()}" == "EDGE"   Evaluate    webdriver_manager.microsoft.EdgeChromiumDriverManager().install()
    ...    ELSE    Fail    Unsupported BROWSER: ${BROWSER}. Supported BROWSERS: Chrome, Firefox, Edge
    Set Global Variable    ${BROWSER_DRIVER_PATH}

Open Web Browser
    [Arguments]    ${BROWSER}    ${url}
    Set Suite Variable    ${BROWSER}
    Install Webdriver And Set Driver Path
    Run Keyword If    "${BROWSER.lower()}" == "chrome" or "${BROWSER.upper()}" == "CHROME" or "${BROWSER.lower()}" == "edge" or "${BROWSER.upper()}" == "EDGE"    Open Chrome Or Edge    ${BROWSER}    ${url}
    ...    ELSE IF    "${BROWSER.lower()}" == "firefox" or "${BROWSER.upper()}" == "FIREFOX"    Open Firefox    ${BROWSER}    ${url}

Open Chrome Or Edge
    [Arguments]    ${BROWSER}    ${url}
    [Documentation]     Open browser with specified options and url
    ${options_object}=   Run Keyword If    "${BROWSER.lower()}" == "chrome" or "${BROWSER.upper()}" == "CHROME"   Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()
    ...    ELSE IF    "${BROWSER.lower()}" == "firefox" or "${BROWSER.upper()}" == "FIREFOX"   Evaluate    sys.modules['selenium.webdriver'].FirefoxOptions()
    ...    ELSE IF    "${BROWSER.lower()}" == "edge" or "${BROWSER.upper()}" == "EDGE"   Evaluate    sys.modules['selenium.webdriver'].EdgeOptions()
    Call Method    ${options_object}    add_argument  --headless
    Call Method    ${options_object}    add_argument  --disable-gpu
    Call Method    ${options_object}    add_argument  --no-sandbox
    Call Method    ${options_object}    add_argument    --disable-dev-shm-usage
    Call Method    ${options_object}    add_argument    --disable-extensions
    Call Method    ${options_object}    add_argument    --no-service-autorun
    Call Method    ${options_object}    add_argument    --incognito
    Create Webdriver    ${BROWSER}    executable_path=${BROWSER_DRIVER_PATH}    options=${options_object}
    Go To    ${url}
    Maximize Browser Window

Open Firefox
    [Arguments]   ${BROWSER}    ${url}
    ${desired_capabilities}=    Create Dictionary
    ...    args    ["--disable-gpu", "--no-sandbox", "--disable-extensions", "--disable-dev-shm-usage", "--no-service-autorun"]
    ...    prefs    {"general.useragent.override": "rC[MtC~0>#<,JVm"}
    Create Webdriver    Firefox    desired_capabilities=${desired_capabilities}    executable_path=${BROWSER_DRIVER_PATH}
    Maximize Browser Window
    Go To    ${url}
