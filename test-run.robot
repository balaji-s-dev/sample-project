import os
import time
import shutil
import tempfile
import uuid
from playwright.sync_api import sync_playwright

def suite_setup():
    context = {
        'playwright': None,
        'browser': None,
        'shared_context': None,
        'page': None
    }
    try:
        p = sync_playwright().start()
        context['playwright'] = p
        HEADLESS = os.environ.get('HEADLESS', '1').strip() not in ('0', 'false', 'False')
        chromium_args = [
            "--no-sandbox",
            "--disable-dev-shm-usage",
            "--disable-software-rasterizer",
            "--no-first-run",
            "--disable-extensions",
            "--allow-running-insecure-content",
            "--remote-debugging-port=0",
            "--disable-blink-features=AutomationControlled",
            "--exclude-switches=enable-automation",
            "--disable-infobars"
        ]
        browser = p.chromium.launch(headless=HEADLESS, args=chromium_args)
        context['browser'] = browser if 'browser' in locals() else None
        if context['browser'] is None:
            raise RuntimeError('Playwright browser was not initialized in suite hook.')
        return context
    except Exception as setup_error:
        print(f"Suite setup failed: {setup_error}")
        if 'browser' in locals() and browser:
            try:
                browser.close()
            except Exception:
                pass
        if 'p' in locals() and p:
            try:
                p.stop()
            except Exception:
                pass
        raise

def suite_teardown(context):
    browser = context.get('browser')
    playwright_instance = context.get('playwright')
    try:
        if browser:
            browser.close()
    except Exception as suite_after_error:
        print(f"Suite after hook failed: {suite_after_error}")
    finally:
        page = context.get('page')
        if page:
            try:
                page.close()
            except Exception:
                pass
        shared_context = context.get('shared_context')
        if shared_context:
            try:
                shared_context.close()
            except Exception:
                pass
        if browser:
            try:
                browser.close()
            except Exception:
                pass
        if playwright_instance:
            try:
                playwright_instance.stop()
            except Exception:
                pass
        context['browser'] = None
        context['playwright'] = None
        context['page'] = None
        context['shared_context'] = None

def module_setup(context):
    browser = context.get('browser')
    if browser is None:
        raise RuntimeError('Playwright browser is not initialized. Run suite hooks first.')
    if context.get('shared_context') is None:
        page_context = browser.new_context(
            viewport={'width': 1920, 'height': 1080},
            user_agent='Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36',
            extra_http_headers={
                'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8',
                'Accept-Language': 'en-US,en;q=0.9',
                'Accept-Encoding': 'gzip, deflate, br',
                'Connection': 'keep-alive',
                'Upgrade-Insecure-Requests': '1',
                'Sec-Fetch-Dest': 'document',
                'Sec-Fetch-Mode': 'navigate',
                'Sec-Fetch-Site': 'none',
                'Sec-Fetch-User': '?1',
                'Cache-Control': 'max-age=0'
            }
        )
        page_context.set_default_timeout(60000)
        page_context.set_default_navigation_timeout(60000)
        context['shared_context'] = page_context
    else:
        page_context = context.get('shared_context')

def module_teardown(context):
    print("--- Module Teardown (Runs Once After All Tests) ---")
    shared_context = context.get('shared_context')
    if shared_context:
        try:
            shared_context.close()
        except Exception:
            pass
        context['shared_context'] = None

def method_setup(context):
    print("\n>>> Test Setup (Runs Before Each Test Script) <<<")
    shared_context = context.get('shared_context')
    if shared_context is None:
        raise RuntimeError('Shared browser context is not initialized. Run module_setup first.')
    page = shared_context.new_page()
    page.set_default_timeout(60000)
    page.set_default_navigation_timeout(60000)
    page.add_init_script("""
        Object.defineProperty(navigator, 'webdriver', {
            get: () => undefined
        });
        window.navigator.chrome = {
            runtime: {}
        };
        Object.defineProperty(navigator, 'plugins', {
            get: () => [1, 2, 3, 4, 5]
        });
        Object.defineProperty(navigator, 'languages', {
            get: () => ['en-US', 'en']
        });
    """)
    context['page'] = page
    try:
        shared_context.clear_cookies()
        pass
    except Exception as hook_error:
        try:
            page.close()
        except Exception:
            pass
        context['page'] = None
        raise
    return page

