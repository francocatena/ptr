const Path              = require('path')
const UglifyJSPlugin    = require('uglifyjs-webpack-plugin')
const CopyWebpackPlugin = require('copy-webpack-plugin')
const ExtractTextPlugin = require('extract-text-webpack-plugin')
const isProduction      = process.env.MIX_ENV === 'prod'

const config = {
  entry: ['./js/app.js', './css/app.scss'],

  devtool: 'source-map',

  output: {
    path:     Path.resolve(__dirname, '../priv/static'),
    filename: 'js/[name].js'
  },

  module: {
    rules: [
      {
        test:    /\.js$/,
        loader:  'babel-loader',
        exclude: [
          /node_modules/,
          /deps/
        ],
        options: {
          presets: ['env']
        }
      },

      {
        test: /\.scss$/,
        use:  ExtractTextPlugin.extract({
          fallback: 'style-loader',
          use:      [
            {
              loader:  'css-loader',
              options: {
                minimize:  isProduction,
                sourceMap: !isProduction
              }
            },

            {
              loader:  'sass-loader',
              options: {
                sourceComments: !isProduction,
                includePaths:   [
                  Path.resolve(__dirname, 'node_modules/bulma'),
                  Path.resolve(__dirname, 'node_modules/font-awesome/scss')
                ]
              }
            }
          ]
        })
      }
    ]
  },

  plugins: [
    new UglifyJSPlugin({ sourceMap: !isProduction }),
    new CopyWebpackPlugin([{ from: './static' }]),
    new ExtractTextPlugin('css/app.css')
  ],

  resolve: {
    alias: {
      phoenix: `${__dirname}/../deps/phoenix/web/static/js/phoenix.js`
    }
  }
}

module.exports = config
