/** @type {import("syncpack").RcFile} */
module.exports = {
  source: [
    "package.json",
    "apps/*/package.json",
    "services/*/package.json",
    "packages/*/package.json",
    "libs/*/package.json",
    "tools/*/package.json"
  ],
  semverGroups: [
    {
      range: "",
      dependencyTypes: ["localPackage"],
      dependencies: ["**"]
    }
  ],
  versionGroups: [
    {
      label: "Keep workspace packages aligned",
      dependencies: ["@monad/**"],
      dependencyTypes: ["dev", "prod", "peer"],
      pinVersion: "workspace:*"
    }
  ]
};
