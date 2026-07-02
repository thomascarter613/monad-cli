import { defineConfig } from "vitest/config";

export default defineConfig({
  test: {
    globals: true,
    environment: "node",
    include: [
      "apps/**/*.test.ts",
      "services/**/*.test.ts",
      "packages/**/*.test.ts",
      "libs/**/*.test.ts",
      "tools/**/*.test.ts",
      "tests/**/*.test.ts"
    ],
    exclude: [
      "target/**",
      ".monad/**",
      "node_modules/**"
    ]
  }
});
