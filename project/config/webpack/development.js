process.env.NODE_ENV = process.env.NODE_ENV || "development";

const environment = require("./environment");

// module.exports = environment.toWebpackConfig();

const SpeedMeasurePlugin = require("speed-measure-webpack-plugin");
const smp = new SpeedMeasurePlugin();

module.exports = smp.wrap(environment.toWebpackConfig());
