const { defineConfig } = require("cypress");

module.exports = defineConfig({
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    baseUrl: "http://localhost:3000",
    video: false,
    defaultCommandTimeout: 10000,
    env: {
      FAX_API_URL: "http://localhost:4567",
      FAX_API_TOKEN: "dev-secret-token",
      BASIC_AUTH_USERNAME: "username",
      BASIC_AUTH_PASSWORD: "password"
    }
  },
});
