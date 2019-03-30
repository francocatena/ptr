/* global module, process, require, __dirname */

const Path                    = require('path')
const CopyWebpackPlugin       = require('copy-webpack-plugin')
const MiniCssExtractPlugin    = require('mini-css-extract-plugin')
const OptimizeCSSAssetsPlugin = require('optimize-css-assets-webpack-plugin')
const UglifyJsPlugin          = require('uglifyjs-webpack-plugin')
const isProduction            = process.env.npm_lifecycle_event === 'build'

module.exports = {
  mode: isProduction ? 'production' : 'development',

  entry: ['./js/app.js', './css/app.scss'],

  devtool: 'source-map',

  optimization: {
    minimizer: [
      new UglifyJsPlugin({cache: true, parallel: true, sourceMap: false}),
      new OptimizeCSSAssetsPlugin()
    ]
  },

  output: {
    path:     Path.resolve(__dirname, '../priv/static'),
    filename: 'js/app.js'
  },

  module: {
    rules: [
      {
        test:    /\.js$/,
        loader:  'babel-loader',
        exclude: [
          /node_modules/,
          /deps/
        ]
      },

      {
        test: /\.scss$/,
        use: [
          MiniCssExtractPlugin.loader,

          {
            loader:  'css-loader',
            options: {
              sourceMap: !isProduction
            }
          },

          {
            loader:  'sass-loader',
            options: {
              sourceMap:      !isProduction,
              sourceComments: !isProduction,
              includePaths:   [
                Path.resolve(__dirname, 'node_modules/bulma')
              ]
            }
          }
        ]
      }
    ]
  },

  plugins: [
    new CopyWebpackPlugin([{from: './static'}]),
    new MiniCssExtractPlugin({filename: 'css/app.css'})
  ],

  resolve: {
    alias: {
      phoenix: `${__dirname}/../deps/phoenix/web/static/js/phoenix.js`
    }
  }
}
