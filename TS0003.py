import pytest
import tempfile
import os
import shutil
import uuid
import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

@pytest.fixture(scope="session", autouse=True)
def suite_hooks(pytestconfig):
    driver = None
    wait = None
    unique_profile = None
    try:
        print("\n=== Test Suite Started ===")
        options = Options()
        options.add_argument("--headless")
        options.add_argument("--no-sandbox")
        options.add_argument("--disable-dev-shm-usage")
        options.add_argument("--disable-gpu")
        options.add_argument("--disable-software-rasterizer")
        options.add_argument("--no-first-run")
        options.add_argument("--disable-extensions")
        options.add_argument("--disable-web-security")
        options.add_argument("--allow-running-insecure-content")
        options.add_argument("--remote-debugging-port=0")
        options.add_argument("--user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36")

        unique_profile = f"/tmp/chrome_{uuid.uuid4().hex}"
        os.makedirs(unique_profile, exist_ok=True)
        os.chmod(unique_profile, 0o700)
        options.add_argument(f"--user-data-dir={unique_profile}")

        driver = webdriver.Chrome(options=options)
        driver.maximize_window()
        wait = WebDriverWait(driver, 5)
        pytestconfig._driver = driver
        pytestconfig._wait = wait
        yield
    finally:
        try:
            screenshot_path = f"/tmp/screenshot_{int(time.time())}.png"
            driver.save_screenshot(screenshot_path)
            print(f"Screenshot saved: {screenshot_path}")
        except Exception as e:
            print(f"Failed to capture screenshot: {e}")
        finally:
            if driver:
                driver.quit()
        print("\n=== Test Suite Finished ===")

@pytest.fixture(scope="module", autouse=True)
def module_hooks(pytestconfig):
    print("\n--- Starting Module Tests ---")
    driver = getattr(pytestconfig, '_driver', None)
    wait = getattr(pytestconfig, '_wait', None)
    try:
        yield
    finally:
        print("--- Finished Module Tests ---")

@pytest.fixture(scope="function", autouse=True)
def method_hooks(pytestconfig):
    print("\n>>> Before Each Test <<<")
    driver = getattr(pytestconfig, '_driver', None)
    wait = getattr(pytestconfig, '_wait', None)
    try:
        yield
    finally:
        print("<<< After Each Test >>>")

@pytest.fixture
def driver_fixture(pytestconfig):
    driver = getattr(pytestconfig, '_driver', None)
    if driver is None:
        raise RuntimeError('WebDriver is not initialized. Ensure suite hooks ran successfully.')
    return driver

def test_ts0003(driver_fixture):
    driver = driver_fixture
    wait = WebDriverWait(driver, 15)
    try:
        driver.set_window_size(1920, 1080)
        driver.get("https://www.google.com/")
        wait.until(EC.url_contains("/"))
        assert "/" in driver.current_url
        el = wait.until(EC.element_to_be_clickable((By.LINK_TEXT, "About")))
        el.click()
        el = wait.until(EC.element_to_be_clickable((By.LINK_TEXT, "Help")))
        el.click()
        print("[PASS] Test script 1 completed successfully!")
    except Exception as e:
        print(f"[FAIL] Test script 1 failed: {e}")
        temp_dir = tempfile.gettempdir()
        screenshot_path = os.path.join(temp_dir, f"pytest-screenshot-{os.getpid()}.png")
        if driver:
            try:
                driver.save_screenshot(screenshot_path)
                print(f"Screenshot saved: {screenshot_path}")
            except Exception as se:
                print(f"Failed to capture screenshot: {se}")
        pytest.fail(f"Test script 1 failed: {e}")
