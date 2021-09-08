const { webpackConfig } = require('@rails/webpacker')

console.log(webpackConfig.module.rules)
module.exports = webpackConfig