def method_teardown(context):
    page = context.get('page')
    try:
        pass
    finally:
        if page:
            try:
                page.close()
            except Exception:
                pass
        context['page'] = None
    print("<<< Test Teardown (Runs After Each Test Script) >>>")

def test_ts0002(context):
    page = method_setup(context)
    try:
        page.set_viewport_size({ 'width': 1920, 'height': 1080} )
        page.evaluate('window.moveTo(0, 0); window.resizeTo(screen.width, screen.height);')
        page.wait_for_timeout(1000)
        page.goto("https://opensource-demo.orangehrmlive.com/web/index.php/dashboard/index", timeout=30000, wait_until="domcontentloaded")
        page.wait_for_load_state("load", timeout=30000)
        page.wait_for_timeout(2000)
        # Wait for element to be visible before clicking
        page.locator("xpath=//span[contains(@class, 'oxd-text') and normalize-space(.)='Admin']").wait_for(state="visible", timeout=30000)
        page.locator("xpath=//span[contains(@class, 'oxd-text') and normalize-space(.)='Admin']").click(timeout=30000)
        page.wait_for_timeout(500)
        page.goto("https://opensource-demo.orangehrmlive.com/web/index.php/admin/viewSystemUsers", timeout=30000, wait_until="domcontentloaded")
        page.wait_for_load_state("load", timeout=30000)
        page.wait_for_timeout(2000)
        # Wait for element to be visible before typing
        page.locator("xpath=//div[contains(@class, 'oxd-grid-4')]/div[contains(@class, 'oxd-grid-item')]/div[contains(@class, 'oxd-input-group')]/div[2]/input[contains(@class, 'oxd-input')][contains(@class, 'oxd-input')]").wait_for(state="visible", timeout=30000)
        page.locator("xpath=//div[contains(@class, 'oxd-grid-4')]/div[contains(@class, 'oxd-grid-item')]/div[contains(@class, 'oxd-input-group')]/div[2]/input[contains(@class, 'oxd-input')][contains(@class, 'oxd-input')]").fill("Balaji", timeout=30000)
        page.wait_for_timeout(500)
        # Wait for element to be visible before clicking
        page.locator("xpath=//button[contains(@class, 'oxd-button') and normalize-space(.)='Search']").wait_for(state="visible", timeout=30000)
        page.locator("xpath=//button[contains(@class, 'oxd-button') and normalize-space(.)='Search']").click(timeout=30000)
        page.wait_for_timeout(500)
        # Wait for element to be visible before clicking
        page.locator("xpath=//button[contains(@class, 'oxd-button') and normalize-space(.)='Add']").wait_for(state="visible", timeout=30000)
        page.locator("xpath=//button[contains(@class, 'oxd-button') and normalize-space(.)='Add']").click(timeout=30000)
        page.wait_for_timeout(500)
        page.goto("https://opensource-demo.orangehrmlive.com/web/index.php/admin/saveSystemUser", timeout=30000, wait_until="domcontentloaded")
        page.wait_for_load_state("load", timeout=30000)
        page.wait_for_timeout(2000)
        # Wait for element to be visible before typing
        page.locator("xpath=//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input").wait_for(state="visible", timeout=30000)
        page.locator("xpath=//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input").fill("user1", timeout=30000)
        page.wait_for_timeout(500)
        # Wait for element to be visible before typing
        page.locator("xpath=//div[@id='app']/div[contains(@class, 'oxd-layout')]/div[contains(@class, 'oxd-layout-container')]/div[contains(@class, 'oxd-layout-context')]/div[contains(@class, 'orangehrm-background-container')]/div[contains(@class, 'orangehrm-card-container')]/form[contains(@class, 'oxd-form')]/div[contains(@class, 'oxd-form-row')]/div[contains(@class, 'oxd-grid-2')]/div[contains(@class, 'oxd-grid-item')]/div[contains(@class, 'oxd-input-group')]/div[2]/input[contains(@class, 'oxd-input')]").wait_for(state="visible", timeout=30000)
        page.locator("xpath=//div[@id='app']/div[contains(@class, 'oxd-layout')]/div[contains(@class, 'oxd-layout-container')]/div[contains(@class, 'oxd-layout-context')]/div[contains(@class, 'orangehrm-background-container')]/div[contains(@class, 'orangehrm-card-container')]/form[contains(@class, 'oxd-form')]/div[contains(@class, 'oxd-form-row')]/div[contains(@class, 'oxd-grid-2')]/div[contains(@class, 'oxd-grid-item')]/div[contains(@class, 'oxd-input-group')]/div[2]/input[contains(@class, 'oxd-input')]").fill("balajioffl", timeout=30000)
        page.wait_for_timeout(500)
        # Wait for element to be visible before typing
        page.locator("xpath=//div[@id='app']/div[contains(@class, 'oxd-layout')]/div[contains(@class, 'oxd-layout-container')]/div[contains(@class, 'oxd-layout-context')]/div[contains(@class, 'orangehrm-background-container')]/div[contains(@class, 'orangehrm-card-container')]/form[contains(@class, 'oxd-form')]/div[contains(@class, 'oxd-form-row')]/div[contains(@class, 'oxd-grid-2')]/div[contains(@class, 'oxd-grid-item')]/div[contains(@class, 'oxd-input-group')]/div[2]/input[contains(@class, 'oxd-input')]").wait_for(state="visible", timeout=30000)
        page.locator("xpath=//div[@id='app']/div[contains(@class, 'oxd-layout')]/div[contains(@class, 'oxd-layout-container')]/div[contains(@class, 'oxd-layout-context')]/div[contains(@class, 'orangehrm-background-container')]/div[contains(@class, 'orangehrm-card-container')]/form[contains(@class, 'oxd-form')]/div[contains(@class, 'oxd-form-row')]/div[contains(@class, 'oxd-grid-2')]/div[contains(@class, 'oxd-grid-item')]/div[contains(@class, 'oxd-input-group')]/div[2]/input[contains(@class, 'oxd-input')]").fill("balaji123", timeout=30000)
        page.wait_for_timeout(500)
        # Wait for element to be visible before clicking
        page.locator("xpath=//button[contains(@class, 'oxd-button') and normalize-space(.)='Save']").wait_for(state="visible", timeout=30000)
        page.locator("xpath=//button[contains(@class, 'oxd-button') and normalize-space(.)='Save']").click(timeout=30000)
        page.wait_for_timeout(500)
        # Wait for element to be visible
        page.locator("xpath=//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input").wait_for(state="visible", timeout=30000)
        # Wait for element to be visible before double clicking
        page.locator("xpath=//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input").wait_for(state="visible", timeout=30000)
        page.locator("xpath=//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input").dblclick(timeout=30000)
        page.wait_for_timeout(500)
        # Wait for element to be visible before typing
        page.locator("xpath=//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input").wait_for(state="visible", timeout=30000)
        page.locator("xpath=//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input").fill("balaji", timeout=30000)
        page.wait_for_timeout(500)
        # Wait for element to be visible before typing
        page.locator("xpath=//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input").wait_for(state="visible", timeout=30000)
        page.locator("xpath=//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input").fill("balajioffl", timeout=30000)
        page.wait_for_timeout(500)
        # Wait for element to be visible before double clicking
        page.locator("xpath=//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input").wait_for(state="visible", timeout=30000)
        page.locator("xpath=//div[contains(@class, 'oxd-input-group')]/div[2]/div[contains(@class, 'oxd-autocomplete-wrapper')]/div[contains(@class, 'oxd-autocomplete-text-input')]/input").dblclick(timeout=30000)
        page.wait_for_timeout(500)
        print("[PASS] Test script 1 completed successfully!")
    except Exception as e:
        print(f"[FAIL] Test script 1 failed: {e}")
        screenshot_path = os.path.join(tempfile.gettempdir(), f"playwright-screenshot-{int(time.time())}.png")
        if page:
            try:
                page.screenshot(path=screenshot_path, full_page=True)
                print(f"Screenshot saved: {screenshot_path}")
            except Exception as screenshot_error:
                print(f"Failed to capture screenshot: {screenshot_error}")
        raise
    finally:
        method_teardown(context)

def run_all_tests():
    context = suite_setup()
    try:
        module_setup(context)
        try:
            tests = [
                ("Test script 1 - TS0002", test_ts0002),
            ]
            for label, test_fn in tests:
                try:
                    test_fn(context)
                except Exception as test_error:
                    print(f"[ERROR] {label} raised an exception: {test_error}")
                    continue
        finally:
            module_teardown(context)
    finally:
        suite_teardown(context)

if __name__ == "__main__":
    run_all_tests()
