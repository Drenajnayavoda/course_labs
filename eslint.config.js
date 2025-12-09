import js from "@eslint/js";

export default [
  js.configs.recommended,
  {
    files: ["docs/**/*.js", "javascripts/**/*.js"],
    languageOptions: {
      sourceType: "module"
    },
    rules: {
      // свои правила при желании
    }
  }
];