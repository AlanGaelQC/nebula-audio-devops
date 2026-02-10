import { test, expect } from "@playwright/test";

test("loads home", async ({ page }) => {
  await page.goto("/");
  await expect(page.getByRole("heading", { name: "FinLab DevOps" })).toBeVisible();
});

test("add item", async ({ page }) => {
  await page.goto("/");
  const input = page.getByLabel("new-item");
  await input.fill("item-from-e2e");
  await page.getByRole("button", { name: "Agregar" }).click();
  await expect(page.getByText("item-from-e2e")).toBeVisible();
});
