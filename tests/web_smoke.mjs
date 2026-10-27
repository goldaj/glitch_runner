/* CI-only runtime smoke test for the real Godot Web export. No mock gameplay. */
import { chromium } from "playwright";
import fs from "node:fs/promises";

const errors = [];
const browser = await chromium.launch({
  headless: true,
  args: ["--enable-unsafe-swiftshader", "--use-gl=angle", "--use-angle=swiftshader"],
});

try {
  const page = await browser.newPage({ viewport: { width: 1152, height: 648 } });
  page.on("pageerror", (e) => errors.push(String(e)));
  page.on("console", (m) => {
    if (m.type() === "error") errors.push(m.text());
  });

  const response = await page.goto("http://127.0.0.1:8765/", {
    waitUntil: "domcontentloaded",
    timeout: 30_000,
  });
  if (response?.status() !== 200) {
    throw new Error("Could not serve index.html: HTTP " + response?.status());
  }

  // The generated Godot bootstrap removes #status after engine.startGame resolves.
  // An export command succeeding does NOT prove this succeeds in a browser.
  await page.locator("#status").waitFor({ state: "detached", timeout: 90_000 });
  const canvas = await page.locator("#canvas").evaluate((node) => ({
    width: node.width,
    height: node.height,
    visible: !!(node.offsetWidth && node.offsetHeight),
  }));
  if (!canvas.visible || canvas.width < 100 || canvas.height < 100) {
    throw new Error("Game canvas did not become visible at a valid size: " + JSON.stringify(canvas));
  }

  await page.locator("#canvas").click({ position: { x: 400, y: 200 } });
  await page.keyboard.press("1");
  await page.keyboard.down("ArrowRight");
  await page.waitForTimeout(700);
  await page.keyboard.up("ArrowRight");
  await page.keyboard.press("Space");
  await page.keyboard.press("2");
  await page.keyboard.press("r");
  await page.waitForTimeout(300);

  await fs.mkdir("build/web-smoke", { recursive: true });
  await page.screenshot({ path: "build/web-smoke/success.png" });
  if (errors.length) {
    throw new Error("Browser console errors: " + errors.join(" | "));
  }
  console.log("PASS web_smoke: exported Godot engine loaded, canvas visible, keyboard test completed");
} finally {
  await browser.close();
}
