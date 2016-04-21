var path = require('path');

module.exports = {
    entry: './index.js',
    output: {
        filename: 'bundle.js'
    },
    module: {
        loaders: [
        
            // JS & JXS Loader: Babel
            {
                test: /.jsx?$/,
                loader: 'babel-loader',
                query: {
                  presets: ['es2015', 'react']
                }

            },
        ]
    },
    externals: {
        'react': 'React',
        'react-dom': 'ReactDOM',
        'flipit-components': 'FlipitComponents' 
		},
    resolve: {
        extensions: ['', '.js', '.jsx']
    }
}