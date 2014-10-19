var fs = require('fs'),
    path = require('path');

// var title = "Boxed Mac and Cheese that Doesn't Suck";

// fs.readFile(title + '.txt', function(err, logData) {
    // if (err) throw err;
    
    // var json = recipeToJson(logData.toString());
    // var fileName = title
        // .replace(/[^A-Za-z ]/g, '')
        // .replace(/ /g, '-')
        // .toLowerCase() + '.json';
    
    // fs.writeFile(fileName, JSON.stringify(json));
// });

var from = 'C:\\Users\\Brian\\Dropbox\\Shared\\Brian-Melissa Shared\\MelissaRecipes',
    to = 'C:\\Users\\Brian\\Documents\\GitHub\\recipes-punch\\contents\\recipes';

fs.readdir(from, function(err, files) {
    if(err) throw err;
    
    files.map(function(file) {
        return path.join(from, file);
    }).filter(function(file) {
        return fs.statSync(file).isFile() && isTextFile(file);
    }).forEach(function(file) {
        fs.readFile(file, function(err, fileContents) {
            if (err) throw err;
            
            var json = recipeToJson(fileContents.toString());
            var fileName = path.basename(file, '.txt')
                .replace(/[^A-Za-z\- ]/g, '')
                .replace(/ /g, '-')
                .toLowerCase() + '.json';
            
            fs.writeFile(path.join(to, fileName), JSON.stringify(json));
        });
    });
});


function isTextFile(file){
    return /\.txt/.test(path.extname(file));
}

function recipeToJson(src) {
    if (src == '') return src;
    
    var json = {};
    
    json['datemodified'] = new Date();
    
    var name = src.match(/(Name: )([A-Za-z0-9&' ]+)/);
    if (name != undefined)
    {
        json['name'] = name[2];
        }
    
    var author = src.match(/(Author: )([A-Za-z0-9 ]+)/);
    if (author != undefined)
    {
        json['author'] = author[2];
    }
    
    var comments = src.match(/(Comments: )([A-Za-z0-9 ]+)/);
    if (comments != undefined)
    {
        json['comments'] = comments[2];
    }
    
    var yield = src.match(/(Yield: )([A-Za-z0-9\- ]+)/);
    if (yield != undefined)
    {
        json['yield'] = yield[2];
    }
    
    // ['Name', 'Author', 'Comments', 'Yield'].forEach(function(item, index) {
        // var pattern = '/(' + item + ": )([A-Za-z0-9&'\\- ]+)/";
        // var regex = new RegExp(pattern);
        // var field = src.match(regex);
        // json['koser'] = field;
        // if(field != undefined)
        // {
            // json[item.toLowerCase()] = field[2];
        // }
    // });
    
    var ingredients = src
        .match(/(?:Ingredients:)([\s\S]*)(?=Directions)/)[1]
        .split('\n- ')
        .filter(function(n){ return n.trim() != '' });
    ingredients.forEach(function(item, index){ ingredients[index] = item.trim()});
    json['ingredients'] = ingredients;
    
    var directions = src
        .match(/(?:Directions:)([\s\S]*)(?=Yield)/)[1]
        .split('\n- ')
        .filter(function(n){ return n.trim() != '' });
    directions.forEach(function(item, index){ directions[index] = item.trim()});
    json['instructions'] = directions;
    
    return json;
}