var path = require('path');

module.exports = {
    entry: './src/index.js',
    output: {
        path: __dirname + '/dist',
        filename: 'flipit-components.js',
        library: 'FlipitComponents',
        libraryTarget: 'umd',
        umdNamedDefine: true
    },
    module: {
        loaders: [
        
            // JS & JXS Loader: Babel
            {
                test: /.jsx?$/,
                loader: 'babel-loader',
                exclude: /node_modules/,
                query: {
                  presets: ['es2015', 'react']
                }

            },

            // CSS Loader: style-loader, css-loader, sass-loader
            { test: /\.scss$/, loaders: ['style', 'css', 'sass'], exclude: /node_modules/ },

            // Other Loaders
            { test: /\.(png|jpg)$/, loader: 'file-loader?name=images/[name].[ext]' },
            { test: /\.woff$/, loader: 'file-loader?name=fonts/[name].[ext]' }
        ]
    },
    externals: {
        'react': 'React'
    },
    resolveLoader: { 
        root: path.join(__dirname, 'node_modules')
    },
    resolve: {
        extensions: ['', '.js', '.jsx']
    }
}