const { defineConfig } = require('cypress')

module.exports = defineConfig({
  e2e: {
    baseUrl: "http://web-cypress:3000",
    defaultCommandTimeout: 10000,
    supportFile: "cypress/support/index.js",
  }
})
