const preset = require('../../tailwind.workspace.preset');

module.exports = {
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
    "../../../packages/ui/src/**/*.{ts,tsx}"
  ],
  presets: [preset],
};
